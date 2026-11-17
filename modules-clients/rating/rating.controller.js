const ratingService = require('./rating.service');
const { success } = require('../../helpers/response');

async function listMaster(req, res, next) {
  try {
    const data = await ratingService.listRatingMaster(req.query || {});
    return res.json(success('Rating master fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function createRate(req, res, next) {
  try {
    const actorId = req.user?.id ? String(req.user.id) : '';

    if (!actorId) {
      const error = new Error('Unauthorized');
      error.statusCode = 401;
      throw error;
    }

    const data = await ratingService.createRating(req.body || {}, actorId);
    return res.status(201).json(success('Rating submitted', data));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  listMaster,
  createRate,
};