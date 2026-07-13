const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const ticketCategoriesController = require('./ticket-categories.controller');

const router = express.Router();

router.get('/', authMiddleware, ticketCategoriesController.list);
router.get('/:id', authMiddleware, ticketCategoriesController.detail);
router.post('/', authMiddleware, ticketCategoriesController.create);
router.put('/:id', authMiddleware, ticketCategoriesController.update);
router.delete('/:id', authMiddleware, ticketCategoriesController.remove);

module.exports = router;
