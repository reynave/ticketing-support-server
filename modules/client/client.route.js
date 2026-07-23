const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const clientController = require('./client.controller');

const router = express.Router();

router.get('/', authMiddleware, clientController.list);
router.get('/:id', authMiddleware, clientController.detail);
router.get('/:id/users', authMiddleware, clientController.listUsers);
router.get('/:id/project/:projectId', authMiddleware, clientController.listUsersByProject);


router.post('/', authMiddleware, clientController.create);
router.post('/:id/users', authMiddleware, clientController.createUser);
router.put('/:id', authMiddleware, clientController.update);
router.delete('/:id', authMiddleware, clientController.remove);

router.get('/:id/projects', authMiddleware, clientController.listProjects);
router.post('/:id/removeProject', authMiddleware, clientController.removeProject);
module.exports = router;
