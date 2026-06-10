const ticketBalanceService = require('./ticket-balance.service');
const { success } = require('../../helpers/response');

async function listByProject(req, res, next) {
  try {
    const data = await ticketBalanceService.listByProject(req.params.projectId);
    return res.json(success('Ticket balance list fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function summaryByProject(req, res, next) {
  try {
    const data = await ticketBalanceService.getSummaryByProject(req.params.projectId);
    return res.json(success('Ticket balance summary fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function createTransaction(req, res, next) {
  try {
    const data = await ticketBalanceService.createTransaction(req.body || {});
    return res.status(201).json(success('Ticket balance transaction created', data));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  listByProject,
  summaryByProject,
  createTransaction,
};
