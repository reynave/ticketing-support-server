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

async function create(req, res, next) {
  try {
    const actorId = req.user?.id ? String(req.user.id) : '1';
    const data = await projectMasterService.createProject(req.body || {}, actorId);
    return res.status(201).json(success('Project master created', data));
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


module.exports = {
  list,
  detail,
  create,
  update,
  remove,
  addContact,
  removeContact,
};
