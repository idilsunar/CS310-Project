import 'package:flutter/material.dart';

class ProgressPageScreen extends StatelessWidget {
  const ProgressPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button + title
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Progress Screen",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // keeps center aligned
                ],
              ),

              const SizedBox(height: 20),

              // ---- HABIT PROGRESS LIST ----
              Expanded(
                child: ListView(
                  children: const [
                    HabitProgressTile(
                      emoji: "🏃‍♂️",
                      title: "Running",
                      percent: 0.2,
                      color1: Color(0xFF4DB6AC),
                      color2: Color(0xFF00796B),
                    ),
                    HabitProgressTile(
                      emoji: "🧘‍♂️",
                      title: "Meditation",
                      percent: 0.4,
                      color1: Color(0xFF4FC3F7),
                      color2: Color(0xFF0288D1),
                    ),
                    HabitProgressTile(
                      emoji: "😴",
                      title: "Sleeping habits",
                      percent: 0.6,
                      color1: Color(0xFF7E57C2),
                      color2: Color(0xFF4A148C),
                    ),
                    HabitProgressTile(
                      emoji: "🥋",
                      title: "Martial arts",
                      percent: 0.8,
                      color1: Color(0xFFE57373),
                      color2: Color(0xFFC62828),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ---- EDIT BUTTON ----
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Color(0xFF5C2EF9)),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Edit habit",
                      style: TextStyle(
                        color: Color(0xFF5C2EF9),
                        fontSize: 18,
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
}

/// ------------------------------
///      REUSABLE PROGRESS TILE
/// ------------------------------
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Proper progress bar
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Stack(
                children: [
                  // Background white bar
                  Container(
                    height: 40,
                    color: Colors.white,
                  ),

                  // Gradient progress only for completed part
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

                  // Percentage text centered
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
                                ..color = Colors.black,
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