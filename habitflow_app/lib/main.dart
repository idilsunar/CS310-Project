import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/habit_provider.dart';
import 'providers/preferences_provider.dart';
import 'providers/reminder_provider.dart';
import 'screens/auth_wrapper.dart';
import 'providers/achievements_provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
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
          );
        },
      ),
    );
  }
}
