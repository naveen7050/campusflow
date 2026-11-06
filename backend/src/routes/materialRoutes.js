const express = require('express');
const { authenticateToken } = require('../middleware/authMiddleware');
const {
  createMaterial,
  getMaterials,
  getMaterialById,
  updateMaterial,
  deleteMaterial,
} = require('../controllers/materialController');

const router = express.Router();

router.use(authenticateToken);

router.post('/', createMaterial);
router.get('/', getMaterials);
router.get('/:id', getMaterialById);
router.put('/:id', updateMaterial);
router.delete('/:id', deleteMaterial);

module.exports = router;
