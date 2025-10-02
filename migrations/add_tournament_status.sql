-- Migration: Add tournament status and date fields
-- Run this in your Supabase SQL editor

-- Add new columns to tournaments table
ALTER TABLE tournaments
ADD COLUMN IF NOT EXISTS start_date DATE,
ADD COLUMN IF NOT EXISTS end_date DATE,
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'upcoming' CHECK (status IN ('upcoming', 'active', 'completed'));

-- Create index for faster active tournament queries
CREATE INDEX IF NOT EXISTS idx_tournaments_active ON tournaments(is_active) WHERE is_active = true;
CREATE INDEX IF NOT EXISTS idx_tournaments_status ON tournaments(status);

-- Add constraint to ensure only one tournament is active at a time
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

-- Optional: Set the most recent tournament as active if none are active
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM tournaments WHERE is_active = true) THEN
    UPDATE tournaments
    SET is_active = true, status = 'active'
    WHERE id = (
      SELECT id FROM tournaments
      ORDER BY year DESC, created_at DESC
      LIMIT 1
    );
  END IF;
END $$;
