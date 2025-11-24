import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});


  Widget badgeRow(String name, String emoji, bool unlocked) {
    final statusText = unlocked ? 'Unlocked' : 'Locked';
    final statusColor = unlocked ? Colors.green : Colors.grey;

    return ListTile(
      leading: Text(
        emoji,
        style: const TextStyle(fontSize: 26),
      ),
      title: Text(name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            unlocked ? Icons.check_circle : Icons.lock,
            color: statusColor,
            size: 24,
          ),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w600,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.emoji_events, size: 20, color: Colors.deepPurple),
            SizedBox(width: 6),
            Text("Achievements"),
          ],
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Consistency Badges:",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),


          badgeRow("7 day streak", "🔥", true),
          badgeRow("30 day streak", "🌞", false),
          badgeRow("100 day streak", "💪", false),

          const Divider(height: 30),

          const Text(
            "Health Badges:",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Health badges
          badgeRow("Hydration Hero", "💧", true),
          badgeRow("Fitness Freak", "🏋", false),
          badgeRow("Sleep Guardian", "😴", true),

          const Divider(height: 30),

          const Text(
            "Study Badges:",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),


          badgeRow("Study Sage", "📘", true),
          badgeRow("Focus Master", "🎯", false),
          badgeRow("Consistent Learner", "📚", false),

          const SizedBox(height: 24),


          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              legendDot(Colors.green),
              const SizedBox(width: 6),
              const Text("Health   "),
              legendDot(Colors.blue),
              const SizedBox(width: 6),
              const Text("Study   "),
              legendDot(Colors.purple),
              const SizedBox(width: 6),
              const Text("Consistency"),
            ],
          ),
        ],
      ),
    );
  }
}
