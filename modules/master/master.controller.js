const masterService = require('./master.service');
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
    console.log('Query parameters:', req.query);
    const data = await masterService.getMasterData(req.params.masterKey, req.query);
    return res.json(success('Master data fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function detail(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await masterService.getMasterDetail(req.params.masterKey, id);
    return res.json(success('Master data detail fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function create(req, res, next) {
  try {
    const data = await masterService.createMasterData(req.params.masterKey, req.body || {});
    return res.status(201).json(success('Master data created', data));
  } catch (error) {
    return next(error);
  }
}

async function update(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await masterService.updateMasterData(req.params.masterKey, id, req.body || {});
    return res.json(success('Master data updated', data));
  } catch (error) {
    return next(error);
  }
}

async function remove(req, res, next) {
  try {
    const id = parseId(req.params.id);
    const data = await masterService.deleteMasterData(req.params.masterKey, id);
    return res.json(success('Master data deleted', data));
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
