import 'package:flutter/material.dart';
import 'calendar_screen.dart';
import 'achievements_screen.dart';
import 'simple_form_screen.dart';
import 'app_colors.dart';

void main() {
  runApp(const HabitFlowApp());
}

class HabitFlowApp extends StatelessWidget {
  const HabitFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitFlow',
      debugShowCheckedModeBanner: false,


      theme: ThemeData(
         colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),


      initialRoute: '/calendar',


      routes: {
        '/calendar': (context) => CalendarScreen(),
        '/achievements': (context) => const AchievementsScreen(),
        '/simpleForm': (context) => const SimpleFormScreen(),
      },
    );
  }
}


