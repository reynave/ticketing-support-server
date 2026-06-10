const jwt = require('jsonwebtoken');
const { failure } = require('../helpers/response');

function auth(req, res, next) {
  const authorization = req.headers.authorization || '';
  const [scheme, token] = authorization.split(' ');

  if (scheme !== 'Bearer' || !token) {
    return res.status(401).json(failure('Unauthorized'));
  }

  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET || 'change-this-secret');
    req.user = payload;
    return next();
  } catch (error) {
    return res.status(401).json(failure('Invalid token'));
  }
}

module.exports = auth;
