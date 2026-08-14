const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const adminReportController = require('./admin-report.controller');

const router = express.Router();

router.get('/task', authMiddleware, adminReportController.taskReport);
router.get('/task/detail', authMiddleware, adminReportController.ticketDetail);
router.get('/case', authMiddleware, adminReportController.caseReport);
router.get('/case/detail', authMiddleware, adminReportController.ticketDetail);

module.exports = router;
