const productMasterService = require('./product-master.service');
const { success } = require('../../helpers/response');

async function list(req, res, next) {
  try {
    const data = await productMasterService.listProducts(req.query || {});
    return res.json(success('Product master fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function detail(req, res, next) {
  try {
    const data = await productMasterService.getProductDetail(req.params.id);
    return res.json(success('Product master detail fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function create(req, res, next) {
  try {
    const actorId = req.user?.id ? Number(req.user.id) || 1 : 1;
    const data = await productMasterService.createProduct(req.body || {}, actorId);
    return res.status(201).json(success('Product master created', data));
  } catch (error) {
    return next(error);
  }
}

async function update(req, res, next) {
  try {
    const actorId = req.user?.id ? Number(req.user.id) || 1 : 1;
    const data = await productMasterService.updateProduct(req.params.id, req.body || {}, actorId);
    return res.json(success('Product master updated', data));
  } catch (error) {
    return next(error);
  }
}

async function remove(req, res, next) {
  try {
    const actorId = req.user?.id ? Number(req.user.id) || 1 : 1;
    const data = await productMasterService.deleteProduct(req.params.id, actorId);
    return res.json(success('Product master deleted', data));
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
