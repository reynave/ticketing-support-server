const projectService = require('./project.service');
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
    const data = await projectService.listProjects(req.query);
    return res.json(success('Project list fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function detail(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await projectService.getProjectDetail(id);
    return res.json(success('Project detail fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function create(req, res, next) {
  try {
    const data = await projectService.createProject(req.body || {});
    return res.status(201).json(success('Project created', data));
  } catch (error) {
    return next(error);
  }
}

async function update(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await projectService.updateProject(id, req.body || {});
    return res.json(success('Project updated', data));
  } catch (error) {
    return next(error);
  }
}

async function remove(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await projectService.deleteProject(id);
    return res.json(success('Project deleted', data));
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
};
