-- Migration: Create subjects table
CREATE TABLE IF NOT EXISTS subjects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(150) NOT NULL,
  code VARCHAR(50),
  description TEXT,
  semester INTEGER,
  department VARCHAR(100),
  color VARCHAR(20) DEFAULT '#0F5132',
  icon VARCHAR(50) DEFAULT 'menu_book',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_subjects_user_id ON subjects(user_id);
CREATE INDEX IF NOT EXISTS idx_subjects_user_semester ON subjects(user_id, semester);

