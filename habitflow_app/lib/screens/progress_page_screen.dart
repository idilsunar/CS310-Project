import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ProgressPageScreen extends StatelessWidget {
  const ProgressPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Progress Screen'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: const [
                    HabitProgressTile(
                      emoji: "🏃‍♂️",
                      title: "Running",
                      percent: 0.2,
                      color1: AppColors.lightTurquoise,
                      color2: AppColors.turquoise,
                    ),
                    HabitProgressTile(
                      emoji: "🧘‍♂️",
                      title: "Meditation",
                      percent: 0.4,
                      color1: AppColors.turquoise,
                      color2: AppColors.navyBlue,
                    ),
                    HabitProgressTile(
                      emoji: "😴",
                      title: "Sleeping habits",
                      percent: 0.6,
                      color1: AppColors.lightPeach,
                      color2: AppColors.peach,
                    ),
                    HabitProgressTile(
                      emoji: "🥋",
                      title: "Martial arts",
                      percent: 0.8,
                      color1: AppColors.peach,
                      color2: AppColors.navyBlue,
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
                      side: BorderSide(color: AppColors.navyBlue, width: 2),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                      child: Text(
                      "Back",
                      style: TextStyle(
                        color: AppColors.navyBlue,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Stack(
                children: [
                  Container(
                    height: 40,
                    color: Colors.white,
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
