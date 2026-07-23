const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const userController = require('./user.controller');

const router = express.Router();

router.get('/', authMiddleware, userController.list);
router.get('/:id', authMiddleware, userController.detail);
router.post('/', authMiddleware, userController.create); 

router.put('/:id', authMiddleware, userController.update);

router.delete('/:id', authMiddleware, userController.remove);

module.exports = router;
