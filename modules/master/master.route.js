const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const masterController = require('./master.controller');

const router = express.Router();

router.get('/loadbBadge', authMiddleware, masterController.loadbBadge);
router.get('/:masterKey', authMiddleware, masterController.list);
router.get('/:masterKey/:id', authMiddleware, masterController.detail);
router.post('/:masterKey', authMiddleware, masterController.create);
router.put('/:masterKey/:id', authMiddleware, masterController.update);
router.delete('/:masterKey/:id', authMiddleware, masterController.remove);

module.exports = router;
