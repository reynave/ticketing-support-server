const ticketBalanceService = require('./ticket-balance.service');
const { success } = require('../../helpers/response');

async function listByProject(req, res, next) {
  try {
    const projectId = req.params.projectId;
    const userId = req.user?.id ? String(req.user.id) : '';

    const canAccess = await ticketBalanceService.canClientAccessProject(projectId, userId);
    if (!canAccess) {
      const error = new Error('Forbidden');
      error.statusCode = 403;
      throw error;
    }

    const data = await ticketBalanceService.listByProject(projectId);
    return res.json(success('Ticket balance list fetched', data));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  listByProject,
};