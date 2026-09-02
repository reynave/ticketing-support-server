const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const changeRequestController = require('./change-request.controller');

const router = express.Router();

router.get('/', authMiddleware, changeRequestController.list); 

router.get('/:id', authMiddleware, changeRequestController.detail);
router.get('/:id/logs', authMiddleware, changeRequestController.detailLogs);
router.get('/:id/tasks', authMiddleware, changeRequestController.listTasks);

router.post('/', authMiddleware, changeRequestController.create);
router.post('/:id/tasks', authMiddleware, changeRequestController.createTask);

router.put('/:id', authMiddleware, changeRequestController.update);
router.put('/:id/submitRate', authMiddleware, changeRequestController.submitRate);
router.put('/:id/status', authMiddleware, changeRequestController.updateStatusByClient);

router.delete('/:id', authMiddleware, changeRequestController.remove);

router.post('/log/:id', authMiddleware, changeRequestController.createLog);
module.exports = router;
