const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const ratingController = require('./rating.controller');

const router = express.Router();

router.get('/master', authMiddleware, ratingController.listMaster);
router.get('/master/:id', authMiddleware, ratingController.detailMaster);
router.post('/master', authMiddleware, ratingController.createMaster);
router.put('/master/:id', authMiddleware, ratingController.updateMaster);
router.delete('/master/:id', authMiddleware, ratingController.removeMaster);
router.get('/', authMiddleware, ratingController.list);

module.exports = router;