-- Migration: Add PIN field to groups table
-- Run this in your Supabase SQL editor

-- Add PIN column to groups table
ALTER TABLE groups
ADD COLUMN IF NOT EXISTS pin TEXT;

-- Generate unique 4-digit PINs for existing groups that don't have one
UPDATE groups
SET pin = LPAD(FLOOR(RANDOM() * 10000)::TEXT, 4, '0')
WHERE pin IS NULL;

-- Ensure all future groups have a PIN (we'll handle this in the app)
-- Note: The app will generate PINs when creating groups

-- Verify the update
SELECT id, group_number, tournament_id, pin FROM groups ORDER BY tournament_id, group_number;
