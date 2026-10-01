const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const verificationController = require('./verification.controller');

const router = express.Router();

router.put('/bulk-status', authMiddleware, verificationController.bulkUpdateStatus);
router.get('/', authMiddleware, verificationController.list);
router.get('/:id', authMiddleware, verificationController.detail);
router.put('/:id/status', authMiddleware, verificationController.updateStatus);

module.exports = router;