const db = require('../config/database');

const QuestionModel = {
  async create({ userId, subjectId, question, answer, imageUrl, isStarred = false, isShared = false }) {
    const query = `
      INSERT INTO questions (user_id, subject_id, question, answer, image_url, is_starred, is_shared)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING id, user_id, subject_id, question, answer, image_url, is_starred, is_shared, created_at, updated_at;
    `;
    const values = [userId, subjectId || null, question, answer || null, imageUrl || null, isStarred, isShared];
    const result = await db.query(query, values);
    return result.rows[0];
  },

  async findAll({ userId, subjectId, filter }) {
    let query = `
      SELECT q.id, q.user_id, q.subject_id, q.question, q.answer, q.image_url,
             q.is_starred, q.is_shared, q.created_at, q.updated_at,
             s.name as subject_name, s.code as subject_code, s.color as subject_color
      FROM questions q
      LEFT JOIN subjects s ON q.subject_id = s.id
    `;
    const conditions = [];
    const values = [];

    if (filter === 'shared') {
      conditions.push(`q.is_shared = true`);
    } else if (filter === 'starred') {
      values.push(userId);
      conditions.push(`q.user_id = $${values.length} AND q.is_starred = true`);
    } else {
      values.push(userId);
      conditions.push(`(q.user_id = $${values.length} OR q.is_shared = true)`);
    }

    if (subjectId) {
      values.push(subjectId);
      conditions.push(`q.subject_id = $${values.length}`);
    }

    if (conditions.length > 0) {
      query += ` WHERE ${conditions.join(' AND ')}`;
    }

    query += ` ORDER BY q.created_at DESC;`;

    const result = await db.query(query, values);
    return result.rows;
  },

  async findById(id, userId) {
    const query = `
      SELECT q.id, q.user_id, q.subject_id, q.question, q.answer, q.image_url,
             q.is_starred, q.is_shared, q.created_at, q.updated_at,
             s.name as subject_name, s.code as subject_code, s.color as subject_color
      FROM questions q
      LEFT JOIN subjects s ON q.subject_id = s.id
      WHERE q.id = $1 AND (q.user_id = $2 OR q.is_shared = true);
    `;
    const result = await db.query(query, [id, userId]);
    return result.rows[0] || null;
  },

  async update(id, userId, { subjectId, question, answer, imageUrl, isStarred, isShared }) {
    const query = `
      UPDATE questions
      SET
        subject_id = COALESCE($3, subject_id),
        question = COALESCE($4, question),
        answer = COALESCE($5, answer),
        image_url = COALESCE($6, image_url),
        is_starred = COALESCE($7, is_starred),
        is_shared = COALESCE($8, is_shared),
        updated_at = CURRENT_TIMESTAMP
      WHERE id = $1 AND user_id = $2
      RETURNING id, user_id, subject_id, question, answer, image_url, is_starred, is_shared, created_at, updated_at;
    `;
    const values = [id, userId, subjectId, question, answer, imageUrl, isStarred, isShared];
    const result = await db.query(query, values);
    return result.rows[0] || null;
  },

  async toggleStar(id, userId) {
    const existing = await this.findById(id, userId);
    if (!existing) return null;

    const query = `
      UPDATE questions
      SET is_starred = NOT is_starred, updated_at = CURRENT_TIMESTAMP
      WHERE id = $1 AND user_id = $2
      RETURNING id, user_id, subject_id, question, answer, image_url, is_starred, is_shared, created_at, updated_at;
    `;
    const result = await db.query(query, [id, userId]);
    return result.rows[0] || null;
  },

  async delete(id, userId) {
    const query = `
      DELETE FROM questions
      WHERE id = $1 AND user_id = $2
      RETURNING id;
    `;
    const result = await db.query(query, [id, userId]);
    return result.rows[0] || null;
  },
};

module.exports = QuestionModel;

