import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../providers/achievements_provider.dart';

class ProgressPageScreen extends StatelessWidget {
  const ProgressPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final achievementsProvider = Provider.of<AchievementsProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Progress', style: TextStyle(color: theme.colorScheme.onSurface)),
        centerTitle: true,
      ),
      body: achievementsProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark
                            ? theme.colorScheme.surface
                            : AppColors.lightTurquoise.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: isDark
                            ? Border.all(color: theme.colorScheme.outline.withOpacity(0.2))
                            : null,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatCard(
                                context,
                                '🔥',
                                'Current Streak',
                                '${achievementsProvider.currentStreak} days',
                              ),
                              _buildStatCard(
                                context,
                                '🏆',
                                'Longest Streak',
                                '${achievementsProvider.longestStreak} days',
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatCard(
                                context,
                                '✅',
                                'Total Completed',
                                '${achievementsProvider.totalCompletions}',
                              ),
                              _buildStatCard(
                                context,
                                '🏅',
                                'Badges Earned',
                                '${achievementsProvider.unlockedBadges} / 9',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Badge Progress',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: [
                          HabitProgressTile(
                            emoji: "🔥",
                            title: "7 Day Streak",
                            percent: (achievementsProvider.longestStreak / 7).clamp(0.0, 1.0),
                            color1: AppColors.lightPeach,
                            color2: AppColors.peach,
                          ),
                          HabitProgressTile(
                            emoji: "🌞",
                            title: "30 Day Streak",
                            percent: (achievementsProvider.longestStreak / 30).clamp(0.0, 1.0),
                            color1: AppColors.peach,
                            color2: AppColors.navyBlue,
                          ),
                          HabitProgressTile(
                            emoji: "💪",
                            title: "100 Day Streak",
                            percent: (achievementsProvider.longestStreak / 100).clamp(0.0, 1.0),
                            color1: AppColors.navyBlue,
                            color2: AppColors.turquoise,
                          ),
                          HabitProgressTile(
                            emoji: "🌱",
                            title: "First Steps (10 completions)",
                            percent: (achievementsProvider.totalCompletions / 10).clamp(0.0, 1.0),
                            color1: AppColors.lightTurquoise,
                            color2: AppColors.turquoise,
                          ),
                          HabitProgressTile(
                            emoji: "🚀",
                            title: "Getting Started (25 completions)",
                            percent: (achievementsProvider.totalCompletions / 25).clamp(0.0, 1.0),
                            color1: AppColors.turquoise,
                            color2: AppColors.navyBlue,
                          ),
                          HabitProgressTile(
                            emoji: "🏆",
                            title: "Habit Master (50 completions)",
                            percent: (achievementsProvider.totalCompletions / 50).clamp(0.0, 1.0),
                            color1: AppColors.lightPeach,
                            color2: AppColors.peach,
                          ),
                          HabitProgressTile(
                            emoji: "💯",
                            title: "Century Club (100 completions)",
                            percent: (achievementsProvider.totalCompletions / 100).clamp(0.0, 1.0),
                            color1: AppColors.peach,
                            color2: AppColors.navyBlue,
                          ),
                          HabitProgressTile(
                            emoji: "👑",
                            title: "Dedication Legend (250 completions)",
                            percent: (achievementsProvider.totalCompletions / 250).clamp(0.0, 1.0),
                            color1: AppColors.turquoise,
                            color2: AppColors.navyBlue,
                          ),
                          HabitProgressTile(
                            emoji: "🎯",
                            title: "Ultimate Champion (500 completions)",
                            percent: (achievementsProvider.totalCompletions / 500).clamp(0.0, 1.0),
                            color1: AppColors.navyBlue,
                            color2: AppColors.peach,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(
                              color: isDark
                                  ? theme.colorScheme.primary
                                  : AppColors.navyBlue,
                              width: 2,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Back",
                            style: TextStyle(
                              color: isDark
                                  ? theme.colorScheme.primary
                                  : AppColors.navyBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(BuildContext context, String emoji, String label, String value) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? theme.colorScheme.surfaceContainerHighest.withOpacity(0.3)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isDark
              ? Border.all(color: theme.colorScheme.outline.withOpacity(0.2))
              : null,
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HabitProgressTile extends StatelessWidget {
  final String emoji;
  final String title;
  final double percent;
  final Color color1;
  final Color color2;

  const HabitProgressTile({
    super.key,
    required this.emoji,
    required this.title,
    required this.percent,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isDark
                    ? theme.colorScheme.outline.withOpacity(0.3)
                    : theme.colorScheme.outline,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Stack(
                children: [
                  Container(
                    height: 40,
                    color: isDark
                        ? theme.colorScheme.surfaceContainerHighest.withOpacity(0.2)
                        : Colors.white,
                  ),
                  FractionallySizedBox(
                    widthFactor: percent,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color1, color2],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            "${(percent * 100).toInt()}%",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 3
                                ..color = isDark
                                    ? theme.colorScheme.surface
                                    : Colors.black,
                            ),
                          ),
                          Text(
                            "${(percent * 100).toInt()}%",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
