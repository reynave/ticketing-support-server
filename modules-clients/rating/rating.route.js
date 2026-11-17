const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const ratingController = require('./rating.controller');

const router = express.Router();

router.get('/master', authMiddleware, ratingController.listMaster);
router.post('/rate', authMiddleware, ratingController.createRate);

module.exports = router;