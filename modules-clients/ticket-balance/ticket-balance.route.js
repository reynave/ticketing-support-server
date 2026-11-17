const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const ticketBalanceController = require('./ticket-balance.controller');

const router = express.Router();

router.get('/project/:projectId', authMiddleware, ticketBalanceController.listByProject);

module.exports = router;