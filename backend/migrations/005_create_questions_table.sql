-- Migration: Create questions table
CREATE TABLE IF NOT EXISTS questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  subject_id UUID REFERENCES subjects(id) ON DELETE SET NULL,
  question TEXT NOT NULL,
  answer TEXT,
  image_url TEXT,
  is_starred BOOLEAN DEFAULT false,
  is_shared BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_questions_user_id ON questions(user_id);
CREATE INDEX IF NOT EXISTS idx_questions_subject_id ON questions(subject_id);
CREATE INDEX IF NOT EXISTS idx_questions_is_starred ON questions(is_starred);
CREATE INDEX IF NOT EXISTS idx_questions_is_shared ON questions(is_shared);

