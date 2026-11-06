
const express = require('express');
const cors = require('cors');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Health check API
app.get('/api/health', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'CampusFlow API is running!',
    timestamp: new Date().toISOString(),
  });
});

// Routes
const authRoutes = require('./routes/authRoutes');
const subjectRoutes = require('./routes/subjectRoutes');

app.use('/api/auth', authRoutes);
app.use('/api/subjects', subjectRoutes);

module.exports = app;

