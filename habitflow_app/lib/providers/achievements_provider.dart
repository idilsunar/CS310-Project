import 'package:flutter/foundation.dart';
import '../repositories/habit_completion_repository.dart';
import '../models/habit_completion.dart';

class AchievementsProvider extends ChangeNotifier {
  final HabitCompletionRepository _completionRepo = HabitCompletionRepository();

  int _longestStreak = 0;
  int _currentStreak = 0;
  int _totalCompletions = 0;
  int _unlockedBadges = 0;
  bool _isLoading = false;

  int get longestStreak => _longestStreak;
  int get currentStreak => _currentStreak;
  int get totalCompletions => _totalCompletions;
  int get unlockedBadges => _unlockedBadges;
  bool get isLoading => _isLoading;

  // Badge unlock status - Streaks
  bool get has7DayStreak => _longestStreak >= 7;
  bool get has30DayStreak => _longestStreak >= 30;
  bool get has100DayStreak => _longestStreak >= 100;
  
  // Badge unlock status - Completion Milestones
  bool get hasFirstSteps => _totalCompletions >= 10;
  bool get hasGettingStarted => _totalCompletions >= 25;
  bool get hasHabitMaster => _totalCompletions >= 50;
  
  // Badge unlock status - Champion Badges
  bool get hasCenturyClub => _totalCompletions >= 100;
  bool get hasDedicationLegend => _totalCompletions >= 250;
  bool get hasUltimateChampion => _totalCompletions >= 500;

  Future<void> calculateAchievements(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Get ALL completions for the user
      // We need to query from user's signup date to now
      // Since we can't get everything in one query, let's get last 12 months
      final now = DateTime.now();
      final oneYearAgo = DateTime(now.year - 1, now.month, now.day);

      final allCompletions = <HabitCompletion>[];

      // Get completions month by month for last year
      for (int i = 0; i < 12; i++) {
        final monthDate = DateTime(now.year, now.month - i, 1);
        if (monthDate.isBefore(oneYearAgo)) break;

        try {
          final monthCompletions = await _completionRepo
              .getCompletionsForMonth(userId, monthDate)
              .first
              .timeout(const Duration(seconds: 5));
          allCompletions.addAll(monthCompletions);
        } catch (e) {
          debugPrint('Error fetching month $monthDate: $e');
        }
      }

      debugPrint('🎯 Total completions fetched: ${allCompletions.length}');

      // Calculate total completions
      _totalCompletions = allCompletions
          .where((c) => c.status == CompletionStatus.completed)
          .length;

      debugPrint('✅ Completed habits: $_totalCompletions');

      // Calculate streaks
      _calculateStreaks(allCompletions);

      // Calculate unlocked badges
      _calculateUnlockedBadges();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error calculating achievements: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  void _calculateStreaks(List<HabitCompletion> completions) {
    if (completions.isEmpty) {
      _longestStreak = 0;
      _currentStreak = 0;
      return;
    }

    // Group completions by date
    final Set<String> completedDates = {};
    for (var completion in completions) {
      if (completion.status == CompletionStatus.completed) {
        final dateKey = DateTime(
          completion.date.year,
          completion.date.month,
          completion.date.day,
        ).toIso8601String().split('T')[0];
        completedDates.add(dateKey);
      }
    }

    if (completedDates.isEmpty) {
      _longestStreak = 0;
      _currentStreak = 0;
      return;
    }

    // Convert to sorted list
    final sortedDates = completedDates.toList()..sort();

    // Calculate current streak (from today backwards)
    final today = DateTime.now();
    int currentStreak = 0;

    for (int i = 0; i <= 365; i++) {
      final checkDate = today.subtract(Duration(days: i));
      final dateKey = DateTime(checkDate.year, checkDate.month, checkDate.day)
          .toIso8601String()
          .split('T')[0];

      if (sortedDates.contains(dateKey)) {
        currentStreak++;
      } else if (i > 0) {
        // Streak broken
        break;
      }
    }

    _currentStreak = currentStreak;

    // Calculate longest streak
    int longestStreak = 0;
    int tempStreak = 1;

    for (int i = 1; i < sortedDates.length; i++) {
      final prevDate = DateTime.parse(sortedDates[i - 1]);
      final currDate = DateTime.parse(sortedDates[i]);

      if (currDate.difference(prevDate).inDays == 1) {
        tempStreak++;
      } else {
        if (tempStreak > longestStreak) {
          longestStreak = tempStreak;
        }
        tempStreak = 1;
      }
    }

    if (tempStreak > longestStreak) {
      longestStreak = tempStreak;
    }

    _longestStreak = longestStreak > currentStreak ? longestStreak : currentStreak;

    debugPrint('📊 Current Streak: $_currentStreak days');
    debugPrint('🏆 Longest Streak: $_longestStreak days');
  }

  void _calculateUnlockedBadges() {
    _unlockedBadges = 0;

    if (has7DayStreak) _unlockedBadges++;
    if (has30DayStreak) _unlockedBadges++;
    if (has100DayStreak) _unlockedBadges++;
    if (hasFirstSteps) _unlockedBadges++;
    if (hasGettingStarted) _unlockedBadges++;
    if (hasHabitMaster) _unlockedBadges++;
    if (hasCenturyClub) _unlockedBadges++;
    if (hasDedicationLegend) _unlockedBadges++;
    if (hasUltimateChampion) _unlockedBadges++;
  }

  // Get habit-specific completion count
  Future<int> getHabitCompletionCount(String userId, String habitId) async {
    try {
      final startDate = DateTime(2020, 1, 1);
      final completions = await _completionRepo
          .getCompletionsForMonth(userId, startDate)
          .first;

      return completions
          .where((c) =>
      c.habitId == habitId &&
          c.status == CompletionStatus.completed)
          .length;
    } catch (e) {
      debugPrint('Error getting habit completion count: $e');
      return 0;
    }
  }

  // Get completion percentage for a habit (out of 100 days)
  Future<int> getHabitCompletionPercentage(String userId, String habitId) async {
    final count = await getHabitCompletionCount(userId, habitId);
    return (count * 100 / 100).clamp(0, 100).toInt(); // Max 100%
  }
}