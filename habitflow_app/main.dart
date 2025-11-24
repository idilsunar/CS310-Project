import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_habit_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/settings_screen.dart';

import 'utils/app_colors.dart';
import 'utils/app_text_styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Flow',

      theme: ThemeData(
        fontFamily: 'AppFont',
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textDark,
          elevation: 0,
          titleTextStyle: AppTextStyles.title,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          filled: true,
          fillColor: Colors.white,
          labelStyle: AppTextStyles.subtitle,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.background,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textLight,
        ),
      ),

      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/addHabit': (context) => const AddHabitScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/habitDetail': (context) => const Placeholder(),
        '/reminder': (context) => const Placeholder(),
      },
    );
  }
}