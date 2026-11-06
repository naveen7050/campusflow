const express = require('express');
const { authenticateToken } = require('../middleware/authMiddleware');
const {
  createSubject,
  getSubjects,
  getSubjectById,
  updateSubject,
  deleteSubject,
} = require('../controllers/subjectController');

const router = express.Router();

router.use(authenticateToken);

router.post('/', createSubject);
router.get('/', getSubjects);
router.get('/:id', getSubjectById);
router.put('/:id', updateSubject);
router.delete('/:id', deleteSubject);

module.exports = router;

