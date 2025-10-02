-- Migration: Add group names and tee times
-- Run this in your Supabase SQL editor

-- Add name and tee_time columns to groups table
ALTER TABLE groups
ADD COLUMN IF NOT EXISTS name TEXT,
ADD COLUMN IF NOT EXISTS tee_time TIME;

-- Update existing groups with default names
UPDATE groups
SET name = 'Group ' || group_number
WHERE name IS NULL;

-- Verify the update
SELECT id, group_number, name, tee_time, pin FROM groups ORDER BY tournament_id, group_number;
