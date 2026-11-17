const express = require('express');
const AuthController = require('../controllers/authController');
const { authenticateToken } = require('../middleware/authMiddleware');

const router = express.Router();

// Public routes
router.post('/register', AuthController.register);
router.post('/login', AuthController.login);

// Protected routes
router.get('/me', authenticateToken, AuthController.getMe);
router.put('/profile', authenticateToken, AuthController.updateProfile);
router.put('/change-password', authenticateToken, AuthController.changePassword);

module.exports = router;
