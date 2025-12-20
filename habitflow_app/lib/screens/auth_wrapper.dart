import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/preferences_provider.dart';
import 'onboarding_screen.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, PreferencesProvider>(
      builder: (context, authProvider, prefsProvider, _) {
        if (prefsProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (authProvider.isLoggedIn) {
          return const HomeScreen();
        } else {
          if (prefsProvider.hasCompletedOnboarding) {
            return const LoginScreen1();
          } else {
            return const OnboardingPage1();
          }
        }
      },
    );
  }
}
