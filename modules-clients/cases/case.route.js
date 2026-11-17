const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const caseController = require('./case.controller');

const router = express.Router();

router.get('/', authMiddleware, caseController.list);
router.get('/closed', authMiddleware, caseController.listClosed);

router.get('/:id', authMiddleware, caseController.detail);
router.get('/:id/logs', authMiddleware, caseController.detailLogs);

router.post('/', authMiddleware, caseController.create);
router.put('/:id/status', authMiddleware, caseController.updateStatusByClient);

module.exports = router;