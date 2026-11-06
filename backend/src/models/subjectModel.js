const db = require('../config/database');

const SubjectModel = {
  async create({ userId, name, code, description, semester, department, color = '#0F5132', icon = 'menu_book' }) {
    const query = `
      INSERT INTO subjects (user_id, name, code, description, semester, department, color, icon)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
      RETURNING id, user_id, name, code, description, semester, department, color, icon, created_at, updated_at;
    `;
    const values = [userId, name, code || null, description || null, semester || null, department || null, color, icon];
    const result = await db.query(query, values);
    return result.rows[0];
  },

  async findByUserId(userId) {
    const query = `
      SELECT id, user_id, name, code, description, semester, department, color, icon, created_at, updated_at
      FROM subjects
      WHERE user_id = $1
      ORDER BY created_at DESC;
    `;
    const result = await db.query(query, [userId]);
    return result.rows;
  },

  async findById(id, userId) {
    const query = `
      SELECT id, user_id, name, code, description, semester, department, color, icon, created_at, updated_at
      FROM subjects
      WHERE id = $1 AND user_id = $2;
    `;
    const result = await db.query(query, [id, userId]);
    return result.rows[0] || null;
  },

  async update(id, userId, { name, code, description, semester, department, color, icon }) {
    const query = `
      UPDATE subjects
      SET
        name = COALESCE($3, name),
        code = COALESCE($4, code),
        description = COALESCE($5, description),
        semester = COALESCE($6, semester),
        department = COALESCE($7, department),
        color = COALESCE($8, color),
        icon = COALESCE($9, icon),
        updated_at = CURRENT_TIMESTAMP
      WHERE id = $1 AND user_id = $2
      RETURNING id, user_id, name, code, description, semester, department, color, icon, created_at, updated_at;
    `;
    const values = [id, userId, name, code, description, semester, department, color, icon];
    const result = await db.query(query, values);
    return result.rows[0] || null;
  },

  async delete(id, userId) {
    const query = `
      DELETE FROM subjects
      WHERE id = $1 AND user_id = $2
      RETURNING id;
    `;
    const result = await db.query(query, [id, userId]);
    return result.rows[0] || null;
  },
};

module.exports = SubjectModel;

