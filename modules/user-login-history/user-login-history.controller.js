const userLoginHistoryService = require('./user-login-history.service');
const { success } = require('../../helpers/response');

async function list(req, res, next) {
  try {
    const data = await userLoginHistoryService.listUserLoginHistory(req.query || {});
    return res.json(success('User login history fetched', data));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  list,
};
