const NoteModel = require('../models/noteModel');

async function createNote(req, res) {
  try {
    const { subjectId, title, content, tags, isShared } = req.body;

    if (!title || title.trim() === '') {
      return res.status(400).json({
        success: false,
        message: 'Note title is required.',
      });
    }

    const note = await NoteModel.create({
      userId: req.user.id,
      subjectId: subjectId || null,
      title: title.trim(),
      content: content || '',
      tags: Array.isArray(tags) ? tags : [],
      isShared: Boolean(isShared),
    });

    return res.status(201).json({
      success: true,
      message: 'Note created successfully.',
      data: { note },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to create note.',
      error: error.message,
    });
  }
}

async function getNotes(req, res) {
  try {
    const { subjectId, filter } = req.query;
    const notes = await NoteModel.findAll({
      userId: req.user.id,
      subjectId: subjectId || null,
      filter: filter || 'all',
    });

    return res.status(200).json({
      success: true,
      message: 'Notes retrieved successfully.',
      data: { notes },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve notes.',
      error: error.message,
    });
  }
}

async function getNoteById(req, res) {
  try {
    const { id } = req.params;
    const note = await NoteModel.findById(id, req.user.id);

    if (!note) {
      return res.status(404).json({
        success: false,
        message: 'Note not found.',
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Note retrieved successfully.',
      data: { note },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve note.',
      error: error.message,
    });
  }
}

async function updateNote(req, res) {
  try {
    const { id } = req.params;
    const { subjectId, title, content, tags, isShared } = req.body;

    const existing = await NoteModel.findById(id, req.user.id);
    if (!existing) {
      return res.status(404).json({
        success: false,
        message: 'Note not found.',
      });
    }

    const updated = await NoteModel.update(id, req.user.id, {
      subjectId: subjectId !== undefined ? subjectId : undefined,
      title: title !== undefined ? title.trim() : undefined,
      content: content !== undefined ? content : undefined,
      tags: Array.isArray(tags) ? tags : undefined,
      isShared: isShared !== undefined ? Boolean(isShared) : undefined,
    });

    return res.status(200).json({
      success: true,
      message: 'Note updated successfully.',
      data: { note: updated },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to update note.',
      error: error.message,
    });
  }
}

async function deleteNote(req, res) {
  try {
    const { id } = req.params;
    const existing = await NoteModel.findById(id, req.user.id);

    if (!existing) {
      return res.status(404).json({
        success: false,
        message: 'Note not found.',
      });
    }

    await NoteModel.delete(id, req.user.id);

    return res.status(200).json({
      success: true,
      message: 'Note deleted successfully.',
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to delete note.',
      error: error.message,
    });
  }
}

module.exports = {
  createNote,
  getNotes,
  getNoteById,
  updateNote,
  deleteNote,
};

