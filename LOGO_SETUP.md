# Logo Upload Setup Instructions

## Database Migration

Before using the logo upload feature, you need to run the database migration to add the necessary fields and tables.

### Steps:

1. **Open Supabase SQL Editor**
   - Go to your Supabase project dashboard
   - Click on "SQL Editor" in the left sidebar

2. **Run the Migration**
   - Open the file `migrations/add_logos.sql`
   - Copy all the SQL code
   - Paste it into the SQL Editor
   - Click "Run" or press Ctrl+Enter

3. **Verify the Migration**
   - The migration will:
     - Add `logo_url` column to the `tournaments` table
     - Create `app_settings` table for app-wide settings
     - Insert a default empty app logo setting
   - You should see a success message after running

## Using the Logo Upload Feature

### App Logo (Appears in Header Left Side)

1. Go to the **Tournaments** tab (admin only)
2. You'll see an "App Logo" section at the top
3. Click "Upload App Logo" button
4. Select an image file (max 2MB, square images recommended)
5. The logo will appear in the header on the left side

### Tournament Logo (Appears in Header Right Side)

1. Go to the **Course** tab (admin only)
2. Click "Edit Tournament" button
3. Scroll down to the "Tournament Logo" section
4. Click "Upload Logo" button
5. Select an image file (max 2MB, square images recommended)
6. The logo will appear in the header on the right side
7. Click "Remove Logo" to delete the tournament logo if needed

## Technical Details

- Logos are stored as base64-encoded strings in the database
- Maximum file size: 2MB
- Recommended dimensions: Square images (e.g., 512x512px)
- Supported formats: Any image format (PNG, JPG, etc.)
- The header displays:
  - Left: App logo (or trophy icon if no logo)
  - Center: "THE LEGS OPEN" title and tournament name
  - Right: Tournament logo (or empty space if no logo)
