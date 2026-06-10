const { validationResult } = require('express-validator');
const authService = require('./auth.service');
const { success } = require('../../helpers/response');

async function login(req, res, next) {
  try {
    const errors = validationResult(req);

    if (!errors.isEmpty()) {
      return res.status(422).json({
        status: false,
        message: 'Validation failed',
        data: errors.array(),
      });
    }

    const result = await authService.login(req.body.email, req.body.password);
    return res.json(success('Login success', result));
  } catch (error) {
    return next(error);
  }
}

async function me(req, res, next) {
  try {
    const user = await authService.getMe(req.user.id);
    return res.json(success('Current user fetched', user));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  login,
  me,
};
