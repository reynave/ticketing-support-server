const caseService = require('./case.service');
const { success } = require('../../helpers/response');
const { runMiddleware, upload } = require('../../middlewares/upload.middleware');
const CASE_TYPE_ID = 2;

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
    const query = {
      ...(req.query || {}),
      ticketTypeId: CASE_TYPE_ID,
    };
    const data = await caseService.listTickets(query);
    return res.json(success('Case list fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function detail(req, res, next) {
  try {
    const id = parseId(req.params.id);
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

async function listTasks(req, res, next) {
  try {
    const caseId = parseId(req.params.id);
    const data = await caseService.listRelatedTasks(caseId, req.query || {});
    return res.json(success('Case related tasks fetched', data));
  } catch (error) {
    return next(error);
  }
}


async function create(req, res, next) {
  try {
    const payload = {
      ...(req.body || {}),
      ticketTypeId: CASE_TYPE_ID,
    };

    console.log('create case payload', payload);
    const data = await caseService.createTicket(payload);
    return res.status(201).json(success('Case created', data));
  } catch (error) {
    return next(error);
  }
}

async function createTask(req, res, next) {
  try {
    const caseId = parseId(req.params.id);
    const data = await caseService.createRelatedTask(caseId, req.body || {});
    return res.status(201).json(success('Case related task created', data));
  } catch (error) {
    return next(error);
  }
}

async function createLog(req, res, next) {
  try {
    const id = parseId(req.params.id);
    // Handle multipart/form-data (text fields + files)
    await runMiddleware(req, res, upload.array('files', 20));
    const files = req.files || [];
    const payload = {
      ...(req.body || {}),
      ticketId: id,
    };
    const data = await caseService.createTicketLog(payload, files, req);
    return res.status(201).json(success('Case log created', data));
  } catch (error) {
    return next(error);
  }
}

async function update(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const payload = {
      ...(req.body || {}),
      ticketTypeId: CASE_TYPE_ID,
    };
    console.log('update case payload', payload);
    const data = await caseService.updateTicket(id, payload);
    return res.json(success('Case updated', data));
  } catch (error) {
    return next(error);
  }
}

async function submitRate(req, res, next) {
  try {
    const id = parseId(req.params.id);
    console.log('update case payload', req.body);
    const data = await caseService.submitRateService(id, req.body || {});
    return res.json(success('Case updated', data));
  } catch (error) {
    return next(error);
  }
}

async function remove(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await caseService.deleteTicket(id);
    return res.json(success('Case deleted', data));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  list,
  detail,
  create,
  createTask,
  update,
  remove,
  createLog,
  detailLogs,
  listTasks,
  submitRate
};
