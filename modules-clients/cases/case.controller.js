const caseService = require('./case.service');
const { success } = require('../../helpers/response');

const CASE_TYPE_ID = 2;

function parseId(id) {
  if (!id || !String(id).trim()) {
    const error = new Error('Invalid id parameter');
    error.statusCode = 400;
    throw error;
  }

  return String(id).trim();
}

function getUserId(req) {
  return req.user?.id ? String(req.user.id) : '';
}

async function list(req, res, next) {
  try {
    const query = {
      ...(req.query || {}),
      ticketTypeId: CASE_TYPE_ID,
      userId: getUserId(req),
    };

    const data = await caseService.listTicketsForClient(query);
    return res.json(success('Case list fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function listClosed(req, res, next) {
  try {
    const query = {
      ...(req.query || {}),
      ticketTypeId: CASE_TYPE_ID,
      userId: getUserId(req),
    };

    const data = await caseService.listTicketsForClientClosed(query);
    return res.json(success('Case history fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function detail(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const userId = getUserId(req);

    const access = await caseService.listTicketsForClientUser(id, userId);
    if (!Array.isArray(access) || access.length === 0) {
      const error = new Error('Forbidden');
      error.statusCode = 403;
      throw error;
    }

    const data = await caseService.getTicketDetail(id);
    return res.json(success('Case detail fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function detailLogs(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await caseService.getTicketLogs(id);
    return res.json(success('Case logs fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function create(req, res, next) {
  try {
    const userId = getUserId(req);

    if (!userId) {
      const error = new Error('Unauthorized');
      error.statusCode = 401;
      throw error;
    }

    const payload = {
      ...(req.body || {}),
      ticketTypeId: CASE_TYPE_ID,
      submitBy: userId,
    };

    const data = await caseService.createTicket(payload);
    return res.status(201).json(success('Case created', data));
  } catch (error) {
    return next(error);
  }
}

async function updateStatusByClient(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const submitBy = getUserId(req);

    if (!submitBy) {
      const error = new Error('Unauthorized');
      error.statusCode = 401;
      throw error;
    }

    const data = await caseService.updateCaseStatusByClient(id, req.body?.ticketStatusId, submitBy);
    return res.json(success('Case status updated', data));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  list,
  listClosed,
  detail,
  detailLogs,
  create,
  updateStatusByClient,
};