const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const projectMasterController = require('./project-master.controller');

const router = express.Router();

router.get('/', authMiddleware, projectMasterController.list);
router.get('/:id', authMiddleware, projectMasterController.detail);
router.post('/', authMiddleware, projectMasterController.create);
router.put('/:id', authMiddleware, projectMasterController.update);
router.delete('/:id', authMiddleware, projectMasterController.remove);

module.exports = router;
