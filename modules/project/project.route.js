const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const projectController = require('./project.controller');

const router = express.Router();

router.get('/', authMiddleware, projectController.list);
router.get('/:id', authMiddleware, projectController.detail);
router.post('/', authMiddleware, projectController.create);
router.put('/:id', authMiddleware, projectController.update);
router.delete('/:id', authMiddleware, projectController.remove);

module.exports = router;
