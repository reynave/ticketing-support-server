const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const clientTicketController = require('./client-ticket.controller');

const router = express.Router();

router.get('/cases', authMiddleware, clientTicketController.listCases);
router.get('/change-requests', authMiddleware, clientTicketController.listChangeRequests);
router.get('/balance/client/:projectId', authMiddleware, clientTicketController.getClientBalance);

module.exports = router;
