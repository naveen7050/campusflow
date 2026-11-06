const fs = require('fs');
const path = require('path');
const db = require('../config/database');

async function runMigrations() {
  const migrationsDir = path.join(__dirname, '../../migrations');

  try {
    const files = fs.readdirSync(migrationsDir).filter((file) => file.endsWith('.sql')).sort();

    console.log(`Found ${files.length} migration file(s).`);

    for (const file of files) {
      const filePath = path.join(migrationsDir, file);
      const sql = fs.readFileSync(filePath, 'utf8');

      console.log(`Executing migration: ${file}`);
      await db.query(sql);
      console.log(`Successfully executed: ${file}`);
    }

    console.log('All migrations executed successfully.');
  } catch (error) {
    console.error('Migration failed:', error);
    process.exit(1);
  } finally {
    await db.pool.end();
  }
}

runMigrations();
