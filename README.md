# CS310-Project, HabitFlow - Habit Builder App

## Project Description

**HabitFlow** is a minimalistic and efficient mobile application developed to help users build and maintain daily habits such as studying, exercising, or drinking water. It allows users to easily track their progress with checkmarks and streak indicators, encouraging consistency and daily discipline without unnecessary distractions.

The app is designed with simplicity and speed in mind—ideal for university students and young professionals who want a clean habit tracker without the complexity of gamification or cluttered dashboards.

---

## Team Members

| Name                   | Student ID |
|------------------------|------------|
| Kerem Özdemir          | 30807      |
| Azuolas Saulius Balbieris | 37825  |
| İbrahim Sualp Aytuğ    | 32604      |
| İdil Sunar             | 34363      |
| Ömer Faruk Kocatmaz    | 32458      |

---

## Course Information

**Course:** CS 310  
**Project:** HabitFlow -  Project Proposal  
**Platform:** Flutter (mobile)  
**Local Storage:** Hive / SharedPreferences  

**Screen Designs:** https://miro.com/app/board/uXjVJus1KfA=/

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

#### Unit Tests (10 tests)
**Habit Model Tests** (`test/models/habit_test.dart`)
- Tests Habit constructor with all properties
- Tests copyWith method for creating modified copies
- Tests toFirestore method for data serialization
- Tests copyWith without parameters returns identical habit

**HabitCompletion Model Tests** (`test/models/habit_completion_test.dart`)
- Tests HabitCompletion constructor with all properties
- Tests copyWith method for updating completion status
- Tests toFirestore method for data serialization
- Tests CompletionStatus enum values (completed, partial, missed)
- Tests CompletionStatus fromString conversion
- Tests CompletionStatus fromString fallback behavior for invalid values

#### Widget Tests (2 tests)
**Widget Tests** (`test/widget_test.dart`)
- Tests MaterialApp renders with AppBar and body text
- Tests Habit information displays correctly in Card widget with Checkbox
