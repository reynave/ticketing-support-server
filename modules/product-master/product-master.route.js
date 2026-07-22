const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const productMasterController = require('./product-master.controller');

const router = express.Router();

router.get('/', authMiddleware, productMasterController.list);
router.get('/:id', authMiddleware, productMasterController.detail);
router.post('/', authMiddleware, productMasterController.create);
router.put('/:id', authMiddleware, productMasterController.update);
router.delete('/:id', authMiddleware, productMasterController.remove);

module.exports = router;
