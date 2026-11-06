const SubjectModel = require('../models/subjectModel');

async function createSubject(req, res) {
  try {
    const { name, code, description, semester, department, color, icon } = req.body;

    if (!name || name.trim() === '') {
      return res.status(400).json({
        success: false,
        message: 'Subject name is required.',
      });
    }

    const subject = await SubjectModel.create({
      userId: req.user.id,
      name: name.trim(),
      code: code ? code.trim() : null,
      description: description ? description.trim() : null,
      semester: semester ? parseInt(semester, 10) : null,
      department: department ? department.trim() : null,
      color,
      icon,
    });

    return res.status(201).json({
      success: true,
      message: 'Subject created successfully.',
      data: { subject },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to create subject.',
      error: error.message,
    });
  }
}

async function getSubjects(req, res) {
  try {
    const subjects = await SubjectModel.findByUserId(req.user.id);

    return res.status(200).json({
      success: true,
      message: 'Subjects retrieved successfully.',
      data: { subjects },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve subjects.',
      error: error.message,
    });
  }
}

async function getSubjectById(req, res) {
  try {
    const { id } = req.params;
    const subject = await SubjectModel.findById(id, req.user.id);

    if (!subject) {
      return res.status(404).json({
        success: false,
        message: 'Subject not found.',
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Subject retrieved successfully.',
      data: { subject },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve subject.',
      error: error.message,
    });
  }
}

async function updateSubject(req, res) {
  try {
    const { id } = req.params;
    const { name, code, description, semester, department, color, icon } = req.body;

    const existing = await SubjectModel.findById(id, req.user.id);
    if (!existing) {
      return res.status(404).json({
        success: false,
        message: 'Subject not found.',
      });
    }

    const updated = await SubjectModel.update(id, req.user.id, {
      name: name !== undefined ? name.trim() : undefined,
      code: code !== undefined ? code.trim() : undefined,
      description: description !== undefined ? description.trim() : undefined,
      semester: semester !== undefined ? parseInt(semester, 10) : undefined,
      department: department !== undefined ? department.trim() : undefined,
      color,
      icon,
    });

    return res.status(200).json({
      success: true,
      message: 'Subject updated successfully.',
      data: { subject: updated },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to update subject.',
      error: error.message,
    });
  }
}

async function deleteSubject(req, res) {
  try {
    const { id } = req.params;

    const existing = await SubjectModel.findById(id, req.user.id);
    if (!existing) {
      return res.status(404).json({
        success: false,
        message: 'Subject not found.',
      });
    }

    await SubjectModel.delete(id, req.user.id);

    return res.status(200).json({
      success: true,
      message: 'Subject deleted successfully.',
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to delete subject.',
      error: error.message,
    });
  }
}

module.exports = {
  createSubject,
  getSubjects,
  getSubjectById,
  updateSubject,
  deleteSubject,
};

