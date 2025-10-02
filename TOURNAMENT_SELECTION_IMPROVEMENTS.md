# Tournament Selection Improvements

## Overview
Enhanced the tournament selection system to be more intelligent and user-friendly with persistent state, active tournament management, and clear visual indicators.

## Changes Made

### 1. Database Schema Enhancements
**File:** `migrations/add_tournament_status.sql`

Added new fields to the `tournaments` table:
- `start_date` (DATE): Tournament start date
- `end_date` (DATE): Tournament end date
- `is_active` (BOOLEAN): Flag for the currently active tournament
- `status` (TEXT): Tournament status ('upcoming', 'active', 'completed')

**Features:**
- Database trigger ensures only ONE tournament can be active at a time
- Indexes for faster queries on active tournaments
- Automatic migration to set most recent tournament as active if none are active

**To Apply:**
Run the SQL in `migrations/add_tournament_status.sql` in your Supabase SQL editor.

### 2. Smart Tournament Selection Logic

**Priority Order:**
1. **Previously selected tournament** (stored in localStorage) - Restores your last selection
2. **Active tournament** (is_active = true) - The tournament marked as currently active
3. **Most recent tournament by year** - Falls back to newest tournament

**Benefits:**
- Users don't lose their context when refreshing the page
- Clear indication of which tournament is currently active
- Automatic selection of the most relevant tournament

### 3. LocalStorage Persistence

The selected tournament ID is automatically saved to localStorage and restored on page load. This means:
- Refreshing the page maintains your tournament selection
- Works across browser tabs
- No server-side session management needed

### 4. Visual Status Indicators

**Status Badges:**
- **Active** (Green): Currently running tournament
- **Upcoming** (Blue): Future tournaments
- **Completed** (Gray): Past tournaments

**Tournament Cards Now Show:**
- Status badge in top-right corner
- Tournament dates (if set)
- "Active Tournament" indicator with trophy icon
- "Set as Active" button for upcoming/active tournaments

### 5. Enhanced Tournament Management

**Tournament Creation Form:**
- Added start date field
- Added end date field
- Added status dropdown (upcoming/active/completed)

**Course Tab (renamed to "Tournament & Course Details"):**
- New "Edit Tournament" button (blue)
- Can update tournament name, year, dates, and status
- Clear separation between tournament info and course details
- Visual status badge display

**Tournaments Tab:**
- Each tournament card shows status and dates
- Click "Set as Active" to make any tournament the active one
- Active tournament is clearly marked

## Usage Guide

### Setting Up a New Tournament

1. Go to **Tournaments** tab
2. Click **Create Tournament**
3. Fill in details:
   - Name, Year
   - Start Date, End Date (optional but recommended)
   - Status (leave as "Upcoming" for future tournaments)
4. Search for course or enter manually
5. Create tournament

### Managing Active Tournament

**Option 1: Set from Tournaments Tab**
- Click "Set as Active" button on any upcoming tournament card

**Option 2: Set from Course Tab**
- Click "Edit Tournament"
- Change status to "Active"
- Click "Save Tournament Details"

Only ONE tournament can be active at a time - setting a new active tournament automatically deactivates others.

### Scoring Workflow

1. Set tournament as **Active** before the event
2. Tournament will be automatically selected for scoring
3. Update status to **Completed** after the event finishes
4. Status doesn't affect scoring functionality, but helps with organization

## Technical Details

### State Management
- `currentTournament`: Currently selected tournament (React state)
- `localStorage.selectedTournamentId`: Persisted selection across sessions
- Database `is_active` flag: Server-side active tournament marker

### Functions Added
- `selectSmartTournament(tournaments)`: Implements priority-based selection logic
- `setTournamentActive(tournamentId)`: Marks a tournament as active
- `updateTournamentDetails(tournament)`: Updates tournament metadata
- `getStatusBadgeColor(status)`: Returns CSS classes for status badges
- `getStatusLabel(status)`: Formats status text

### Database Trigger
```sql
CREATE TRIGGER single_active_tournament_trigger
  BEFORE INSERT OR UPDATE ON tournaments
  FOR EACH ROW
  EXECUTE FUNCTION enforce_single_active_tournament();
```
This ensures data integrity by automatically deactivating other tournaments when one is set to active.

## Migration Path

### For Existing Tournaments

1. **Run the migration SQL** to add new columns
2. **Set dates** for existing tournaments via the Course tab
3. **Mark the current tournament as Active** using "Set as Active" button
4. **Mark past tournaments as Completed** to keep things organized

### Backward Compatibility

The app works with or without the new fields:
- Old tournaments without dates will work fine
- Default status is "upcoming" if not set
- Smart selection falls back to "most recent by year" if needed

## Future Enhancements

Potential improvements to consider:
- Automatic status updates based on dates (e.g., mark as "active" on start_date)
- Tournament archive/filter by status
- Multi-day tournament support with daily leaderboards
- Tournament templates for recurring events
- Email notifications for tournament start/end
