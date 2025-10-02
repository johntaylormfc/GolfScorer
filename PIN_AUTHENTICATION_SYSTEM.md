# PIN Authentication System

## Overview
Implemented a PIN-based authentication system to control access and editing permissions throughout the app.

## Features

### 1. PIN Entry Screen
- **Clean UI** - Shows on app load before any content
- **4-digit input** - Numeric keypad on mobile, masked input
- **Validation** - Checks against admin PIN and all group PINs
- **Error handling** - Shows "Invalid PIN" message on failure

### 2. Admin Access (PIN: 1991)
**Full Control:**
- ✅ View all tabs (Tournaments, Course, Setup, Scoring, Leaderboard, Players, History)
- ✅ Create/edit tournaments
- ✅ Add/edit players
- ✅ Generate groups
- ✅ Edit ALL scores for ALL groups
- ✅ View all group PINs

**Group PIN Display:**
- PINs shown under each group button in Scoring tab
- PIN shown in group header when selected
- Blue, monospace font for easy reading

### 3. Group User Access (4-digit PINs)
**Limited Access:**
- ✅ View only Scoring and Leaderboard tabs
- ✅ Automatically directed to their tournament's Scoring tab
- ✅ See only their assigned group
- ✅ Edit ONLY scores for their group
- ❌ Cannot edit other groups' scores
- ❌ Cannot access setup, players, or tournament management

**Restrictions:**
- Score inputs are read-only for other groups (grayed out)
- Tab navigation limited to Scoring and Leaderboard
- Automatically set to correct tournament on login

### 4. Automatic PIN Generation
When groups are created:
- Each group gets a unique random 4-digit PIN (1000-9999)
- PINs are guaranteed unique within the tournament
- Stored in database for persistence

## Database Changes

### Migration Required
Run `migrations/add_group_pins.sql` in Supabase:

```sql
ALTER TABLE groups ADD COLUMN IF NOT EXISTS pin TEXT;

-- Generate PINs for existing groups
UPDATE groups
SET pin = LPAD(FLOOR(RANDOM() * 10000)::TEXT, 4, '0')
WHERE pin IS NULL;
```

## Usage Workflow

### For Tournament Organizers (Admins)
1. Enter PIN `1991` on app load
2. Create tournament and add players
3. Generate groups (PINs automatically created)
4. View group PINs in Scoring tab
5. Share PINs with each group (via text, email, etc.)
6. Monitor scoring for all groups
7. View leaderboard

### For Players (Group Users)
1. Receive 4-digit PIN from organizer (e.g., "5847")
2. Enter PIN on app load
3. Automatically directed to Scoring tab for their tournament
4. See only their group
5. Enter scores for their group's players
6. View leaderboard
7. Cannot interfere with other groups

## Security Notes

**Current Implementation:**
- PIN validation against database (group PINs)
- Hard-coded admin PIN (1991)
- Client-side only (no server sessions)
- PINs shown to admins for easy distribution

**Not Implemented (Future Enhancements):**
- PIN hashing/encryption
- PIN change functionality
- Session timeout
- Server-side PIN validation
- Audit logging

**Why This Approach:**
- Simple for non-technical users
- Easy PIN distribution
- No accounts or passwords needed
- Sufficient for trusted tournament environment
- Easy to reset (regenerate groups)

## UI/UX Features

### PIN Entry Screen
- Centered modal-style card
- Trophy icon branding
- Large, clear input field
- Auto-focus on input
- Disabled submit until 4 digits entered
- Shows admin PIN hint for convenience

### Admin View
- All tabs visible
- Group PINs displayed prominently
- Blue text to differentiate from other content
- PIN shown: Under group buttons and in group header

### Group User View
- Only 2 tabs (Scoring, Leaderboard)
- Clean, focused interface
- Cannot access other groups
- Read-only inputs for other groups (visual feedback)

## Code Changes

### Files Modified
- **app.js**
  - Added authentication state (lines 79-84)
  - Added PIN validation logic (lines 614-652)
  - Added PIN generation (lines 610-612)
  - Updated generateGroups to create PINs (lines 513-546)
  - Added PIN entry screen (lines 1677-1712)
  - Added role-based tab filtering (lines 1777-1791)
  - Added role-based group filtering (lines 1172-1174)
  - Added role-based edit permissions (lines 1215, 1221-1223)
  - Show PINs to admins only (lines 1187-1189, 1195-1197)

### Files Created
- **migrations/add_group_pins.sql** - Database migration

## Testing Checklist

- [x] Admin PIN (1991) grants full access
- [x] Group PIN grants limited access
- [x] Invalid PIN shows error message
- [x] Admin sees all tabs
- [x] Group user sees only Scoring/Leaderboard
- [x] Admin can edit all scores
- [x] Group user can only edit their group's scores
- [x] Other groups' scores are read-only
- [x] Group PINs visible to admin
- [x] Group PINs hidden from group users
- [x] Unique PINs generated for each group
- [x] Group user auto-navigates to their tournament

## Future Enhancements

1. **Logout Button** - Allow users to return to PIN entry
2. **Change PIN** - Let admins regenerate group PINs
3. **PIN History** - Track which PINs were used when
4. **Expiring PINs** - Set time limits on group PINs
5. **Custom PINs** - Let admins set specific PINs (e.g., "2024")
6. **Multiple Admins** - Support multiple admin PINs
7. **PIN Recovery** - Send PIN via email/SMS
8. **Session Timeout** - Require re-entry after inactivity
9. **Audit Log** - Track who entered scores and when
10. **PIN Strength** - Option for 6-digit or alphanumeric PINs

## Known Limitations

1. **No logout** - Need to refresh page to change PIN
2. **Client-side only** - Could be bypassed by technical users
3. **Hard-coded admin PIN** - Should be configurable
4. **No PIN recovery** - Lost PINs require regenerating groups
5. **No multi-tournament** - Group users see only one tournament

## Support Notes

**If user forgets their PIN:**
- Admin can view PIN in Scoring tab
- Or regenerate groups (creates new PINs)

**If admin PIN is compromised:**
- Change hard-coded PIN in app.js line 619
- Redeploy app

**If group user can't access:**
- Verify they're in a group (Setup tab)
- Verify group has a PIN (visible to admin)
- Try regenerating groups
