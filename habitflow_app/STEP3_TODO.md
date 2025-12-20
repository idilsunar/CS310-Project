# HabitFlow - Step 3 Implementation Plan 🚀

## Project Goal
Transform the UI prototype into a fully functional Firebase-backed app with real-time data sync and state management.

---

## ✅ PHASE 1: Firebase Core Setup & Packages

### 1.1 Add Dependencies to pubspec.yaml
- [x] ✅ Add `firebase_core: ^4.3.0` (FlutterFire foundation)
- [x] ✅ Add `firebase_auth: ^6.1.3` (Authentication service)
- [x] ✅ Add `cloud_firestore: ^6.1.1` (NoSQL database)
- [x] ✅ Add `provider: ^6.1.5` (State management)
- [x] ✅ Add `shared_preferences: ^2.5.4` (Local storage)
- [x] ✅ Run `flutter pub get`

### 1.2 Configure Android Build Files
- [x] ✅ Already added `google-services.json` to `android/app/`
- [x] ✅ Update `android/settings.gradle.kts` - add Google services plugin
- [x] ✅ Update `android/app/build.gradle.kts` - apply Google services plugin
- [x] ✅ Set `minSdkVersion` to 21

### 1.3 Configure iOS
- [x] ✅ Already added `GoogleService-Info.plist` to `ios/Runner/`
- [ ] Verify file is properly linked in Xcode

### 1.4 Initialize Firebase in main.dart
- [x] ✅ Add `WidgetsFlutterBinding.ensureInitialized()`
- [x] ✅ Add `await Firebase.initializeApp()`
- [x] ✅ Wrap with try-catch for error handling
- [x] ✅ Test app starts without errors

**Checkpoint:** ✅ App builds and analyzes successfully without Firebase errors!

---

## 📦 PHASE 2: Update Data Models (Firestore-Ready)

### 2.1 Update Habit Model
- [ ] Add `String id` field (unique Firestore document ID)
- [ ] Add `String createdBy` field (user ID from Firebase Auth)
- [ ] Add `DateTime createdAt` field (timestamp)
- [ ] Create `fromFirestore()` factory constructor (convert Firestore doc → Habit)
- [ ] Create `toFirestore()` method (convert Habit → Map for Firestore)
- [ ] Create `copyWith()` method (for updates)

**Example Structure:**
```dart
Habit {
  id: "abc123",
  name: "Morning Run",
  category: "Sports",
  frequency: "Daily",
  color: "Blue",
  isDone: false,
  createdBy: "user123", // Links to Firebase Auth user
  createdAt: DateTime.now()
}
```

---

## 🗄️ PHASE 3: Repository Layer (No Direct Firestore in UI!)

### 3.1 Create AuthRepository (`lib/repositories/auth_repository.dart`)
- [ ] `signUpWithEmail(email, password)` → returns User or error
- [ ] `loginWithEmail(email, password)` → returns User or error
- [ ] `logout()` → signs out current user
- [ ] `getCurrentUser()` → returns current user or null
- [ ] `authStateChanges()` → Stream of user login/logout events
- [ ] Add proper error handling with try-catch

### 3.2 Create HabitRepository (`lib/repositories/habit_repository.dart`)
- [ ] `createHabit(Habit habit, String userId)` → saves to Firestore
- [ ] `getHabits(String userId)` → Stream of user's habits (real-time!)
- [ ] `updateHabit(String habitId, Map updates)` → updates fields
- [ ] `deleteHabit(String habitId)` → removes from Firestore
- [ ] Filter habits by `createdBy == userId` (security!)

**Firestore Structure:**
```
habits (collection)
  ├─ habitDoc1 (document)
  │   ├─ id: "habitDoc1"
  │   ├─ name: "Morning Run"
  │   ├─ createdBy: "user123"
  │   └─ createdAt: timestamp
  └─ habitDoc2 (document)
```

---

## 🔄 PHASE 4: State Management with Provider

### 4.1 Create AuthProvider (`lib/providers/auth_provider.dart`)
- [ ] Extend `ChangeNotifier`
- [ ] Fields: `User? _currentUser`, `bool _isLoading`, `String? _error`
- [ ] Methods:
  - [ ] `signUp(email, password)` → calls AuthRepository
  - [ ] `login(email, password)` → calls AuthRepository
  - [ ] `logout()` → calls AuthRepository
  - [ ] `listenToAuthState()` → listens to auth stream
- [ ] `notifyListeners()` after state changes
- [ ] Getters: `isLoggedIn`, `currentUser`, `isLoading`, `error`

### 4.2 Create HabitProvider (`lib/providers/habit_provider.dart`)
- [ ] Extend `ChangeNotifier`
- [ ] Fields: `List<Habit> _habits`, `bool _isLoading`, `String? _error`
- [ ] Methods:
  - [ ] `loadHabits(String userId)` → listens to Firestore stream
  - [ ] `addHabit(Habit habit)` → calls HabitRepository
  - [ ] `updateHabit(String id, Map updates)` → calls repository
  - [ ] `deleteHabit(String id)` → calls repository
  - [ ] `toggleHabitDone(String id)` → updates `isDone` field
- [ ] Real-time updates via `StreamBuilder`

### 4.3 Create PreferencesProvider (`lib/providers/preferences_provider.dart`)
- [ ] Extend `ChangeNotifier`
- [ ] Use `SharedPreferences` to save/load:
  - [ ] `bool isDarkMode` (theme preference)
  - [ ] `bool hasCompletedOnboarding` (onboarding status)
  - [ ] `int lastSelectedTab` (home navigation tab)
- [ ] Methods: `saveTheme()`, `loadTheme()`, `saveTab()`, `loadTab()`

---

## 🎨 PHASE 5: Update UI to Use Providers

### 5.1 Setup MultiProvider in main.dart
- [ ] Wrap `MaterialApp` with `MultiProvider`
- [ ] Add `ChangeNotifierProvider<AuthProvider>`
- [ ] Add `ChangeNotifierProvider<HabitProvider>`
- [ ] Add `ChangeNotifierProvider<PreferencesProvider>`

### 5.2 Create Auth Wrapper (`lib/screens/auth_wrapper.dart`)
- [ ] Use `Consumer<AuthProvider>`
- [ ] If `isLoggedIn == true` → show `HomeScreen`
- [ ] If `isLoggedIn == false` → show `OnboardingScreen` or `LoginScreen`
- [ ] Check `hasCompletedOnboarding` preference

### 5.3 Update Login Screen
- [ ] Add email/password `TextEditingController`s
- [ ] Use `context.read<AuthProvider>().login(email, password)`
- [ ] Show `CircularProgressIndicator` when `isLoading`
- [ ] Display error message with `SnackBar` if login fails
- [ ] Navigate to `HomeScreen` on success

### 5.4 Update Signup Screen
- [ ] Add name, email, password controllers
- [ ] Use `context.read<AuthProvider>().signUp(email, password)`
- [ ] Show loading state
- [ ] Display error messages
- [ ] Navigate to `HomeScreen` on success

### 5.5 Update Home Screen
- [ ] Remove local `List<Habit> habits` (use Provider instead!)
- [ ] Use `Consumer<HabitProvider>` to listen to habits
- [ ] Use `StreamBuilder` for real-time Firestore updates
- [ ] Show loading indicator when fetching data
- [ ] Display error if Firestore fails
- [ ] Update add/delete/toggle habit to use `HabitProvider` methods
- [ ] Add logout button → calls `context.read<AuthProvider>().logout()`

### 5.6 Update Settings Screen
- [ ] Use `Consumer<PreferencesProvider>`
- [ ] Add theme toggle switch (Dark/Light mode)
- [ ] Save theme preference to `SharedPreferences`
- [ ] Display current user email
- [ ] Add logout button

**UI Flow After Implementation:**
```
App Start
  ↓
AuthWrapper checks login state
  ↓
├─ Not Logged In → Show Onboarding/Login Screen
└─ Logged In → Show Home Screen with user's habits
```

---

## 🔒 PHASE 6: Firestore Security Rules

### 6.1 Add Security Rules in Firebase Console
- [ ] Go to Firebase Console → Firestore Database → Rules
- [ ] Add rules to ensure users can only access their own data:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /habits/{habitId} {
      allow read, write: if request.auth != null && 
                         resource.data.createdBy == request.auth.uid;
    }
  }
}
```
- [ ] Test rules with Firebase Emulator or console
- [ ] Publish rules

---

## 🎯 PHASE 7: Testing & Polish

### 7.1 Manual Testing Checklist
- [ ] Sign up new user → creates Firebase Auth account
- [ ] Login with existing user → navigates to home
- [ ] Add habit → appears in Firestore & UI updates
- [ ] Update habit (toggle done) → Firestore updates
- [ ] Delete habit → removes from Firestore & UI
- [ ] Open app in 2 devices → real-time sync works
- [ ] Logout → returns to login screen
- [ ] Change theme → persists after app restart
- [ ] Test error scenarios (wrong password, no internet)

### 7.2 Verify Rubric Requirements
- [ ] ✅ Firebase correctly set up and connects (2 pts)
- [ ] ✅ Sign up, login, logout working (3 pts)
- [ ] ✅ Firestore collections organized (2 pts)
- [ ] ✅ Model classes match Firestore docs (2 pts)
- [ ] ✅ Repository layer isolates Firestore calls (2 pts)
- [ ] ✅ Provider + MultiProvider setup (2 pts)
- [ ] ✅ Auth state managed with provider (2 pts)
- [ ] ✅ StreamBuilder/FutureBuilder used (2 pts)
- [ ] ✅ UI updates in real-time (2 pts)
- [ ] ✅ Navigation based on auth state (2 pts)
- [ ] ✅ SharedPreferences saves preference (2 pts)
- [ ] ✅ Firestore Security Rules deployed (2 pts)

**Total: 25 Points**

---

## 📹 PHASE 8: Demo Video Preparation

### 8.1 Record Demo (Max 5 Minutes)
- [ ] Show improvements from Step 2 (Firebase vs local data)
- [ ] Demo: Sign up new user
- [ ] Demo: Login with existing user
- [ ] Demo: Create habit → show it appears in Firestore console
- [ ] Demo: Update habit (mark done)
- [ ] Demo: Delete habit
- [ ] Demo: Real-time sync (open 2 devices/emulators)
- [ ] Demo: Logout
- [ ] Show theme preference persisting

---

## 🚨 Common Issues & Solutions

### Issue: Firebase initialization error
- **Solution:** Check `google-services.json` and `GoogleService-Info.plist` are in correct folders

### Issue: Build fails after adding Firebase
- **Solution:** Update `minSdkVersion` to 21+ and apply Google services plugin

### Issue: "User not authenticated" error
- **Solution:** Enable Email/Password auth in Firebase Console

### Issue: StreamBuilder shows old data
- **Solution:** Ensure you're listening to Firestore stream, not just reading once

### Issue: UI doesn't update after Firestore change
- **Solution:** Call `notifyListeners()` in Provider after state change

---

## 📚 Key Concepts from Slides

✅ **FlutterFire:** Official Flutter plugins for Firebase
✅ **Streams:** Continuous data flow for real-time updates
✅ **StreamBuilder:** UI widget that rebuilds when stream emits new data
✅ **Provider:** Clean state management with `ChangeNotifier`
✅ **Repository Pattern:** Separates data logic from UI

---

## 🎓 Submission Checklist

- [ ] Code pushed to GitHub (include all files)
- [ ] App runs without errors
- [ ] All CRUD operations working
- [ ] Demo video recorded (max 5 min)
- [ ] Video uploaded and link included
- [ ] Submit via SUCourse before deadline

**Due:** December 21, 2025 – 23:59
**Late:** December 22, 2025 – 23:59 (10% penalty)

---

Good luck! 🎉 Let's build something awesome! 💪

