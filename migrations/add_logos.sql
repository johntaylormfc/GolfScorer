-- Migration: Add logo fields for app and tournaments
-- Run this in your Supabase SQL editor

-- Add logo_url column to tournaments table
ALTER TABLE tournaments
ADD COLUMN IF NOT EXISTS logo_url TEXT;

-- Create a new settings table for app-wide settings like app logo
CREATE TABLE IF NOT EXISTS app_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  setting_key TEXT UNIQUE NOT NULL,
  setting_value TEXT,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert default app logo setting (empty initially)
INSERT INTO app_settings (setting_key, setting_value)
VALUES ('app_logo_url', '')
ON CONFLICT (setting_key) DO NOTHING;

-- Verify the changes
SELECT * FROM app_settings;
SELECT id, name, logo_url FROM tournaments ORDER BY year DESC;
