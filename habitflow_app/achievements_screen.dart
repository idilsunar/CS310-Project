import 'package:flutter/material.dart';

enum BadgeState { unlocked, locked }

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Achievements',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Your badges & streaks',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 16),


              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      spreadRadius: 1,
                      color: Colors.black.withOpacity(0.08),
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Consistency Badges',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    _StreakRow(
                      label: '7 day streak',
                      emoji: '🔥',
                      progressText: '7 / 7 done',
                    ),
                    SizedBox(height: 8),
                    _StreakRow(
                      label: '30 day streak',
                      emoji: '🌞',
                      progressText: '7 / 30 done',
                    ),
                    SizedBox(height: 8),
                    _StreakRow(
                      label: '100 day streak',
                      emoji: '💪',
                      progressText: '0 / 100 done',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),


              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Health Badges',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    _BadgeRow(
                      name: '💧 Hydration Hero',
                      state: BadgeState.unlocked,
                    ),
                    _BadgeRow(
                      name: '🏃‍♀️ Fitness Freak',
                      state: BadgeState.locked,
                    ),
                    _BadgeRow(
                      name: '😴 Sleep Guardian',
                      state: BadgeState.unlocked,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),


              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Study Badges',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    _BadgeRow(
                      name: '📚 Study Sage',
                      state: BadgeState.unlocked,
                    ),
                    _BadgeRow(
                      name: '🎯 Focus Master',
                      state: BadgeState.locked,
                    ),
                    _BadgeRow(
                      name: '🧠 Consistent Learner',
                      state: BadgeState.locked,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),


              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      spreadRadius: 1,
                      color: Colors.black.withOpacity(0.08),
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'User Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Longest streak: 7 days'),
                    const Text('Habits completed: 23'),
                    const Text('Badges earned: 4'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            child: const Text('See badges'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Progress'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _LegendDot(
                    color: Colors.green,
                    label: 'Health',
                  ),
                  SizedBox(width: 16),
                  _LegendDot(
                    color: Colors.blue,
                    label: 'Study',
                  ),
                  SizedBox(width: 16),
                  _LegendDot(
                    color: Colors.purple,
                    label: 'Consistency',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _StreakRow extends StatelessWidget {
  final String label;
  final String emoji;
  final String progressText;

  const _StreakRow({
    required this.label,
    required this.emoji,
    required this.progressText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Text(
          '$label: $emoji',
          style: const TextStyle(fontSize: 14),
        ),
        const Spacer(),

        const Text(
          '→ ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Text(
          progressText,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _BadgeRow extends StatelessWidget {
  final String name;
  final BadgeState state;

  const _BadgeRow({
    required this.name,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isUnlocked = state == BadgeState.unlocked;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isUnlocked ? Icons.check_box : Icons.lock_outline,
            size: 18,
            color: isUnlocked ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            isUnlocked ? 'Unlocked' : 'Locked',
            style: TextStyle(
              fontSize: 13,
              color: isUnlocked ? Colors.green : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
