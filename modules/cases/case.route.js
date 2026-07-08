const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const caseController = require('./case.controller');

const router = express.Router();

router.get('/', authMiddleware, caseController.list);
router.get('/:id', authMiddleware, caseController.detail);
router.get('/:id/logs', authMiddleware, caseController.detailLogs);
router.get('/:id/tasks', authMiddleware, caseController.listTasks);

router.post('/', authMiddleware, caseController.create);
router.post('/:id/tasks', authMiddleware, caseController.createTask);

router.put('/:id', authMiddleware, caseController.update);
router.put('/:id/submitRate', authMiddleware, caseController.submitRate);

router.delete('/:id', authMiddleware, caseController.remove);

router.post('/log/:id', authMiddleware, caseController.createLog);
module.exports = router;
