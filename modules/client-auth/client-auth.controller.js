const { validationResult } = require('express-validator');
const clientAuthService = require('./client-auth.service');
const { success, failure } = require('../../helpers/response');

async function login(req, res, next) {
  try {
    const ipAddress = req.headers['x-forwarded-for']?.split(',')[0].trim() || req.socket.remoteAddress;
    const userAgent = req.headers['user-agent'] || null;

    const errors = validationResult(req);

    if (!errors.isEmpty()) {
      return res.status(422).json({
        status: false,
        message: 'Validation failed',
        data: errors.array(),
      });
    }

    const result = await clientAuthService.login(req.body.email, req.body.password, ipAddress, userAgent);
    return res.json(success('Login success', result));
  } catch (error) {
    return next(error);
  }
}

async function me(req, res, next) {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return res.status(401).json(failure('Unauthorized'));
    }

    const user = await clientAuthService.getMe(userId);
    return res.json(success('Current user fetched', user));
  } catch (error) {
    return next(error);
  }
}

async function profile(req, res, next) {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return res.status(401).json(failure('Unauthorized'));
    }

    const data = await clientAuthService.getProfile(userId);
    return res.json(success('Profile fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function updateProfile(req, res, next) {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return res.status(401).json(failure('Unauthorized'));
    }

    const errors = validationResult(req);

    if (!errors.isEmpty()) {
      return res.status(422).json({
        status: false,
        message: 'Validation failed',
        data: errors.array(),
      });
    }

    const data = await clientAuthService.updateProfile(userId, req.body || {});
    return res.json(success('Profile updated', data));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  login,
  me,
  profile,
  updateProfile,
};
