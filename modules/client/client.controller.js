const clientService = require('./client.service');
const { success } = require('../../helpers/response');

function parseId(id) {
  const parsed = Number(id);

  if (!Number.isInteger(parsed) || parsed < 1) {
    const error = new Error('Invalid id parameter');
    error.statusCode = 400;
    throw error;
  }

  return parsed;
}

async function list(req, res, next) {
  try {
    const data = await clientService.listClients(req.query);
    return res.json(success('Client list fetched', data));
  } catch (error) {
    return next(error);
  }
}
async function listProjects(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await clientService.listClientProjects(id);
    return res.json(success('Client projects fetched', data));
  } catch (error) {
    return next(error);
  }
}
async function detail(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await clientService.getClientDetail(id);
    return res.json(success('Client detail fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function create(req, res, next) {
  try {
    const data = await clientService.createClient(req.body || {});
    return res.status(201).json(success('Client created', data));
  } catch (error) {
    return next(error);
  }
}

async function update(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await clientService.updateClient(id, req.body || {});
    return res.json(success('Client updated', data));
  } catch (error) {
    return next(error);
  }
}

async function remove(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await clientService.deleteClient(id);
    return res.json(success('Client deleted', data));
  } catch (error) {
    return next(error);
  }
}

async function listUsers(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await clientService.listClientUsers(id);
    return res.json(success('Client users fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function createUser(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await clientService.createClientUser(id, req.body || {});
    return res.status(201).json(success('Client user created', data));
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
  listUsers,
  createUser,
  listProjects,
};
