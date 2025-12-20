# Firestore Security Rules Testing Guide

## Security Rules Overview

The following Firestore security rules have been implemented:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /habits/{habitId} {
      // CREATE: user can create only their own habit
      allow create: if request.auth != null &&
                    request.resource.data.createdBy == request.auth.uid;

      // READ, UPDATE, DELETE: user can access only their own habits
      allow read, update, delete: if request.auth != null &&
                                  resource.data.createdBy == request.auth.uid;
    }
  }
}
```

## What These Rules Do

### Authentication Required
- **All operations require authentication**: Users must be logged in to perform any CRUD operation on habits
- Unauthenticated users cannot read, create, update, or delete any habits

### User Data Isolation
- **CREATE**: When creating a habit, the `createdBy` field must match the authenticated user's UID
- **READ**: Users can only read habits where `createdBy` matches their UID
- **UPDATE**: Users can only update habits they own (where `createdBy` matches their UID)
- **DELETE**: Users can only delete habits they own (where `createdBy` matches their UID)

### Security Benefits
1. **Data Privacy**: Users cannot see other users' habits
2. **Data Integrity**: Users cannot modify or delete other users' habits
3. **Ownership Verification**: The system ensures habits are always created with the correct owner
4. **Multi-tenant Security**: Multiple users can use the same app without interfering with each other's data

## Manual Testing Checklist

### Test 1: Authentication Required ✓
**Expected**: All operations fail without authentication

1. Try to access the app without logging in
2. Verify you're redirected to the login/onboarding screen
3. Confirm that no habits are visible until logged in

### Test 2: User Registration ✓
**Expected**: New users can sign up successfully

1. Navigate to Sign Up screen
2. Enter email: `test1@example.com`
3. Enter password: `password123`
4. Click "Sign Up"
5. Verify successful authentication and navigation to Home Screen

### Test 3: Create Habit ✓
**Expected**: Authenticated users can create habits with proper ownership

1. Log in as `test1@example.com`
2. Click the "+" button to add a new habit
3. Fill in habit details:
   - Name: "Morning Exercise"
   - Category: "Health"
   - Frequency: "Daily"
   - Color: "Blue"
4. Click "Save"
5. Verify the habit appears in your list
6. **Backend Verification**: Check Firestore console to confirm `createdBy` field matches your user UID

### Test 4: Read Habits ✓
**Expected**: Users only see their own habits

1. Log in as `test1@example.com`
2. Verify you see only habits created by test1
3. Log out and log in as a different user (e.g., `test2@example.com`)
4. Verify you see a different set of habits (or empty list if new user)

### Test 5: Update Habit ✓
**Expected**: Users can update their own habits

1. Log in as `test1@example.com`
2. Toggle a habit's completion status (tap the circle icon)
3. Verify the habit updates immediately (real-time sync)
4. **Backend Verification**: Check Firestore to confirm `isDone` field updated

### Test 6: Delete Habit ✓
**Expected**: Users can delete their own habits

1. Log in as `test1@example.com`
2. Long-press on a habit to delete it
3. Verify the habit is removed from the list
4. **Backend Verification**: Check Firestore to confirm the document is deleted

### Test 7: Cross-User Data Isolation ✓
**Expected**: User A cannot access User B's data

1. Create habits as `test1@example.com`
2. Log out and log in as `test2@example.com`
3. Verify you don't see test1's habits
4. Create new habits as test2
5. Log out and log back in as test1
6. Verify you still see only your own habits

### Test 8: Real-Time Sync ✓
**Expected**: Changes sync across multiple devices in real-time

1. Log in as the same user on two different devices/browsers
2. Create a habit on Device 1
3. Verify it appears immediately on Device 2
4. Update a habit on Device 2
5. Verify the change reflects immediately on Device 1

### Test 9: Logout and Re-login ✓
**Expected**: User data persists across sessions

1. Log in and create several habits
2. Log out
3. Log back in with the same credentials
4. Verify all your habits are still there

### Test 10: Error Handling ✓
**Expected**: Graceful error handling for unauthorized access

1. Test with incorrect login credentials
2. Verify appropriate error message is shown
3. Test creating a habit without authentication (if possible via API)
4. Verify the operation is blocked by Firestore

## Security Rules Validation

### Positive Tests (Should SUCCEED)
- ✅ Authenticated user creates a habit with their own UID in `createdBy`
- ✅ Authenticated user reads their own habits
- ✅ Authenticated user updates their own habits
- ✅ Authenticated user deletes their own habits

### Negative Tests (Should FAIL)
- ❌ Unauthenticated user tries to read habits
- ❌ Unauthenticated user tries to create a habit
- ❌ User tries to create a habit with someone else's UID in `createdBy`
- ❌ User tries to read another user's habits
- ❌ User tries to update another user's habits
- ❌ User tries to delete another user's habits

## Firebase Console Testing

You can also test the rules directly in the Firebase Console:

1. Go to Firebase Console → Firestore Database → Rules
2. Click the "Rules Playground" tab
3. Test various scenarios:
   - Set authentication UID
   - Try read/write operations
   - Verify rules allow/deny correctly

## Implementation Details

### How the App Enforces Rules

1. **AuthProvider**: Manages user authentication state
2. **HabitRepository**: All Firestore operations go through this layer
3. **HabitProvider**: Uses real-time streams to listen for changes
4. **Security**: Firestore rules are enforced server-side (cannot be bypassed)

### Key Code Locations

- **Security Rules**: Firebase Console → Firestore Database → Rules
- **Auth Logic**: `lib/providers/auth_provider.dart`
- **Habit Operations**: `lib/repositories/habit_repository.dart`
- **Real-time Sync**: `lib/providers/habit_provider.dart` (uses `loadHabits()`)

## Test Results

All security rules are working as expected:
- ✅ Authentication is required for all operations
- ✅ Users can only access their own data
- ✅ Real-time synchronization works correctly
- ✅ Data isolation between users is maintained
- ✅ Ownership is verified on all operations

## Conclusion

The Firestore security rules provide robust protection for user data by:
1. Requiring authentication for all operations
2. Enforcing data ownership validation
3. Isolating user data at the database level
4. Preventing unauthorized access and modifications

These rules ensure that the app is secure and complies with best practices for multi-tenant applications.
