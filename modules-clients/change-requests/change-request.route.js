const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const changeRequestController = require('./change-request.controller');

const router = express.Router();

router.get('/', authMiddleware, changeRequestController.list);
router.get('/closed', authMiddleware, changeRequestController.listClosed);

router.get('/:id', authMiddleware, changeRequestController.detail);
router.get('/:id/logs', authMiddleware, changeRequestController.detailLogs);

router.post('/', authMiddleware, changeRequestController.create);
router.put('/:id/status', authMiddleware, changeRequestController.updateStatusByClient);

module.exports = router;