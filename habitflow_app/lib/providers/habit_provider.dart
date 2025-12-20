import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/habit.dart';
import '../repositories/habit_repository.dart';

class HabitProvider extends ChangeNotifier {
  final HabitRepository _habitRepository = HabitRepository();
  
  List<Habit> _habits = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<Habit>>? _habitSubscription;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void loadHabits(String userId) {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _habitSubscription?.cancel();
    
    _habitSubscription = _habitRepository.getHabits(userId).listen(
      (habits) {
        _habits = habits;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> addHabit(Habit habit, String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _habitRepository.createHabit(habit, userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateHabit(String id, Map<String, dynamic> updates) async {
    try {
      await _habitRepository.updateHabit(id, updates);
      _error = null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteHabit(String id) async {
    try {
      await _habitRepository.deleteHabit(id);
      _error = null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleHabitDone(String id) async {
    final habitIndex = _habits.indexWhere((h) => h.id == id);
    if (habitIndex != -1) {
      final habit = _habits[habitIndex];
      await updateHabit(id, {'isDone': !habit.isDone});
    }
  }

  Future<void> createExampleHabits(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _habitRepository.createExampleHabits(userId);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _habitSubscription?.cancel();
    super.dispose();
  }
}
