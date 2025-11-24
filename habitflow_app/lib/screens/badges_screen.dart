import 'package:flutter/material.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  Widget badgeRow(String name, String emoji, bool unlocked) {
    final statusText = unlocked ? 'Unlocked' : 'Locked';
    final statusColor = unlocked ? Colors.green : Colors.grey;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: unlocked ? Colors.green.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: unlocked ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 26),
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
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

  Widget _buildBadgeCategory(String title, Color color, List<Widget> badges) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Badges'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildBadgeCategory(
            'Consistency Badges',
            Colors.purple,
            [
              badgeRow("7 day streak", "🔥", true),
              badgeRow("30 day streak", "🌞", false),
              badgeRow("100 day streak", "💪", false),
            ],
          ),
          _buildBadgeCategory(
            'Health Badges',
            Colors.green,
            [
              badgeRow("Hydration Hero", "💧", true),
              badgeRow("Fitness Freak", "🏋", false),
              badgeRow("Sleep Guardian", "😴", true),
            ],
          ),
          _buildBadgeCategory(
            'Study Badges',
            Colors.blue,
            [
              badgeRow("Study Sage", "📘", true),
              badgeRow("Focus Master", "🎯", false),
              badgeRow("Consistent Learner", "📚", false),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              legendDot(Colors.green),
              const SizedBox(width: 6),
              const Text("Health   ", style: TextStyle(fontSize: 13)),
              legendDot(Colors.blue),
              const SizedBox(width: 6),
              const Text("Study   ", style: TextStyle(fontSize: 13)),
              legendDot(Colors.purple),
              const SizedBox(width: 6),
              const Text("Consistency", style: TextStyle(fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

