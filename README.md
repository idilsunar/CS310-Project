# HabitFlow - Habit Builder App

## Project Overview

HabitFlow is a simple, habit tracking app that helps you build and maintain daily habits. Whether it's studying, exercising, or drinking enough water, HabitFlow makes it easy to track your progress and build streaks.

We built this app because most habit trackers are way too complicated. We wanted something clean and fast that actually helps students and young professionals stay consistent without all the extra fluff.

## Team Members

| Name                   | Student ID |
|------------------------|------------|
| Kerem Özdemir          | 30807      |
| Azuolas Saulius Balbieris | 37825  |
| İbrahim Sualp Aytuğ    | 32604      |
| İdil Sunar             | 34363      |
| Ömer Faruk Kocatmaz    | 32458      |

**Course:** CS 310  
**Screen Designs:** https://miro.com/app/board/uXjVJus1KfA=/

---

## Setup Instructions

### Prerequisites

Before you start, make sure you have these installed:
- Flutter SDK (version 3.0.0 or higher)
- Dart (comes with Flutter)
- Android Studio or Xcode (depending on your target platform)
- A code editor (VS Code or Android Studio recommended)

To check if Flutter is installed correctly:
```bash
flutter doctor
```

### Step 1: Clone the Repository

```bash
git clone <your-repo-url>
cd CS310-Project/habitflow_app
```

### Step 2: Install Dependencies

Run this command to download all the packages we're using:
```bash
flutter pub get
```

### Step 3: Firebase Configuration

The app uses Firebase for user authentication and data storage. We've already included the config files, but if you need to set up your own Firebase project:

#### For Android:
1. Download `google-services.json` from your Firebase console
2. Place it in `android/app/`

#### For iOS:
1. Download `GoogleService-Info.plist` from your Firebase console
2. Place it in `ios/Runner/`

#### For Web:
Web support is now configured via `lib/firebase_options.dart`

#### Firestore Security Rules

**IMPORTANT:** Deploy the security rules to protect your data:

1. Install Firebase CLI if not already installed:
```bash
npm install -g firebase-tools
```

2. Login to Firebase:
```bash
firebase login
```

3. Initialize Firebase in the project (if not already done):
```bash
cd habitflow_app
firebase init firestore
```
Select your Firebase project and use the existing `firestore.rules` file.

4. Deploy the security rules:
```bash
firebase deploy --only firestore:rules
```

The rules ensure:
- Users must be authenticated to access data
- Users can only read/write their own habits and completions
- Data structure is validated on writes

### Step 4: Run the App

For Android:
```bash
flutter run
```

For iOS (macOS only):
```bash
flutter run -d ios
```

For a specific device:
```bash
flutter devices
flutter run -d <device-id>
```

---

## Project Structure

```
habitflow_app/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/                      # Data models (Habit, HabitCompletion, Reminder)
│   ├── providers/                   # State management with Provider
│   ├── repositories/                # Data layer for Firebase
│   ├── screens/                     # UI screens
│   ├── services/                    # Background services (notifications)
│   └── utils/                       # Helper functions
├── test/                            # Unit and widget tests
├── assets/                          # Images and fonts
└── pubspec.yaml                     # Dependencies
```

---

## Known Limitations

- **iOS Notifications:** Local notifications might not work perfectly on all iOS versions due to permission handling
- **Offline Mode:** The app requires an internet connection for Firebase sync. We plan to add offline support in the future
- **Date Timezone:** Streak calculations might be off if you travel across time zones
- **No Data Export:** Currently, there's no way to export your habit data (planned for future updates)

---

## Testing

The project includes comprehensive unit and widget tests to ensure code quality and functionality.

### Running Tests

To run all tests:
```bash
cd habitflow_app
flutter test
```

### Test Coverage

Our test suite includes:

**Unit Tests (10 tests):**
- Habit model tests - checking constructors, copyWith, and Firestore serialization
- HabitCompletion model tests - testing completion statuses and data conversions
**Widget Tests (2 tests):**
- Basic UI rendering tests
- Habit display and interaction tests

---

## AI Usage Disclosure
All core decisions about the app's functionality and structure were made by our team. AI was used as a coding assistant to speed up implementation and code/text formatting. 

