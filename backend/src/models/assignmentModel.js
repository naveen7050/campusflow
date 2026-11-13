const db = require('../config/database');

const AssignmentModel = {
  async create({ userId, subjectId, title, description, dueDate, isSubmitted = false }) {
    const query = `
      INSERT INTO assignments (user_id, subject_id, title, description, due_date, is_submitted, submitted_at)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING id, user_id, subject_id, title, description, due_date, is_submitted, submitted_at, created_at, updated_at;
    `;
    const submittedAt = isSubmitted ? new Date() : null;
    const values = [userId, subjectId || null, title, description || '', dueDate || null, isSubmitted, submittedAt];
    const result = await db.query(query, values);
    return result.rows[0];
  },

  async findAll({ userId, subjectId, filter }) {
    let query = `
      SELECT a.id, a.user_id, a.subject_id, a.title, a.description, a.due_date,
             a.is_submitted, a.submitted_at, a.created_at, a.updated_at,
             s.name as subject_name, s.code as subject_code, s.color as subject_color
      FROM assignments a
      LEFT JOIN subjects s ON a.subject_id = s.id
      WHERE a.user_id = $1
    `;
    const values = [userId];

    if (subjectId) {
      values.push(subjectId);
      query += ` AND a.subject_id = $${values.length}`;
    }

    if (filter === 'upcoming') {
      query += ` AND a.is_submitted = false`;
    } else if (filter === 'completed') {
      query += ` AND a.is_submitted = true`;
    }

    query += ` ORDER BY a.due_date ASC NULLS LAST, a.created_at DESC;`;

    const result = await db.query(query, values);
    return result.rows;
  },

  async findById(id, userId) {
    const query = `
      SELECT a.id, a.user_id, a.subject_id, a.title, a.description, a.due_date,
             a.is_submitted, a.submitted_at, a.created_at, a.updated_at,
             s.name as subject_name, s.code as subject_code, s.color as subject_color
      FROM assignments a
      LEFT JOIN subjects s ON a.subject_id = s.id
      WHERE a.id = $1 AND a.user_id = $2;
    `;
    const result = await db.query(query, [id, userId]);
    return result.rows[0] || null;
  },

  async update(id, userId, { subjectId, title, description, dueDate, isSubmitted }) {
    let submittedAt = undefined;
    if (isSubmitted !== undefined) {
      submittedAt = isSubmitted ? new Date() : null;
    }

    const query = `
      UPDATE assignments
      SET
        subject_id = COALESCE($3, subject_id),
        title = COALESCE($4, title),
        description = COALESCE($5, description),
        due_date = COALESCE($6, due_date),
        is_submitted = COALESCE($7, is_submitted),
        submitted_at = CASE WHEN $7 IS NOT NULL THEN $8 ELSE submitted_at END,
        updated_at = CURRENT_TIMESTAMP
      WHERE id = $1 AND user_id = $2
      RETURNING id, user_id, subject_id, title, description, due_date, is_submitted, submitted_at, created_at, updated_at;
    `;
    const values = [id, userId, subjectId, title, description, dueDate, isSubmitted, submittedAt];
    const result = await db.query(query, values);
    return result.rows[0] || null;
  },

  async toggleSubmission(id, userId) {
    const existing = await this.findById(id, userId);
    if (!existing) return null;

    const newStatus = !existing.is_submitted;
    const submittedAt = newStatus ? new Date() : null;

    const query = `
      UPDATE assignments
      SET is_submitted = $3, submitted_at = $4, updated_at = CURRENT_TIMESTAMP
      WHERE id = $1 AND user_id = $2
      RETURNING id, user_id, subject_id, title, description, due_date, is_submitted, submitted_at, created_at, updated_at;
    `;
    const result = await db.query(query, [id, userId, newStatus, submittedAt]);
    return result.rows[0];
  },

  async delete(id, userId) {
    const query = `
      DELETE FROM assignments
      WHERE id = $1 AND user_id = $2
      RETURNING id;
    `;
    const result = await db.query(query, [id, userId]);
    return result.rows[0] || null;
  },
};

module.exports = AssignmentModel;

