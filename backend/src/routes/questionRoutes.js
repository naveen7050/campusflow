const express = require('express');
const { authenticateToken } = require('../middleware/authMiddleware');
const {
  createQuestion,
  getQuestions,
  getQuestionById,
  updateQuestion,
  toggleStar,
  deleteQuestion,
} = require('../controllers/questionController');

const router = express.Router();

router.use(authenticateToken);

router.post('/', createQuestion);
router.get('/', getQuestions);
router.get('/:id', getQuestionById);
router.put('/:id', updateQuestion);
router.patch('/:id/star', toggleStar);
router.delete('/:id', deleteQuestion);

module.exports = router;

