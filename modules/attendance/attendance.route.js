const express = require('express');
const authMiddleware = require('../../middlewares/auth');
const attendanceController = require('./attendance.controller');

const router = express.Router();

router.get('/', authMiddleware, attendanceController.list);
router.get('/summary', authMiddleware, attendanceController.summary);
router.get('/dashboard', authMiddleware, attendanceController.dashboard);
router.get('/status', authMiddleware, attendanceController.status);
router.get('/my', authMiddleware, attendanceController.myHistory);
router.post('/check-in', authMiddleware, attendanceController.checkIn);
router.put('/check-out', authMiddleware, attendanceController.checkOut);

module.exports = router;