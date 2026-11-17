const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const projectController = require('./project.controller');

const router = express.Router();

router.get('/', authMiddleware, projectController.list);
router.get('/detail/:id', authMiddleware, projectController.detail);
router.get('/:id', authMiddleware, projectController.detail);

module.exports = router;