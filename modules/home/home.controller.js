const homeService = require('./home.service');
const { success } = require('../../helpers/response');

async function dashboard(req, res, next) {
  try {
    const selectedUserId = req.query?.userId && String(req.query.userId).trim()
      ? String(req.query.userId).trim()
      : '';

    const user = {
      userId: selectedUserId || (req.user?.id ? String(req.user.id) : ''),
    };

    const data = await homeService.getDashboard(user);
    return res.json(success('Home dashboard data fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function projectUsers(req, res, next) {
  try {
    const data = await homeService.listProjectUsers();
    return res.json(success('Project users fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function reorder(req, res, next) {
  try {
    const ticketTypeId = Number(req.body?.ticketTypeId);
    const ids = req.body?.ids;

    if (![1, 2, 3].includes(ticketTypeId)) {
      const error = new Error('ticketTypeId must be 1, 2, or 3');
      error.statusCode = 400;
      throw error;
    }

    if (!Array.isArray(ids) || ids.length === 0) {
      const error = new Error('ids must be a non-empty array');
      error.statusCode = 400;
      throw error;
    }

    const data = await homeService.updateSorting(ticketTypeId, ids);
    return res.json(success('Sorting updated', data));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  dashboard,
  projectUsers,
  reorder,
};
