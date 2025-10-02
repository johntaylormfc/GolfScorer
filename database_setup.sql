-- =====================================================
-- Golf Scorer - Complete Database Setup Script
-- =====================================================
-- Run this script in your Supabase SQL Editor to create all required tables
-- This will set up the complete database schema for the Golf Scorer application

-- =====================================================
-- 1. PLAYERS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS players (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  handicap NUMERIC NOT NULL,
  cdh_number TEXT,
  bio TEXT,
  photo_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for faster player lookups
CREATE INDEX IF NOT EXISTS idx_players_name ON players(name);

-- =====================================================
-- 2. TOURNAMENTS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS tournaments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  year INTEGER NOT NULL,
  course_name TEXT NOT NULL,
  slope_rating NUMERIC DEFAULT 113,
  course_rating NUMERIC DEFAULT 72,
  start_date DATE,
  end_date DATE,
  is_active BOOLEAN DEFAULT false,
  status TEXT DEFAULT 'upcoming' CHECK (status IN ('upcoming', 'active', 'completed')),
  logo_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_tournaments_year ON tournaments(year DESC);
CREATE INDEX IF NOT EXISTS idx_tournaments_active ON tournaments(is_active) WHERE is_active = true;
CREATE INDEX IF NOT EXISTS idx_tournaments_status ON tournaments(status);

-- Ensure only one tournament is active at a time
CREATE OR REPLACE FUNCTION enforce_single_active_tournament()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.is_active = true THEN
    UPDATE tournaments
    SET is_active = false
    WHERE id != NEW.id AND is_active = true;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS single_active_tournament_trigger ON tournaments;
CREATE TRIGGER single_active_tournament_trigger
  BEFORE INSERT OR UPDATE ON tournaments
  FOR EACH ROW
  EXECUTE FUNCTION enforce_single_active_tournament();

-- =====================================================
-- 3. HOLES TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS holes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tournament_id UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
  hole_number INTEGER NOT NULL CHECK (hole_number >= 1 AND hole_number <= 18),
  par INTEGER NOT NULL CHECK (par >= 3 AND par <= 5),
  stroke_index INTEGER NOT NULL CHECK (stroke_index >= 1 AND stroke_index <= 18),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(tournament_id, hole_number)
);

-- Create index for faster hole lookups
CREATE INDEX IF NOT EXISTS idx_holes_tournament ON holes(tournament_id, hole_number);

-- =====================================================
-- 4. TOURNAMENT_PLAYERS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS tournament_players (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tournament_id UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
  player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(tournament_id, player_id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_tournament_players_tournament ON tournament_players(tournament_id);
CREATE INDEX IF NOT EXISTS idx_tournament_players_player ON tournament_players(player_id);

-- =====================================================
-- 5. GROUPS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS groups (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tournament_id UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
  group_number INTEGER NOT NULL,
  name TEXT,
  tee_time TIME,
  pin TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(tournament_id, group_number)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_groups_tournament ON groups(tournament_id);
CREATE INDEX IF NOT EXISTS idx_groups_pin ON groups(pin);

-- =====================================================
-- 6. GROUP_PLAYERS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS group_players (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
  player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  is_scorer BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(group_id, player_id)
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_group_players_group ON group_players(group_id);
CREATE INDEX IF NOT EXISTS idx_group_players_player ON group_players(player_id);

-- =====================================================
-- 7. SCORES TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS scores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tournament_id UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
  player_id UUID NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  hole_id UUID NOT NULL REFERENCES holes(id) ON DELETE CASCADE,
  gross_score INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(tournament_id, player_id, hole_id)
);

-- Create indexes for faster score lookups
CREATE INDEX IF NOT EXISTS idx_scores_tournament ON scores(tournament_id);
CREATE INDEX IF NOT EXISTS idx_scores_player ON scores(player_id);
CREATE INDEX IF NOT EXISTS idx_scores_hole ON scores(hole_id);

-- =====================================================
-- 8. APP_SETTINGS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS app_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  setting_key TEXT UNIQUE NOT NULL,
  setting_value TEXT,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert default app logo setting
INSERT INTO app_settings (setting_key, setting_value)
VALUES ('app_logo_url', '')
ON CONFLICT (setting_key) DO NOTHING;

-- Create index
CREATE INDEX IF NOT EXISTS idx_app_settings_key ON app_settings(setting_key);

-- =====================================================
-- ROW LEVEL SECURITY (RLS) - Optional
-- =====================================================
-- Uncomment these if you want to enable RLS for security
-- Note: You'll need to configure authentication policies based on your needs

-- Enable RLS on all tables
-- ALTER TABLE players ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE tournaments ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE holes ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE tournament_players ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE groups ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE group_players ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE scores ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE app_settings ENABLE ROW LEVEL SECURITY;

-- Example: Allow public read access (adjust based on your security requirements)
-- CREATE POLICY "Allow public read access" ON players FOR SELECT USING (true);
-- CREATE POLICY "Allow public read access" ON tournaments FOR SELECT USING (true);
-- CREATE POLICY "Allow public read access" ON holes FOR SELECT USING (true);
-- CREATE POLICY "Allow public read access" ON scores FOR SELECT USING (true);

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================
-- Run these to verify your tables were created successfully

-- List all tables
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- Count rows in each table
SELECT
  'players' as table_name, COUNT(*) as row_count FROM players
UNION ALL
SELECT 'tournaments', COUNT(*) FROM tournaments
UNION ALL
SELECT 'holes', COUNT(*) FROM holes
UNION ALL
SELECT 'tournament_players', COUNT(*) FROM tournament_players
UNION ALL
SELECT 'groups', COUNT(*) FROM groups
UNION ALL
SELECT 'group_players', COUNT(*) FROM group_players
UNION ALL
SELECT 'scores', COUNT(*) FROM scores
UNION ALL
SELECT 'app_settings', COUNT(*) FROM app_settings;

-- =====================================================
-- SETUP COMPLETE!
-- =====================================================
-- Your Golf Scorer database is now ready to use
-- Next steps:
-- 1. Go to your application
-- 2. Log in with admin PIN: 1991
-- 3. Create your first tournament
-- 4. Add players and start scoring!
