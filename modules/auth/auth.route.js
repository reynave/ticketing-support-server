const express = require('express');
const { body } = require('express-validator');
const authMiddleware = require('../../middlewares/auth');
const authController = require('./auth.controller');

const router = express.Router();

router.post(
  '/login',
  body('email').isEmail().withMessage('Email is required'),
  body('password').notEmpty().withMessage('Password is required'),
  authController.login
);

router.get('/me', authMiddleware, authController.me);

module.exports = router;
