import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../providers/achievements_provider.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  Widget badgeRow(
    BuildContext context,
    String name,
    String emoji,
    String description,
    bool unlocked,
    int current,
    int target,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final statusText = unlocked ? 'Unlocked' : 'Locked';
    final statusColor = unlocked ? Colors.green : theme.colorScheme.onSurface.withOpacity(0.4);
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: unlocked
              ? Colors.green.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: unlocked
                    ? Colors.green.withValues(alpha: 0.1)
                    : theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: TextStyle(
                    fontSize: 26,
                    color: unlocked ? null : theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            title: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  unlocked ? Icons.check_circle : Icons.lock,
                  color: statusColor,
                  size: 22,
                ),
                const SizedBox(width: 6),
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress: $current / $target',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      unlocked ? Colors.green : AppColors.turquoise,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget legendDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Widget _buildBadgeCategory(
    BuildContext context,
    String title,
    Color color,
    List<Widget> badges,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
        color: isDark ? theme.colorScheme.surface.withOpacity(0.3) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: badges,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final achievementsProvider = Provider.of<AchievementsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Badges', style: TextStyle(color: theme.colorScheme.onSurface)),
        centerTitle: true,
      ),
      body: achievementsProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildBadgeCategory(
                  context,
                  'Consistency Badges',
                  AppColors.peach,
                  [
                    badgeRow(
                      context,
                      "7 Day Streak",
                      "🔥",
                      "Complete habits for 7 consecutive days",
                      achievementsProvider.has7DayStreak,
                      achievementsProvider.longestStreak.clamp(0, 7),
                      7,
                    ),
                    badgeRow(
                      context,
                      "30 Day Streak",
                      "🌞",
                      "Complete habits for 30 consecutive days",
                      achievementsProvider.has30DayStreak,
                      achievementsProvider.longestStreak.clamp(0, 30),
                      30,
                    ),
                    badgeRow(
                      context,
                      "100 Day Streak",
                      "💪",
                      "Complete habits for 100 consecutive days",
                      achievementsProvider.has100DayStreak,
                      achievementsProvider.longestStreak.clamp(0, 100),
                      100,
                    ),
                  ],
                ),
                _buildBadgeCategory(
                  context,
                  'Completion Milestones',
                  Colors.green,
                  [
                    badgeRow(
                      context,
                      "First Steps",
                      "🌱",
                      "Complete 10 habits in total",
                      achievementsProvider.hasFirstSteps,
                      achievementsProvider.totalCompletions.clamp(0, 10),
                      10,
                    ),
                    badgeRow(
                      context,
                      "Getting Started",
                      "🚀",
                      "Complete 25 habits in total",
                      achievementsProvider.hasGettingStarted,
                      achievementsProvider.totalCompletions.clamp(0, 25),
                      25,
                    ),
                    badgeRow(
                      context,
                      "Habit Master",
                      "🏆",
                      "Complete 50 habits in total",
                      achievementsProvider.hasHabitMaster,
                      achievementsProvider.totalCompletions.clamp(0, 50),
                      50,
                    ),
                  ],
                ),
                _buildBadgeCategory(
                  context,
                  'Champion Badges',
                  AppColors.turquoise,
                  [
                    badgeRow(
                      context,
                      "Century Club",
                      "💯",
                      "Complete 100 habits in total",
                      achievementsProvider.hasCenturyClub,
                      achievementsProvider.totalCompletions.clamp(0, 100),
                      100,
                    ),
                    badgeRow(
                      context,
                      "Dedication Legend",
                      "👑",
                      "Complete 250 habits in total",
                      achievementsProvider.hasDedicationLegend,
                      achievementsProvider.totalCompletions.clamp(0, 250),
                      250,
                    ),
                    badgeRow(
                      context,
                      "Ultimate Champion",
                      "🎯",
                      "Complete 500 habits in total",
                      achievementsProvider.hasUltimateChampion,
                      achievementsProvider.totalCompletions.clamp(0, 500),
                      500,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? theme.colorScheme.surface.withOpacity(0.5)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      legendDot(Colors.green),
                      const SizedBox(width: 6),
                      Text(
                        "Milestones   ",
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      legendDot(AppColors.turquoise),
                      const SizedBox(width: 6),
                      Text(
                        "Champions   ",
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      legendDot(AppColors.peach),
                      const SizedBox(width: 6),
                      Text(
                        "Consistency",
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
    );
  }
}

