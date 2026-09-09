const clientTicketService = require('./client-ticket.service');
const { success } = require('../../helpers/response');

async function listCases(req, res, next) {
  try {
    const filters = {
      ...(req.query || {}),
      userId: req.user?.id ? String(req.user.id) : '',
    };

    const data = await clientTicketService.listCases(filters);
    return res.json(success('Case list fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function listChangeRequests(req, res, next) {
  try {
    const filters = {
      ...(req.query || {}),
      userId: req.user?.id ? String(req.user.id) : '',
    };

    const data = await clientTicketService.listChangeRequests(filters);
    return res.json(success('Change request list fetched', data));
  } catch (error) {
    return next(error);
  }
}
async function getClientBalance(req, res, next) {
  try {
    const projectId = req.params.projectId;
    const userId = req.user?.id ? String(req.user.id) : '';

    const data = await clientTicketService.getClientBalance({ projectId, userId });
    return res.json(success('Client balance fetched', data));
  } catch (error) {
    return next(error);
  }
}


module.exports = {
  listCases,
  listChangeRequests,
  getClientBalance,
};
