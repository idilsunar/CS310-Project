import 'package:flutter_test/flutter_test.dart';
import 'package:habit_flow/models/habit_completion.dart';

void main() {
  group('HabitCompletion Model Tests', () {
    test('HabitCompletion constructor creates object with correct properties', () {
      final now = DateTime.now();
      final completion = HabitCompletion(
        id: '1',
        habitId: 'habit123',
        userId: 'user123',
        date: now,
        status: CompletionStatus.completed,
        createdAt: now,
      );

      expect(completion.id, '1');
      expect(completion.habitId, 'habit123');
      expect(completion.userId, 'user123');
      expect(completion.date, now);
      expect(completion.status, CompletionStatus.completed);
      expect(completion.createdAt, now);
    });

    test('copyWith creates a new HabitCompletion with updated status', () {
      final now = DateTime.now();
      final original = HabitCompletion(
        id: '1',
        habitId: 'habit123',
        userId: 'user123',
        date: now,
        status: CompletionStatus.missed,
        createdAt: now,
      );

      final updated = original.copyWith(status: CompletionStatus.completed);

      expect(updated.id, original.id);
      expect(updated.habitId, original.habitId);
      expect(updated.status, CompletionStatus.completed);
    });

    test('toFirestore converts HabitCompletion to correct Map format', () {
      final now = DateTime.now();
      final completion = HabitCompletion(
        id: '1',
        habitId: 'habit123',
        userId: 'user123',
        date: now,
        status: CompletionStatus.completed,
        createdAt: now,
      );

      final firestoreData = completion.toFirestore();

      expect(firestoreData['habitId'], 'habit123');
      expect(firestoreData['userId'], 'user123');
      expect(firestoreData['status'], 'completed');
      expect(firestoreData.containsKey('date'), true);
      expect(firestoreData.containsKey('createdAt'), true);
    });
  });

  group('CompletionStatus Enum Tests', () {
    test('CompletionStatus has correct values', () {
      expect(CompletionStatus.completed.value, 'completed');
      expect(CompletionStatus.partial.value, 'partial');
      expect(CompletionStatus.missed.value, 'missed');
    });

    test('fromString converts string to correct CompletionStatus', () {
      expect(CompletionStatus.fromString('completed'), CompletionStatus.completed);
      expect(CompletionStatus.fromString('partial'), CompletionStatus.partial);
      expect(CompletionStatus.fromString('missed'), CompletionStatus.missed);
    });

    test('fromString returns missed for invalid value', () {
      expect(CompletionStatus.fromString('invalid'), CompletionStatus.missed);
      expect(CompletionStatus.fromString(''), CompletionStatus.missed);
    });
  });
}

