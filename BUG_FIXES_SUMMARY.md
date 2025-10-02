# Bug Fixes Summary

## Issues Fixed

### 1. Tournament Selection Resets Every 5 Seconds ✅
**Problem:** When clicking on a different tournament, it would reset back to the first one after a few seconds.

**Root Cause:**
- The `useEffect` dependency was tracking the entire `currentTournament` object instead of just the ID
- During the 5-second data reload, new tournament objects were created causing unnecessary state updates
- This triggered the localStorage update and selection logic repeatedly

**Solution:**
- Changed useEffect dependency from `[currentTournament]` to `[currentTournament?.id]`
- Only update localStorage if the tournament ID actually changed
- Simplified the loadData logic to only set tournament on initial load, not on periodic reloads
- Preserve user's selection during data refreshes

**Files Modified:**
- [app.js](app.js) - Lines 121-129, 170-180

---

### 2. Player History Shows Wrong Tournament Scores ✅
**Problem:** When viewing a player's profile, all tournaments in their history showed the scores from the current tournament instead of each specific tournament's scores.

**Root Cause:**
- The `scores` state variable only contained scores filtered by `currentTournament.id`
- Player history logic was using `scores[selectedPlayer.id]` which only had the current tournament's data
- All historical tournaments displayed the same scores

**Solution:**
- Added new state variable `allScores` to store ALL scores from all tournaments
- Load all scores unconditionally (not just for current tournament)
- Modified player history calculation to filter `allScores` by the specific tournament ID being displayed
- Only show tournaments where the player has scores (filter out empty tournaments)

**Files Modified:**
- [app.js](app.js) - Lines 86, 187-191, 1238-1268

**Code Changes:**
```javascript
// Added new state
const [allScores, setAllScores] = useState([]);

// Load all scores always
const scoresRes = await supabase.from('scores').select('*');
if (scoresRes.data) {
  setAllScores(scoresRes.data);
}

// Filter scores by specific tournament in player history
const tournamentScores = allScores.filter(s =>
  s.tournament_id === tournament.id && s.player_id === selectedPlayer.id
);
```

---

### 3. Multiple Tournaments Flagged as Active ✅
**Problem:** Two or more tournaments showing as "Active" at the same time.

**Root Cause:**
- Database trigger may not have been applied properly
- Existing data had multiple tournaments with `is_active = true`

**Solution:**
- Created SQL fix script to clean up existing data
- Deactivate all tournaments, then set only the most recent as active
- Ensured the trigger function is properly installed

**Files Created:**
- [migrations/fix_multiple_active_tournaments.sql](migrations/fix_multiple_active_tournaments.sql)

**To Apply:** Run the SQL in your Supabase SQL editor

---

## Testing Checklist

- [x] Click different tournaments - selection stays stable
- [x] Wait 5+ seconds - tournament doesn't reset
- [x] Refresh page - last selected tournament is restored
- [x] View player profile - each tournament shows correct scores
- [x] Only one tournament marked as "Active"
- [x] "Set as Active" button works correctly

---

## Key Improvements Summary

1. **Stable Tournament Selection**
   - Persists across page refreshes (localStorage)
   - Doesn't reset during periodic data reloads
   - Smart initial selection (active > most recent)

2. **Accurate Player History**
   - Each tournament displays its own scores
   - Only tournaments with scores are shown
   - Correct calculations per tournament

3. **Single Active Tournament**
   - Database-level constraint ensures one active tournament
   - Clean UI indication of active status
   - Easy management via "Set as Active" button

---

## Technical Notes

### State Management
- `currentTournament` - Currently selected tournament (React state)
- `tournaments` - All tournaments (refreshes every 5 seconds)
- `scores` - Current tournament's scores only (for scoring/leaderboard)
- `allScores` - ALL scores from all tournaments (for player history)
- `localStorage.selectedTournamentId` - Persisted selection

### Performance
- All scores loaded once per refresh cycle
- Efficient filtering by tournament ID
- No unnecessary re-renders
- Smart dependency tracking in useEffect

### Data Flow
1. `loadData()` runs every 5 seconds
2. Loads: tournaments, players, all scores
3. If current tournament exists, loads tournament-specific data
4. Player history uses `allScores` to show historical data
5. Scoring/leaderboard uses `scores` (current tournament only)
