const db = require('../config/database');

const MaterialModel = {
  async create({ userId, subjectId, title, fileUrl, fileType = 'PDF', fileSize = '1.2 MB', isShared = false }) {
    const query = `
      INSERT INTO materials (user_id, subject_id, title, file_url, file_type, file_size, is_shared)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING id, user_id, subject_id, title, file_url, file_type, file_size, is_shared, created_at, updated_at;
    `;
    const values = [userId, subjectId || null, title, fileUrl || null, fileType, fileSize, isShared];
    const result = await db.query(query, values);
    return result.rows[0];
  },

  async findAll({ userId, subjectId, filter }) {
    let query = `
      SELECT m.id, m.user_id, m.subject_id, m.title, m.file_url, m.file_type, m.file_size, m.is_shared,
             m.created_at, m.updated_at, s.name as subject_name, s.code as subject_code, s.color as subject_color
      FROM materials m
      LEFT JOIN subjects s ON m.subject_id = s.id
    `;
    const conditions = [];
    const values = [];

    if (filter === 'shared') {
      conditions.push(`m.is_shared = true`);
    } else if (filter === 'my') {
      values.push(userId);
      conditions.push(`m.user_id = $${values.length}`);
    } else {
      values.push(userId);
      conditions.push(`(m.user_id = $${values.length} OR m.is_shared = true)`);
    }

    if (subjectId) {
      values.push(subjectId);
      conditions.push(`m.subject_id = $${values.length}`);
    }

    if (conditions.length > 0) {
      query += ` WHERE ${conditions.join(' AND ')}`;
    }

    query += ` ORDER BY m.updated_at DESC;`;

    const result = await db.query(query, values);
    return result.rows;
  },

  async findById(id, userId) {
    const query = `
      SELECT m.id, m.user_id, m.subject_id, m.title, m.file_url, m.file_type, m.file_size, m.is_shared,
             m.created_at, m.updated_at, s.name as subject_name, s.code as subject_code, s.color as subject_color
      FROM materials m
      LEFT JOIN subjects s ON m.subject_id = s.id
      WHERE m.id = $1 AND (m.user_id = $2 OR m.is_shared = true);
    `;
    const result = await db.query(query, [id, userId]);
    return result.rows[0] || null;
  },

  async update(id, userId, { subjectId, title, fileUrl, fileType, fileSize, isShared }) {
    const query = `
      UPDATE materials
      SET
        subject_id = COALESCE($3, subject_id),
        title = COALESCE($4, title),
        file_url = COALESCE($5, file_url),
        file_type = COALESCE($6, file_type),
        file_size = COALESCE($7, file_size),
        is_shared = COALESCE($8, is_shared),
        updated_at = CURRENT_TIMESTAMP
      WHERE id = $1 AND user_id = $2
      RETURNING id, user_id, subject_id, title, file_url, file_type, file_size, is_shared, created_at, updated_at;
    `;
    const values = [id, userId, subjectId, title, fileUrl, fileType, fileSize, isShared];
    const result = await db.query(query, values);
    return result.rows[0] || null;
  },

  async delete(id, userId) {
    const query = `
      DELETE FROM materials
      WHERE id = $1 AND user_id = $2
      RETURNING id;
    `;
    const result = await db.query(query, [id, userId]);
    return result.rows[0] || null;
  },
};

module.exports = MaterialModel;

