const express = require('express');
const templateController = require('./template.controller');
const authMiddleware = require('../../middlewares/auth');

const router = express.Router();

router.get('/', authMiddleware, templateController.list);
router.get('/:id', authMiddleware, templateController.detail);
router.post('/', authMiddleware, templateController.create);
router.put('/:id', authMiddleware, templateController.update);
router.delete('/:id', authMiddleware, templateController.remove);

module.exports = router;
