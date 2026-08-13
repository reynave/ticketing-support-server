const express = require('express');
const { body } = require('express-validator');
const authMiddleware = require('../../middlewares/auth');
const clientAuthController = require('./client-auth.controller');

const router = express.Router();

router.post(
  '/login',
  body('email').isEmail().withMessage('Email is required'),
  body('password').notEmpty().withMessage('Password is required'),
  clientAuthController.login
);

router.get('/me', authMiddleware, clientAuthController.me);
router.get('/profile', authMiddleware, clientAuthController.profile);
router.put(
  '/profile',
  authMiddleware,
  body('email').optional().isEmail().withMessage('Email must be valid'),
  clientAuthController.updateProfile
);

module.exports = router;
