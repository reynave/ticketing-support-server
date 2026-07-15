const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const ratingController = require('./rating.controller');

const router = express.Router();

router.get('/', authMiddleware, ratingController.list);

module.exports = router;