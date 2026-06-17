const ticketService = require('./ticket.service');
const { success } = require('../../helpers/response');

function parseId(id) {
  if (!id || !String(id).trim()) {
    const error = new Error('Invalid id parameter');
    error.statusCode = 400;
    throw error;
  }

  return String(id).trim();
}

async function list(req, res, next) {
  try {
    const data = await ticketService.listTickets(req.query);
    return res.json(success('Ticket list fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function detail(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await ticketService.getTicketDetail(id);
    return res.json(success('Ticket detail fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function detailLogs(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await ticketService.getTicketLogs(id);
    return res.json(success('Ticket logs fetched', data));
  } catch (error) {
    return next(error);
  }
}


async function create(req, res, next) {
  try {
    const data = await ticketService.createTicket(req.body || {});
    return res.status(201).json(success('Ticket created', data));
  } catch (error) {
    return next(error);
  }
}

async function createLog(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await ticketService.createTicketLog(req.body || {});
    return res.status(201).json(success('Ticket log created', data));
  } catch (error) {
    return next(error);
  }
}

async function update(req, res, next) {
  try {
    const id = parseId(req.params.id);
    console.log('update ticket payload', req.body);
    const data = await ticketService.updateTicket(id, req.body || {});
    return res.json(success('Ticket updated', data));
  } catch (error) {
    return next(error);
  }
}

async function remove(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await ticketService.deleteTicket(id);
    return res.json(success('Ticket deleted', data));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  list,
  detail,
  create,
  update,
  remove,
  createLog,
  detailLogs,
};
