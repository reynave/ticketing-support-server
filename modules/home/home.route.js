const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const homeController = require('./home.controller');

const router = express.Router();

router.get('/', authMiddleware, homeController.dashboard);
router.get('/users', authMiddleware, homeController.projectUsers);
router.put('/sorting', authMiddleware, homeController.reorder);

module.exports = router;
