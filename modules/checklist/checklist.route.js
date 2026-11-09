const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const checklistController = require('./checklist.controller');

const router = express.Router();

router.get('/:ticketId', authMiddleware, checklistController.list);
router.post('/', authMiddleware, checklistController.create);
router.put('/reorder', authMiddleware, checklistController.reorder);
router.put('/:id', authMiddleware, checklistController.update);
router.delete('/:id', authMiddleware, checklistController.remove);

module.exports = router;