-- Fix: Ensure only one tournament is active
-- Run this in your Supabase SQL editor if you have multiple active tournaments

-- First, deactivate ALL tournaments
UPDATE tournaments SET is_active = false;

-- Then, set only the most recent tournament as active
UPDATE tournaments
SET is_active = true, status = 'active'
WHERE id = (
  SELECT id FROM tournaments
  ORDER BY year DESC, created_at DESC
  LIMIT 1
);

-- Verify the fix
SELECT id, name, year, is_active, status FROM tournaments ORDER BY year DESC;
