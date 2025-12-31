import 'package:flutter_test/flutter_test.dart';
import 'package:habit_flow/models/habit.dart';

void main() {
  group('Habit Model Tests', () {
    test('Habit constructor creates object with correct properties', () {
      final now = DateTime.now();
      final habit = Habit(
        id: '1',
        name: 'Exercise',
        isDone: false,
        category: 'Health',
        frequency: 'Daily',
        color: '#FF5733',
        createdBy: 'user123',
        createdAt: now,
        hasReminder: true,
        reminderTime: '08:00',
        reminderDays: [true, true, true, true, true, false, false],
      );

      expect(habit.id, '1');
      expect(habit.name, 'Exercise');
      expect(habit.isDone, false);
      expect(habit.category, 'Health');
      expect(habit.frequency, 'Daily');
      expect(habit.color, '#FF5733');
      expect(habit.createdBy, 'user123');
      expect(habit.createdAt, now);
      expect(habit.hasReminder, true);
      expect(habit.reminderTime, '08:00');
      expect(habit.reminderDays, [true, true, true, true, true, false, false]);
    });

    test('copyWith creates a new Habit with updated values', () {
      final original = Habit(
        id: '1',
        name: 'Read',
        isDone: false,
        createdBy: 'user123',
        createdAt: DateTime.now(),
      );

      final updated = original.copyWith(
        name: 'Read Books',
        isDone: true,
      );

      expect(updated.id, original.id);
      expect(updated.name, 'Read Books');
      expect(updated.isDone, true);
      expect(updated.createdBy, original.createdBy);
    });

    test('toFirestore converts Habit to correct Map format', () {
      final now = DateTime.now();
      final habit = Habit(
        id: '1',
        name: 'Meditate',
        isDone: true,
        category: 'Wellness',
        createdBy: 'user123',
        createdAt: now,
        hasReminder: false,
      );

      final firestoreData = habit.toFirestore();

      expect(firestoreData['name'], 'Meditate');
      expect(firestoreData['isDone'], true);
      expect(firestoreData['category'], 'Wellness');
      expect(firestoreData['createdBy'], 'user123');
      expect(firestoreData['hasReminder'], false);
      expect(firestoreData.containsKey('createdAt'), true);
    });

    test('copyWith without parameters returns identical habit', () {
      final original = Habit(
        id: '1',
        name: 'Study',
        isDone: false,
        createdBy: 'user123',
        createdAt: DateTime.now(),
      );

      final copied = original.copyWith();

      expect(copied.id, original.id);
      expect(copied.name, original.name);
      expect(copied.isDone, original.isDone);
      expect(copied.createdBy, original.createdBy);
    });
  });
}

