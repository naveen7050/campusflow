const QuestionModel = require('../models/questionModel');

async function createQuestion(req, res) {
  try {
    const { subjectId, question, answer, imageUrl, isStarred, isShared } = req.body;

    if (!question || question.trim() === '') {
      return res.status(400).json({
        success: false,
        message: 'Question text is required.',
      });
    }

    const item = await QuestionModel.create({
      userId: req.user.id,
      subjectId: subjectId || null,
      question: question.trim(),
      answer: answer || '',
      imageUrl: imageUrl || null,
      isStarred: Boolean(isStarred),
      isShared: Boolean(isShared),
    });

    return res.status(201).json({
      success: true,
      message: 'Question created successfully.',
      data: { question: item },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to create question.',
      error: error.message,
    });
  }
}

async function getQuestions(req, res) {
  try {
    const { subjectId, filter } = req.query;
    const questions = await QuestionModel.findAll({
      userId: req.user.id,
      subjectId: subjectId || null,
      filter: filter || 'all',
    });

    return res.status(200).json({
      success: true,
      message: 'Questions retrieved successfully.',
      data: { questions },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve questions.',
      error: error.message,
    });
  }
}

async function getQuestionById(req, res) {
  try {
    const { id } = req.params;
    const question = await QuestionModel.findById(id, req.user.id);

    if (!question) {
      return res.status(404).json({
        success: false,
        message: 'Question not found.',
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Question retrieved successfully.',
      data: { question },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve question.',
      error: error.message,
    });
  }
}

async function updateQuestion(req, res) {
  try {
    const { id } = req.params;
    const { subjectId, question, answer, imageUrl, isStarred, isShared } = req.body;

    const existing = await QuestionModel.findById(id, req.user.id);
    if (!existing) {
      return res.status(404).json({
        success: false,
        message: 'Question not found.',
      });
    }

    const updated = await QuestionModel.update(id, req.user.id, {
      subjectId: subjectId !== undefined ? subjectId : undefined,
      question: question !== undefined ? question.trim() : undefined,
      answer: answer !== undefined ? answer : undefined,
      imageUrl: imageUrl !== undefined ? imageUrl : undefined,
      isStarred: isStarred !== undefined ? isStarred : undefined,
      isShared: isShared !== undefined ? isShared : undefined,
    });

    return res.status(200).json({
      success: true,
      message: 'Question updated successfully.',
      data: { question: updated },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to update question.',
      error: error.message,
    });
  }
}

async function toggleStar(req, res) {
  try {
    const { id } = req.params;
    const updated = await QuestionModel.toggleStar(id, req.user.id);

    if (!updated) {
      return res.status(404).json({
        success: false,
        message: 'Question not found.',
      });
    }

    return res.status(200).json({
      success: true,
      message: updated.is_starred ? 'Question starred.' : 'Question unstarred.',
      data: { question: updated },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to update question star status.',
      error: error.message,
    });
  }
}

async function deleteQuestion(req, res) {
  try {
    const { id } = req.params;
    const deleted = await QuestionModel.delete(id, req.user.id);

    if (!deleted) {
      return res.status(404).json({
        success: false,
        message: 'Question not found.',
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Question deleted successfully.',
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to delete question.',
      error: error.message,
    });
  }
}

module.exports = {
  createQuestion,
  getQuestions,
  getQuestionById,
  updateQuestion,
  toggleStar,
  deleteQuestion,
};

