const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const ticketBalanceController = require('./ticket-balance.controller');

const router = express.Router();

router.get('/history', authMiddleware, ticketBalanceController.history);
router.get('/project/:projectId', authMiddleware, ticketBalanceController.listByProject);
router.get('/summary/:projectId', authMiddleware, ticketBalanceController.summaryByProject);
router.post('/', authMiddleware, ticketBalanceController.createTransaction);

module.exports = router;
