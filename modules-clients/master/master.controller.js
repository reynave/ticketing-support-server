const masterService = require('./master.service');
const { success } = require('../../helpers/response');

async function statusCases(req, res, next) {
  try {
    const data = await masterService.listStatusCases();
    return res.json(success('Cases status fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function ticketSeverities(req, res, next) {
  try {
    const data = await masterService.listTicketSeverities();
    return res.json(success('Ticket severities fetched', data));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  statusCases,
  ticketSeverities,
};