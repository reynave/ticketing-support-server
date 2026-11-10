const projectMasterService = require('./project.service');
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
    const userId = req.user?.id ? String(req.user.id) : '';
    const query = {
      ...(req.query || {}),
      userId,
    };

    // Client users (userTypeId = 2) can only view projects of their own client where they are a contact.
    if (req.user?.userTypeId === 2) {
      query.clientId = req.user.clientId;
      query.contactUserId = req.user.id;
      delete query.userId;
    }

    console.log('listProjects userId:', userId);
    const data = await projectMasterService.listProjects(query);
    return res.json(success('Project master list fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function listDrafts(req, res, next) {
  try {
    const userId = req.user?.id ? String(req.user.id) : '';
    const data = await projectMasterService.listProjectDrafts({ userId });
    return res.json(success('Project drafts fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function detail(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await projectMasterService.getProjectDetail(id);

    // Client users (userTypeId = 2) can only view their own client's project, and only if listed as a contact.
    if (req.user?.userTypeId === 2) {
      const isSameClient = String(data?.clientId) === String(req.user.clientId);
      const contacts = Array.isArray(data?.contacts) ? data.contacts : [];
      const isContact = contacts.some((contact) => String(contact?.userId) === String(req.user.id));

      if (!isSameClient || !isContact) {
        const error = new Error('Forbidden');
        error.statusCode = 403;
        throw error;
      }
    }

    return res.json(success('Project master detail fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function ticketList(req, res, next) {
  try { 
    const userId = req.user?.id ? String(req.user.id) : '';
  
    const filters = {
      ...(req.query || {}),
      userId,
    };

    const data = await projectMasterService.ticketList(filters);
    return res.json(success('Ticket list() fetched', data));
  } catch (error) {
    return next(error);
  }
}


async function draftTaskList(req, res, next) {
  try {
    const filters = {
      ...(req.query || {}),
      ticketTypeId: req.query?.ticketTypeId ?? 1,
    };

    const data = await projectMasterService.draftTaskList(filters);
    return res.json(success('Draft task list fetched', data));
  } catch (error) {
    return next(error);
  }
}


async function createProjectDraftTask(req, res, next) {
  try {
    const projectId = String(req.body?.projectId || '').trim();

    if (!projectId) {
      const error = new Error('projectId is required');
      error.statusCode = 400;
      throw error;
    }

    const actorId = req.user?.id ? String(req.user.id) : '';

    if (!actorId) {
      const error = new Error('Unauthorized');
      error.statusCode = 401;
      throw error;
    }

    const data = await projectMasterService.createProjectDraftTask(projectId, req.body || {}, actorId);
    return res.status(201).json(success('Draft task created', data));
  } catch (error) {
    return next(error);
  }
}


async function updateProjectDraftTask(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const actorId = req.user?.id ? String(req.user.id) : '';

    if (!actorId) {
      const error = new Error('Unauthorized');
      error.statusCode = 401;
      throw error;
    }

    const data = await projectMasterService.updateProjectDraftTask(id, req.body || {}, actorId);
    return res.json(success('Draft task updated', data));
  } catch (error) {
    return next(error);
  }
}

async function deleteProjectDraftTask(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const actorId = req.user?.id ? String(req.user.id) : '';

    if (!actorId) {
      const error = new Error('Unauthorized');
      error.statusCode = 401;
      throw error;
    }

    const data = await projectMasterService.deleteProjectDraftTask(id, actorId);
    return res.json(success('Draft task deleted', data));
  } catch (error) {
    return next(error);
  }
}


async function reorderDraftTasks(req, res, next) {
  try {
    const actorId = req.user?.id ? String(req.user.id) : '';

    if (!actorId) {
      const error = new Error('Unauthorized');
      error.statusCode = 401;
      throw error;
    }

    const items = Array.isArray(req.body?.items) ? req.body.items : [];
    const data = await projectMasterService.reorderProjectDraftTasks(items, actorId);
    return res.json(success('Draft tasks reordered', data));
  } catch (error) {
    return next(error);
  }
}


async function create(req, res, next) {
  try {
    const actorId = req.user?.id ? String(req.user.id) : '1';
    const data = await projectMasterService.createProject(req.body || {}, actorId);
    return res.status(201).json(success('Project master created', data));
  } catch (error) {
    return next(error);
  }
}

async function createDraft(req, res, next) {
  try {
    const actorId = req.user?.id ? String(req.user.id) : '1';
    const data = await projectMasterService.createProjectDraft(actorId);
    return res.status(201).json(success('Project draft created', data));
  } catch (error) {
    return next(error);
  }
}

async function update(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const actorId = req.user?.id ? String(req.user.id) : '1';
    const data = await projectMasterService.updateProject(id, req.body || {}, actorId);
    return res.json(success('Project master updated', data));
  } catch (error) {
    return next(error);
  }
}

async function remove(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const actorId = req.user?.id ? String(req.user.id) : '1';
    const data = await projectMasterService.deleteProject(id, actorId);
    return res.json(success('Project master deleted', data));
  } catch (error) {
    return next(error);
  }
}

async function addContact(req, res, next) {
  try {
    const actorId = req.user?.id ? String(req.user.id) : '1';
    req.body.actorId = actorId;
    const data = await projectMasterService.addContactToProject(req.body || {});
    return res.status(201).json(success('Contact added to project', data));
  } catch (error) {
    return next(error);
  }
}

async function removeContact(req, res, next) {
  try {
    const actorId = req.user?.id ? String(req.user.id) : '1';
    req.body.actorId = actorId;
    const data = await projectMasterService.removeContactFromProject(req.body || {});
    return res.json(success('Contact removed from project', data));
  } catch (error) {
    return next(error);
  }
}


async function createProjectTask(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const actorId = req.user?.id ? String(req.user.id) : '';

    if (!actorId) {
      const error = new Error('Unauthorized');
      error.statusCode = 401;
      throw error;
    }

    const data = await projectMasterService.createProjectTask(id, req.body || {}, actorId);
    return res.status(201).json(success('Task created', data));
  } catch (error) {
    return next(error);
  }
}

async function reorderTasks(req, res, next) {
  try {
    const actorId = req.user?.id ? String(req.user.id) : '';

    if (!actorId) {
      const error = new Error('Unauthorized');
      error.statusCode = 401;
      throw error;
    }

    const items = Array.isArray(req.body?.items) ? req.body.items : [];
    const data = await projectMasterService.reorderProjectTasks(items, actorId);
    return res.json(success('Tasks reordered', data));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  list,
  listDrafts,
  detail,
  create,
  createDraft,
  update,
  remove,
  addContact,
  removeContact,
  ticketList,
  draftTaskList,
  createProjectDraftTask,
  updateProjectDraftTask,
  deleteProjectDraftTask,
  reorderDraftTasks,
  createProjectTask,
  reorderTasks,
};
