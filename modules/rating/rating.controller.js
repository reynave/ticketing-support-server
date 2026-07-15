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

module.exports = {
  list,
};