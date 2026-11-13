
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
const noteRoutes = require('./routes/noteRoutes');
const materialRoutes = require('./routes/materialRoutes');
const assignmentRoutes = require('./routes/assignmentRoutes');
const questionRoutes = require('./routes/questionRoutes');

app.use('/api/auth', authRoutes);
app.use('/api/subjects', subjectRoutes);
app.use('/api/notes', noteRoutes);
app.use('/api/materials', materialRoutes);
app.use('/api/assignments', assignmentRoutes);
app.use('/api/questions', questionRoutes);

module.exports = app;

