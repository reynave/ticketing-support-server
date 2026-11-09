const checklistService = require('./checklist.service');
const { success } = require('../../helpers/response');

function parseId(id) {
  if (!id || !String(id).trim()) {
    const error = new Error('Invalid id parameter');
    error.statusCode = 400;
    throw error;
  }

  return String(id).trim();
}

function getActorId(req) {
  const actorId = req.user?.id ? String(req.user.id) : '';

  if (!actorId) {
    const error = new Error('Unauthorized');
    error.statusCode = 401;
    throw error;
  }

  return actorId;
}

async function list(req, res, next) {
  try {
    const ticketId = parseId(req.params.ticketId);
    const data = await checklistService.listChecklist(ticketId);
    return res.json(success('Checklist fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function create(req, res, next) {
  try {
    const actorId = getActorId(req);
    const data = await checklistService.createChecklistItem(req.body || {}, actorId);
    return res.status(201).json(success('Checklist item created', data));
  } catch (error) {
    return next(error);
  }
}

async function update(req, res, next) {
  try {
    const actorId = getActorId(req);
    const id = parseId(req.params.id);
    const data = await checklistService.updateChecklistItem(id, req.body || {}, actorId);
    return res.json(success('Checklist item updated', data));
  } catch (error) {
    return next(error);
  }
}

async function remove(req, res, next) {
  try {
    const actorId = getActorId(req);
    const id = parseId(req.params.id);
    const data = await checklistService.deleteChecklistItem(id, actorId);
    return res.json(success('Checklist item deleted', data));
  } catch (error) {
    return next(error);
  }
}

async function reorder(req, res, next) {
  try {
    const actorId = getActorId(req);
    const items = Array.isArray(req.body?.items) ? req.body.items : [];
    const data = await checklistService.reorderChecklist(items, actorId);
    return res.json(success('Checklist reordered', data));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  list,
  create,
  update,
  remove,
  reorder,
};