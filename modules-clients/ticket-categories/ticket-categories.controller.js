const ticketCategoriesService = require('./ticket-categories.service');
const { success } = require('../../helpers/response');

async function list(req, res, next) {
  try {
    const data = await ticketCategoriesService.listTicketCategories(req.query || {});
    return res.json(success('Ticket categories fetched', data));
  } catch (error) {
    return next(error);
  }
}

module.exports = {
  list,
};