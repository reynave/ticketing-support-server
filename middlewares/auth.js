const jwt = require('jsonwebtoken');
const { failure } = require('../helpers/response');

function auth(req, res, next) {
  const authorization = req.headers.authorization || '';
  const [scheme, token] = authorization.split(' ');

  if (scheme === 'Bearer' && token) {
    try {
      const payload = jwt.verify(token, process.env.JWT_SECRET || 'change-this-secret');
      req.user = payload;
      return next();
    } catch (error) {
      if (process.env.PRODUCTION === 'true') {
        return res.status(401).json(failure('Invalid token'));
      }
    }
  } else{
    if (process.env.PRODUCTION === 'true') {
      return res.status(401).json(failure('Unauthorized'));
    }

    const devUserId = req.headers['x-user-id'];
    if (devUserId) {
      req.user = { id: String(devUserId) };
    }
  }

  return next();
}

module.exports = auth;
