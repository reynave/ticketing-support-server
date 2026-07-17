const ratingService = require('./rating.service');
const { success } = require('../../helpers/response');

async function list(req, res, next) {
  try {
    const data = await ratingService.listRatings(req.query || {});
    return res.json(success('Rating list fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function listMaster(req, res, next) {
  try {
    const data = await ratingService.listRatingMaster(req.query || {});
    return res.json(success('Rating master fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function detailMaster(req, res, next) {
  try {
    const data = await ratingService.getRatingMasterDetail(req.params.id);
    return res.json(success('Rating master detail fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function createMaster(req, res, next) {
  try {
    const data = await ratingService.createRatingMaster(req.body || {});
    return res.status(201).json(success('Rating master created', data));
  } catch (error) {
    return next(error);
  }
}

async function updateMaster(req, res, next) {
  try {
    const data = await ratingService.updateRatingMaster(req.params.id, req.body || {});
    return res.json(success('Rating master updated', data));
  } catch (error) {
    return next(error);
  }
}

async function removeMaster(req, res, next) {
  try {
    const data = await ratingService.deleteRatingMaster(req.params.id);
    return res.json(success('Rating master deleted', data));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  list,
  listMaster,
  detailMaster,
  createMaster,
  updateMaster,
  removeMaster,
};