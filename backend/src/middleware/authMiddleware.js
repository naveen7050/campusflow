const jwt = require('jsonwebtoken');
const config = require('../config/env');
const UserModel = require('../models/userModel');

async function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({
      success: false,
      message: 'Access token missing. Please log in.',
    });
  }

  try {
    const decoded = jwt.verify(token, config.jwt.secret);
    const user = await UserModel.findById(decoded.id);

    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Invalid token. User not found.',
      });
    }

    req.user = user;
    next();
  } catch (error) {
    return res.status(403).json({
      success: false,
      message: 'Token is invalid or expired.',
      error: error.message,
    });
  }
}

module.exports = {
  authenticateToken,
};
