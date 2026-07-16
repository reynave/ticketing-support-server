const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const userLoginHistoryController = require('./user-login-history.controller');

const router = express.Router();

router.get('/', authMiddleware, userLoginHistoryController.list);

module.exports = router;
