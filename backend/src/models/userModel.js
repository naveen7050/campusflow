const db = require('../config/database');

const UserModel = {
  async createUser({ fullName, email, passwordHash, studentId, department, semester, role = 'student' }) {
    const query = `
      INSERT INTO users (full_name, email, password_hash, student_id, department, semester, role)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING id, full_name, email, student_id, department, semester, role, avatar_url, created_at;
    `;
    const values = [fullName, email, passwordHash, studentId || null, department || null, semester || null, role];
    const result = await db.query(query, values);
    return result.rows[0];
  },

  async findByEmail(email) {
    const query = `
      SELECT id, full_name, email, password_hash, student_id, department, semester, role, avatar_url, created_at
      FROM users
      WHERE LOWER(email) = LOWER($1);
    `;
    const result = await db.query(query, [email]);
    return result.rows[0] || null;
  },

  async findById(id) {
    const query = `
      SELECT id, full_name, email, student_id, department, semester, role, avatar_url, created_at
      FROM users
      WHERE id = $1;
    `;
    const result = await db.query(query, [id]);
    return result.rows[0] || null;
  },
};

module.exports = UserModel;
