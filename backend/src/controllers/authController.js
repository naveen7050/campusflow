const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const config = require('../config/env');
const UserModel = require('../models/userModel');

function generateToken(user) {
  return jwt.sign(
    {
      id: user.id,
      email: user.email,
      role: user.role,
    },
    config.jwt.secret,
    { expiresIn: config.jwt.expiresIn }
  );
}

const AuthController = {
  async register(req, res) {
    try {
      const { fullName, email, password, studentId, department, semester, role } = req.body;

      if (!fullName || !email || !password) {
        return res.status(400).json({
          success: false,
          message: 'Full name, email, and password are required fields.',
        });
      }

      if (password.length < 6) {
        return res.status(400).json({
          success: false,
          message: 'Password must contain at least 6 characters.',
        });
      }

      const existingUser = await UserModel.findByEmail(email);
      if (existingUser) {
        return res.status(409).json({
          success: false,
          message: 'Email is already registered.',
        });
      }

      const salt = await bcrypt.genSalt(10);
      const passwordHash = await bcrypt.hash(password, salt);

      const user = await UserModel.createUser({
        fullName,
        email,
        passwordHash,
        studentId,
        department,
        semester,
        role,
      });

      const token = generateToken(user);

      // Seed starter subjects, notes, and questions for rich initial experience
      try {
        const { seedUserData } = require('../scripts/seed');
        await seedUserData(user.id, user.department, user.semester);
      } catch (seedErr) {
        console.warn('Starter data seeding skipped:', seedErr.message);
      }

      return res.status(201).json({
        success: true,
        message: 'User registered successfully.',
        data: {
          user,
          token,
        },
      });
    } catch (error) {
      console.error('Register error:', error);
      return res.status(500).json({
        success: false,
        message: 'Internal server error while registering user.',
        error: error.message,
      });
    }
  },

  async login(req, res) {
    try {
      const { email, password } = req.body;

      if (!email || !password) {
        return res.status(400).json({
          success: false,
          message: 'Email and password are required fields.',
        });
      }

      const user = await UserModel.findByEmail(email);
      if (!user) {
        return res.status(401).json({
          success: false,
          message: 'Invalid email or password.',
        });
      }

      const isMatch = await bcrypt.compare(password, user.password_hash);
      if (!isMatch) {
        return res.status(401).json({
          success: false,
          message: 'Invalid email or password.',
        });
      }

      const token = generateToken(user);

      const safeUser = {
        id: user.id,
        full_name: user.full_name,
        email: user.email,
        student_id: user.student_id,
        department: user.department,
        semester: user.semester,
        role: user.role,
        avatar_url: user.avatar_url,
        created_at: user.created_at,
      };

      return res.status(200).json({
        success: true,
        message: 'Login successful.',
        data: {
          user: safeUser,
          token,
        },
      });
    } catch (error) {
      console.error('Login error:', error);
      return res.status(500).json({
        success: false,
        message: 'Internal server error while logging in.',
        error: error.message,
      });
    }
  },

  async getMe(req, res) {
    try {
      return res.status(200).json({
        success: true,
        data: {
          user: req.user,
        },
      });
    } catch (error) {
      console.error('Get profile error:', error);
      return res.status(500).json({
        success: false,
        message: 'Internal server error while fetching profile.',
        error: error.message,
      });
    }
  },

  async updateProfile(req, res) {
    try {
      const { fullName, department, semester } = req.body;
      const updatedUser = await UserModel.updateProfile(req.user.id, {
        fullName: fullName ? fullName.trim() : null,
        department: department ? department.trim() : null,
        semester: semester ? parseInt(semester, 10) : null,
      });

      return res.status(200).json({
        success: true,
        message: 'Profile updated successfully.',
        data: { user: updatedUser },
      });
    } catch (error) {
      console.error('Update profile error:', error);
      return res.status(500).json({
        success: false,
        message: 'Failed to update profile.',
        error: error.message,
      });
    }
  },

  async changePassword(req, res) {
    try {
      const { currentPassword, newPassword } = req.body;
      if (!currentPassword || !newPassword) {
        return res.status(400).json({
          success: false,
          message: 'Both current password and new password are required.',
        });
      }

      const user = await UserModel.findByEmail(req.user.email);
      if (!user) {
        return res.status(404).json({
          success: false,
          message: 'User not found.',
        });
      }

      const isMatch = await bcrypt.compare(currentPassword, user.password_hash);
      if (!isMatch) {
        return res.status(401).json({
          success: false,
          message: 'Current password is incorrect.',
        });
      }

      if (newPassword.length < 6) {
        return res.status(400).json({
          success: false,
          message: 'New password must be at least 6 characters.',
        });
      }

      const salt = await bcrypt.genSalt(10);
      const newHash = await bcrypt.hash(newPassword, salt);
      await UserModel.updatePassword(req.user.id, newHash);

      return res.status(200).json({
        success: true,
        message: 'Password updated successfully.',
      });
    } catch (error) {
      console.error('Change password error:', error);
      return res.status(500).json({
        success: false,
        message: 'Failed to update password.',
        error: error.message,
      });
    }
  },
};

module.exports = AuthController;
