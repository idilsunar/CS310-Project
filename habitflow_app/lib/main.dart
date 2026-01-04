import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/habit_provider.dart';
import 'providers/preferences_provider.dart';
import 'providers/reminder_provider.dart';
import 'providers/achievements_provider.dart';
import 'services/notification_service.dart';
import 'screens/auth_wrapper.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/add_habit_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/achievements_screen.dart';
import 'screens/badges_screen.dart';
import 'screens/reminder_setting_screen.dart';
import 'screens/progress_page_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  try {
    await NotificationService().initialize();
    await NotificationService().requestPermissions();
  } catch (e) {
    debugPrint('Notification initialization error: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HabitProvider()),
        ChangeNotifierProvider(create: (_) => PreferencesProvider()),
        ChangeNotifierProvider(create: (_) => AchievementsProvider()),
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, prefsProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: const Color(0xFF1A405A),
              scaffoldBackgroundColor: const Color(0xFFF8FCFD),
              fontFamily: 'AppFont',
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF1A405A),
                secondary: Color(0xFF5DBED1),
                tertiary: Color(0xFFF5C18A),
                surface: Colors.white,
                onPrimary: Colors.white,
                onSecondary: Color(0xFF1A405A),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFFF8FCFD),
                foregroundColor: Color(0xFF1A405A),
                elevation: 0,
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: const Color(0xFF5DBED1),
              scaffoldBackgroundColor: const Color(0xFF0D1F2D),
              cardColor: const Color(0xFF1A405A),
              fontFamily: 'AppFont',
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF5DBED1),
                secondary: Color(0xFFF5C18A),
                tertiary: Color(0xFF1A405A),
                surface: Color(0xFF1A405A),
                onPrimary: Color(0xFF0D1F2D),
                onSecondary: Color(0xFF0D1F2D),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF1A405A),
                foregroundColor: Color(0xFF5DBED1),
                elevation: 0,
              ),
            ),
            themeMode: prefsProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const AuthWrapper(),
            routes: {
              '/home': (context) => const HomeScreen(),
              '/login': (context) => const LoginScreen1(),
              '/signup': (context) => const LoginScreen2(),
              '/onboarding1': (context) => const OnboardingPage1(),
              '/onboarding2': (context) => const OnboardingPage2(),
              '/onboarding3': (context) => const OnboardingPage3(),
              '/onboarding4': (context) => const OnboardingPage4(),
              '/addHabit': (context) => const AddHabitScreen(),
              '/calendar': (context) => const CalendarScreen(),
              '/settings': (context) => const SettingsScreen(),
              '/achievements': (context) => const AchievementsScreen(),
              '/badges': (context) => const BadgesScreen(),
              '/progress': (context) => const ProgressPageScreen(),
              '/reminderSettings': (context) => const ReminderSettingScreen(),
            },
          );
        },
      ),
    );
  }
}
