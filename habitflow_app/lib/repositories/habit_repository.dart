import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/habit.dart';

class HabitRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'habits';

  Future<void> createExampleHabits(String userId) async {
    try {
      final exampleHabits = [
        Habit(
          id: '',
          name: 'Morning Run',
          category: 'Sports',
          frequency: 'Daily',
          color: 'Blue',
          isDone: false,
          createdBy: userId,
          createdAt: DateTime.now(),
        ),
        Habit(
          id: '',
          name: 'Meditation',
          category: 'Health',
          frequency: 'Daily',
          color: 'Purple',
          isDone: false,
          createdBy: userId,
          createdAt: DateTime.now(),
        ),
        Habit(
          id: '',
          name: 'Read for 30 minutes',
          category: 'Study',
          frequency: 'Daily',
          color: 'Green',
          isDone: true,
          createdBy: userId,
          createdAt: DateTime.now(),
        ),
        Habit(
          id: '',
          name: 'Drink 8 glasses of water',
          category: 'Health',
          frequency: 'Daily',
          color: 'Blue',
          isDone: false,
          createdBy: userId,
          createdAt: DateTime.now(),
        ),
      ];

      for (var habit in exampleHabits) {
        await createHabit(habit, userId);
      }
    } catch (e) {
      throw 'Failed to create example habits: $e';
    }
  }

  Future<void> createHabit(Habit habit, String userId) async {
    try {
      final habitData = habit.toFirestore();
      habitData['createdBy'] = userId;
      
      await _firestore.collection(_collection).add(habitData);
    } catch (e) {
      throw 'Failed to create habit: $e';
    }
  }

  Stream<List<Habit>> getHabits(String userId) {
    try {
      return _firestore
          .collection(_collection)
          .where('createdBy', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        final habits = snapshot.docs.map((doc) => Habit.fromFirestore(doc)).toList();
        habits.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return habits;
      });
    } catch (e) {
      throw 'Failed to fetch habits: $e';
    }
  }

  Future<void> updateHabit(String habitId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(_collection).doc(habitId).update(updates);
    } catch (e) {
      throw 'Failed to update habit: $e';
    }
  }

  Future<void> deleteHabit(String habitId) async {
    try {
      await _firestore.collection(_collection).doc(habitId).delete();
    } catch (e) {
      throw 'Failed to delete habit: $e';
    }
  }
}
