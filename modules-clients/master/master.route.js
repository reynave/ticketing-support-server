const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const masterController = require('./master.controller');

const router = express.Router();

router.get('/status/cases', authMiddleware, masterController.statusCases);
router.get('/ticket-severities', authMiddleware, masterController.ticketSeverities);

module.exports = router;