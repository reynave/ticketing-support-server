const changeRequestService = require('./change-request.service');
const { success } = require('../../helpers/response');
const { runMiddleware, upload } = require('../../middlewares/upload.middleware');
const CHANGE_REQUEST_TYPE_ID = 3;

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

    const userId = req.user?.id ? String(req.user.id) : '';
   
    const query = {
      ...(req.query || {}),
      ticketTypeId: CHANGE_REQUEST_TYPE_ID,
       userId,
    };
   

     // Client users (userTypeId = 2) can only view cases assigned to themselves.
    let data;
    if (req.user?.userTypeId === 1 ) {
      data = await changeRequestService.listTickets(query);
    } else {
       data = await changeRequestService.listTicketsForClient(query);
    }


    return res.json(success('Case list fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function detail(req, res, next) {
  try {
    const id = parseId(req.params.id);
 
    const users = await changeRequestService.listTicketsForClientUser(id, String(req.user.id) );
     
    // Client users (userTypeId = 2) can only view cases assigned to themselves.
    if (req.user?.userTypeId === 2 && users[0]?.userId !== String(req.user.id)) {
      const error = new Error('Forbidden');
      error.statusCode = 403;
      throw error;
    }
   const data = await changeRequestService.getTicketDetail(id);
    return res.json(success('Case detail fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function detailLogs(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await changeRequestService.getTicketLogs(id);
    return res.json(success('Case logs fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function listTasks(req, res, next) {
  try {
    const caseId = parseId(req.params.id);
    const data = await changeRequestService.listRelatedTasks(caseId, req.query || {});
    return res.json(success('Case related tasks fetched', data));
  } catch (error) {
    return next(error);
  }
}


async function create(req, res, next) {
  try {
    const payload = {
      ...(req.body || {}),
      ticketTypeId: CHANGE_REQUEST_TYPE_ID,
    };
 
    const data = await changeRequestService.createTicket(payload);
    return res.status(201).json(success('Case created', data));
  } catch (error) {
    return next(error);
  }
}

async function createTask(req, res, next) {
  try {
    const caseId = parseId(req.params.id);
    const data = await changeRequestService.createRelatedTask(caseId, req.body || {});
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
    const data = await changeRequestService.createTicketLog(payload, files, req);
    return res.status(201).json(success('Case log created', data));
  } catch (error) {
    return next(error);
  }
}

async function updateStatusByClient(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const submitBy = req.user?.id ? String(req.user.id) : '';

    if (!submitBy) {
      const error = new Error('Unauthorized');
      error.statusCode = 401;
      throw error;
    }

    // Client users (userTypeId = 2) can only update cases assigned to themselves.
    if (req.user?.userTypeId === 2) {
      const current = await changeRequestService.getTicketDetail(id);
      if (String(current?.assignTo) !== submitBy) {
        const error = new Error('Forbidden');
        error.statusCode = 403;
        throw error;
      }
    }

    const data = await changeRequestService.updateCaseStatusByClient(id, req.body?.ticketStatusId, submitBy);
    return res.json(success('Case status updated', data));
  } catch (error) {
    return next(error);
  }
}

async function update(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const payload = {
      ...(req.body || {}),
      ticketTypeId: CHANGE_REQUEST_TYPE_ID,
    }; 
    const data = await changeRequestService.updateTicket(id, payload);
    return res.json(success('Case updated', data));
  } catch (error) {
    return next(error);
  }
}

async function submitRate(req, res, next) {
  try {
    const id = parseId(req.params.id); 
    const data = await changeRequestService.submitRateService(id, req.body || {});
    return res.json(success('Case updated', data));
  } catch (error) {
    return next(error);
  }
}

async function remove(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await changeRequestService.deleteTicket(id);
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
  updateStatusByClient,
  remove,
  createLog,
  detailLogs,
  listTasks,
  submitRate
};
