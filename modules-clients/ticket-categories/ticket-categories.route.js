const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const ticketCategoriesController = require('./ticket-categories.controller');

const router = express.Router();

router.get('/', authMiddleware, ticketCategoriesController.list);

module.exports = router;