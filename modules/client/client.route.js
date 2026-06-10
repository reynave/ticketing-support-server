const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const clientController = require('./client.controller');

const router = express.Router();

router.get('/', authMiddleware, clientController.list);
router.get('/:id', authMiddleware, clientController.detail);
router.post('/', authMiddleware, clientController.create);
router.put('/:id', authMiddleware, clientController.update);
router.delete('/:id', authMiddleware, clientController.remove);

module.exports = router;
