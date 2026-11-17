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

function getUserId(req) {
  return req.user?.id ? String(req.user.id) : '';
}

async function list(req, res, next) {
  try {
    const query = {
      ...(req.query || {}),
      userId: getUserId(req),
    };

    const data = await projectService.listProjectsForClient(query);
    return res.json(success('Project list fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function detail(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const userId = getUserId(req);

    const canAccess = await projectService.canClientAccessProject(id, userId);
    if (!canAccess) {
      const error = new Error('Forbidden');
      error.statusCode = 403;
      throw error;
    }

    const data = await projectService.getProjectDetail(id);
    return res.json(success('Project detail fetched', data));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  list,
  detail,
};