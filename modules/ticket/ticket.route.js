const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const ticketController = require('./ticket.controller');

const router = express.Router();

router.get('/', authMiddleware, ticketController.list);
router.get('/:id', authMiddleware, ticketController.detail);
router.get('/:id/logs', authMiddleware, ticketController.detailLogs);

router.post('/', authMiddleware, ticketController.create);

router.put('/:id', authMiddleware, ticketController.update);
router.put('/:id/submitRate', authMiddleware, ticketController.submitRate);

router.delete('/:id', authMiddleware, ticketController.remove);

router.post('/log/:id', authMiddleware, ticketController.createLog);
module.exports = router;
