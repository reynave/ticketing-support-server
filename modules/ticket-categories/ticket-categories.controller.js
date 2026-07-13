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

async function detail(req, res, next) {
  try {
    const data = await ticketCategoriesService.getTicketCategoryDetail(req.params.id);
    return res.json(success('Ticket category detail fetched', data));
  } catch (error) {
    return next(error);
  }
}

async function create(req, res, next) {
  try {
    const actorId = req.user?.id ? Number(req.user.id) || 1 : 1;
    const data = await ticketCategoriesService.createTicketCategory(req.body || {}, actorId);
    return res.status(201).json(success('Ticket category created', data));
  } catch (error) {
    return next(error);
  }
}

async function update(req, res, next) {
  try {
    const actorId = req.user?.id ? Number(req.user.id) || 1 : 1;
    const data = await ticketCategoriesService.updateTicketCategory(req.params.id, req.body || {}, actorId);
    return res.json(success('Ticket category updated', data));
  } catch (error) {
    return next(error);
  }
}

async function remove(req, res, next) {
  try {
    const actorId = req.user?.id ? Number(req.user.id) || 1 : 1;
    const data = await ticketCategoriesService.deleteTicketCategory(req.params.id, actorId);
    return res.json(success('Ticket category deleted', data));
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
