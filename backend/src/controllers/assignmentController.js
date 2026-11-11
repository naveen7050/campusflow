const AssignmentModel = require('../models/assignmentModel');

async function createAssignment(req, res) {
  try {
    const { subjectId, title, description, dueDate, isSubmitted } = req.body;

    if (!title || title.trim() === '') {
      return res.status(400).json({
        success: false,
        message: 'Assignment title is required.',
      });
    }

    const assignment = await AssignmentModel.create({
      userId: req.user.id,
      subjectId: subjectId || null,
      title: title.trim(),
      description: description || '',
      dueDate: dueDate || null,
      isSubmitted: Boolean(isSubmitted),
    });

    return res.status(201).json({
      success: true,
      message: 'Assignment created successfully.',
      data: { assignment },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to create assignment.',
      error: error.message,
    });
  }
}

async function getAssignments(req, res) {
  try {
    const { subjectId, filter } = req.query;
    const assignments = await AssignmentModel.findAll({
      userId: req.user.id,
      subjectId: subjectId || null,
      filter: filter || 'all',
    });

    return res.status(200).json({
      success: true,
      message: 'Assignments retrieved successfully.',
      data: { assignments },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve assignments.',
      error: error.message,
    });
  }
}

async function getAssignmentById(req, res) {
  try {
    const { id } = req.params;
    const assignment = await AssignmentModel.findById(id, req.user.id);

    if (!assignment) {
      return res.status(404).json({
        success: false,
        message: 'Assignment not found.',
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Assignment retrieved successfully.',
      data: { assignment },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve assignment.',
      error: error.message,
    });
  }
}

async function updateAssignment(req, res) {
  try {
    const { id } = req.params;
    const { subjectId, title, description, dueDate, isSubmitted } = req.body;

    const existing = await AssignmentModel.findById(id, req.user.id);
    if (!existing) {
      return res.status(404).json({
        success: false,
        message: 'Assignment not found.',
      });
    }

    const updated = await AssignmentModel.update(id, req.user.id, {
      subjectId: subjectId !== undefined ? subjectId : undefined,
      title: title !== undefined ? title.trim() : undefined,
      description: description !== undefined ? description : undefined,
      dueDate: dueDate !== undefined ? dueDate : undefined,
      isSubmitted: isSubmitted !== undefined ? isSubmitted : undefined,
    });

    return res.status(200).json({
      success: true,
      message: 'Assignment updated successfully.',
      data: { assignment: updated },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to update assignment.',
      error: error.message,
    });
  }
}

async function toggleAssignment(req, res) {
  try {
    const { id } = req.params;
    const updated = await AssignmentModel.toggleSubmission(id, req.user.id);

    if (!updated) {
      return res.status(404).json({
        success: false,
        message: 'Assignment not found.',
      });
    }

    return res.status(200).json({
      success: true,
      message: updated.is_submitted
          ? 'Assignment marked as submitted.'
          : 'Assignment marked as pending.',
      data: { assignment: updated },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to update assignment status.',
      error: error.message,
    });
  }
}

async function deleteAssignment(req, res) {
  try {
    const { id } = req.params;
    const deleted = await AssignmentModel.delete(id, req.user.id);

    if (!deleted) {
      return res.status(404).json({
        success: false,
        message: 'Assignment not found.',
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Assignment deleted successfully.',
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to delete assignment.',
      error: error.message,
    });
  }
}

module.exports = {
  createAssignment,
  getAssignments,
  getAssignmentById,
  updateAssignment,
  toggleAssignment,
  deleteAssignment,
};
