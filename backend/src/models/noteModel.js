const db = require('../config/database');

const NoteModel = {
  async create({ userId, subjectId, title, content, tags = [], isShared = false }) {
    const query = `
      INSERT INTO notes (user_id, subject_id, title, content, tags, is_shared)
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING id, user_id, subject_id, title, content, tags, is_shared, created_at, updated_at;
    `;
    const values = [userId, subjectId || null, title, content || '', tags, isShared];
    const result = await db.query(query, values);
    return result.rows[0];
  },

  async findAll({ userId, subjectId, filter }) {
    let query = `
      SELECT n.id, n.user_id, n.subject_id, n.title, n.content, n.tags, n.is_shared,
             n.created_at, n.updated_at, s.name as subject_name, s.code as subject_code, s.color as subject_color
      FROM notes n
      LEFT JOIN subjects s ON n.subject_id = s.id
    `;
    const conditions = [];
    const values = [];

    if (filter === 'shared') {
      conditions.push(`n.is_shared = true`);
    } else if (filter === 'my') {
      values.push(userId);
      conditions.push(`n.user_id = $${values.length}`);
    } else {
      values.push(userId);
      conditions.push(`(n.user_id = $${values.length} OR n.is_shared = true)`);
    }

    if (subjectId) {
      values.push(subjectId);
      conditions.push(`n.subject_id = $${values.length}`);
    }

    if (conditions.length > 0) {
      query += ` WHERE ${conditions.join(' AND ')}`;
    }

    query += ` ORDER BY n.updated_at DESC;`;

    const result = await db.query(query, values);
    return result.rows;
  },

  async findById(id, userId) {
    const query = `
      SELECT n.id, n.user_id, n.subject_id, n.title, n.content, n.tags, n.is_shared,
             n.created_at, n.updated_at, s.name as subject_name, s.code as subject_code, s.color as subject_color
      FROM notes n
      LEFT JOIN subjects s ON n.subject_id = s.id
      WHERE n.id = $1 AND (n.user_id = $2 OR n.is_shared = true);
    `;
    const result = await db.query(query, [id, userId]);
    return result.rows[0] || null;
  },

  async update(id, userId, { subjectId, title, content, tags, isShared }) {
    const query = `
      UPDATE notes
      SET
        subject_id = COALESCE($3, subject_id),
        title = COALESCE($4, title),
        content = COALESCE($5, content),
        tags = COALESCE($6, tags),
        is_shared = COALESCE($7, is_shared),
        updated_at = CURRENT_TIMESTAMP
      WHERE id = $1 AND user_id = $2
      RETURNING id, user_id, subject_id, title, content, tags, is_shared, created_at, updated_at;
    `;
    const values = [id, userId, subjectId, title, content, tags, isShared];
    const result = await db.query(query, values);
    return result.rows[0] || null;
  },

  async delete(id, userId) {
    const query = `
      DELETE FROM notes
      WHERE id = $1 AND user_id = $2
      RETURNING id;
    `;
    const result = await db.query(query, [id, userId]);
    return result.rows[0] || null;
  },
};

module.exports = NoteModel;

