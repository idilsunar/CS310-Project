import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/habit_completion.dart';

class HabitCompletionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'habitCompletions';

  /// Get completions for a specific month and user
  Stream<List<HabitCompletion>> getCompletionsForMonth(String userId, DateTime month) {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => HabitCompletion.fromFirestore(doc)).toList());
  }

  /// Get completions for a specific day
  Stream<List<HabitCompletion>> getCompletionsForDay(String userId, DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => HabitCompletion.fromFirestore(doc)).toList());
  }

  /// Mark a habit as completed for a specific day
  Future<void> markHabitCompletion(
      String userId,
      String habitId,
      DateTime date,
      CompletionStatus status,
      ) async {
    final dateOnly = DateTime(date.year, date.month, date.day);

    // Check if completion already exists for this habit and date
    final existingQuery = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('habitId', isEqualTo: habitId)
        .where('date', isEqualTo: Timestamp.fromDate(dateOnly))
        .limit(1)
        .get();

    if (existingQuery.docs.isNotEmpty) {
      // Update existing completion
      await _firestore
          .collection(_collection)
          .doc(existingQuery.docs.first.id)
          .update({'status': status.value});
    } else {
      // Create new completion
      final completion = HabitCompletion(
        id: '',
        habitId: habitId,
        userId: userId,
        date: dateOnly,
        status: status,
        createdAt: DateTime.now(),
      );
      await _firestore.collection(_collection).add(completion.toFirestore());
    }
  }

  /// Delete a habit completion
  Future<void> deleteCompletion(String completionId) async {
    await _firestore.collection(_collection).doc(completionId).delete();
  }

  /// Get completion statistics for a month
  Future<Map<String, dynamic>> getMonthStatistics(String userId, DateTime month) async {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    final snapshot = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
        .get();

    final completions = snapshot.docs
        .map((doc) => HabitCompletion.fromFirestore(doc))
        .toList();

    int completed = 0;
    int partial = 0;
    int missed = 0;

    for (var completion in completions) {
      switch (completion.status) {
        case CompletionStatus.completed:
          completed++;
          break;
        case CompletionStatus.partial:
          partial++;
          break;
        case CompletionStatus.missed:
          missed++;
          break;
      }
    }

    return {
      'completed': completed,
      'partial': partial,
      'missed': missed,
      'total': completions.length,
    };
  }
}