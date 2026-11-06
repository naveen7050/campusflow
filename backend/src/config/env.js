require('dotenv').config();

module.exports = {
  port: process.env.PORT || 5000,
  nodeEnv: process.env.NODE_ENV || 'development',
  db: {
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT, 10) || 5432,
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || 'postgres',
    database: process.env.DB_NAME || 'campusflow_db',
  },
  jwt: {
    secret: process.env.JWT_SECRET || 'default_secret_key',
    expiresIn: process.env.JWT_EXPIRES_IN || '7d',
  },
};
