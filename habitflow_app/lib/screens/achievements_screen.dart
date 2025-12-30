import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/achievements_provider.dart';
import '../utils/app_colors.dart';
import 'badges_screen.dart';
import 'progress_page_screen.dart';

class AchievementsScreen extends StatefulWidget {
  final bool showAppBar;

  const AchievementsScreen({super.key, this.showAppBar = true});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAchievements();
    });
  }

  Future<void> _loadAchievements() async {
    final authProvider = context.read<AuthProvider>();
    final achievementsProvider = context.read<AchievementsProvider>();

    if (authProvider.currentUser != null) {
      await achievementsProvider.calculateAchievements(
        authProvider.currentUser!.uid,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final achievementsProvider = Provider.of<AchievementsProvider>(context);

    final content = achievementsProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: isDark
                  ? theme.colorScheme.surface
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: isDark
                  ? Border.all(color: theme.colorScheme.outline.withOpacity(0.2))
                  : null,
              boxShadow: isDark ? null : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.emoji_events,
                  size: 80,
                  color: AppColors.peach,
                ),
                const SizedBox(height: 24),
                Text(
                  'Achievements',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Track your progress and unlock badges',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BadgesScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.emoji_events_outlined, size: 24),
                    label: const Text(
                      'See badges',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? theme.colorScheme.primaryContainer
                          : AppColors.navyBlue,
                      foregroundColor: isDark
                          ? theme.colorScheme.onPrimaryContainer
                          : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProgressPageScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.trending_up, size: 24),
                    label: const Text(
                      'Progress',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.turquoise,
                      side: BorderSide(color: AppColors.turquoise, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark
                  ? theme.colorScheme.surface.withOpacity(0.5)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: isDark
                  ? Border.all(color: theme.colorScheme.outline.withOpacity(0.2))
                  : null,
            ),
            child: Column(
              children: [
                Text(
                  'User Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSummaryRow(
                  theme,
                  'Longest Streak:',
                  '${achievementsProvider.longestStreak} days',
                ),
                Divider(
                  height: 24,
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
                _buildSummaryRow(
                  theme,
                  'Habits Completed:',
                  '${achievementsProvider.totalCompletions}',
                ),
                Divider(
                  height: 24,
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
                _buildSummaryRow(
                  theme,
                  'Badges Earned:',
                  '${achievementsProvider.unlockedBadges} / 9',
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (widget.showAppBar) {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.emoji_events, size: 20, color: AppColors.peach),
              const SizedBox(width: 6),
              Text("Achievements", style: TextStyle(color: theme.colorScheme.onSurface)),
            ],
          ),
          centerTitle: true,
        ),
        body: content,
      );
    }

    return content;
  }

  Widget _buildSummaryRow(ThemeData theme, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}