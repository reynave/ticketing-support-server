const userService = require('./user.service');
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
    const data = await userService.listUsers(req.query);
    return res.json(success('User list fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function detail(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await userService.getUserDetail(id);
    return res.json(success('User detail fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function create(req, res, next) {
  try {
    const data = await userService.createUser(req.body || {});
    return res.status(201).json(success('User created', data));
  } catch (error) {
    return next(error);
  }
}

async function update(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await userService.updateUser(id, req.body || {});
    return res.json(success('User updated', data));
  } catch (error) {
    return next(error);
  }
}

async function remove(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await userService.deleteUser(id);
    return res.json(success('User deleted', data));
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
