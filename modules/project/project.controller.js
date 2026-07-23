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
    const data = await projectMasterService.listProjects(req.query || {});
    return res.json(success('Project master list fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function detail(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await projectMasterService.getProjectDetail(id);
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
