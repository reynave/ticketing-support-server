const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const projectController = require('./project.controller');

const router = express.Router();

router.get('/', authMiddleware, projectController.list);


router.get('/ticketList', authMiddleware, projectController.ticketList);
router.get('/drafts', authMiddleware, projectController.listDrafts);
router.get('/draftTasks', authMiddleware, projectController.draftTaskList);
router.post('/draftTasks', authMiddleware, projectController.createProjectDraftTask);
router.put('/draftTasks/reorder', authMiddleware, projectController.reorderDraftTasks);
router.put('/draftTasks/:id', authMiddleware, projectController.updateProjectDraftTask);
router.delete('/draftTasks/:id', authMiddleware, projectController.deleteProjectDraftTask);

router.get('/detail/:id', authMiddleware, projectController.detail);

//router.get('/:id/cases', authMiddleware, projectController.detail);
//router.get('/:id/cr', authMiddleware, projectController.detail);



router.post('/', authMiddleware, projectController.create);
router.post('/draft', authMiddleware, projectController.createDraft);
router.post('/contact', authMiddleware, projectController.addContact);
router.post('/:id/task', authMiddleware, projectController.createProjectTask);

router.put('/contact', authMiddleware, projectController.removeContact);
router.put('/task/reorder', authMiddleware, projectController.reorderTasks);
router.put('/:id', authMiddleware, projectController.update);


router.delete('/:id', authMiddleware, projectController.remove);

module.exports = router;
