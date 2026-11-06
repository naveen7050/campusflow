const MaterialModel = require('../models/materialModel');

async function createMaterial(req, res) {
  try {
    const { subjectId, title, fileUrl, fileType, fileSize, isShared } = req.body;

    if (!title || title.trim() === '') {
      return res.status(400).json({
        success: false,
        message: 'Material title is required.',
      });
    }

    const material = await MaterialModel.create({
      userId: req.user.id,
      subjectId: subjectId || null,
      title: title.trim(),
      fileUrl: fileUrl || null,
      fileType: fileType || 'PDF',
      fileSize: fileSize || '1.2 MB',
      isShared: Boolean(isShared),
    });

    return res.status(201).json({
      success: true,
      message: 'Study material created successfully.',
      data: { material },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to create study material.',
      error: error.message,
    });
  }
}

async function getMaterials(req, res) {
  try {
    const { subjectId, filter } = req.query;
    const materials = await MaterialModel.findAll({
      userId: req.user.id,
      subjectId: subjectId || null,
      filter: filter || 'all',
    });

    return res.status(200).json({
      success: true,
      message: 'Materials retrieved successfully.',
      data: { materials },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve materials.',
      error: error.message,
    });
  }
}

async function getMaterialById(req, res) {
  try {
    const { id } = req.params;
    const material = await MaterialModel.findById(id, req.user.id);

    if (!material) {
      return res.status(404).json({
        success: false,
        message: 'Study material not found.',
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Study material retrieved successfully.',
      data: { material },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve study material.',
      error: error.message,
    });
  }
}

async function updateMaterial(req, res) {
  try {
    const { id } = req.params;
    const { subjectId, title, fileUrl, fileType, fileSize, isShared } = req.body;

    const existing = await MaterialModel.findById(id, req.user.id);
    if (!existing) {
      return res.status(404).json({
        success: false,
        message: 'Study material not found.',
      });
    }

    const updated = await MaterialModel.update(id, req.user.id, {
      subjectId: subjectId !== undefined ? subjectId : undefined,
      title: title !== undefined ? title.trim() : undefined,
      fileUrl: fileUrl !== undefined ? fileUrl : undefined,
      fileType: fileType !== undefined ? fileType : undefined,
      fileSize: fileSize !== undefined ? fileSize : undefined,
      isShared: isShared !== undefined ? Boolean(isShared) : undefined,
    });

    return res.status(200).json({
      success: true,
      message: 'Study material updated successfully.',
      data: { material: updated },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to update study material.',
      error: error.message,
    });
  }
}

async function deleteMaterial(req, res) {
  try {
    const { id } = req.params;
    const existing = await MaterialModel.findById(id, req.user.id);

    if (!existing) {
      return res.status(404).json({
        success: false,
        message: 'Study material not found.',
      });
    }

    await MaterialModel.delete(id, req.user.id);

    return res.status(200).json({
      success: true,
      message: 'Study material deleted successfully.',
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Failed to delete study material.',
      error: error.message,
    });
  }
}

module.exports = {
  createMaterial,
  getMaterials,
  getMaterialById,
  updateMaterial,
  deleteMaterial,
};
