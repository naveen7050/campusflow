const express = require('express');
const { authenticateToken } = require('../middleware/authMiddleware');
const {
  createAssignment,
  getAssignments,
  getAssignmentById,
  updateAssignment,
  toggleAssignment,
  deleteAssignment,
} = require('../controllers/assignmentController');

const router = express.Router();

router.use(authenticateToken);

router.post('/', createAssignment);
router.get('/', getAssignments);
router.get('/:id', getAssignmentById);
router.put('/:id', updateAssignment);
router.patch('/:id/toggle', toggleAssignment);
router.delete('/:id', deleteAssignment);

module.exports = router;
