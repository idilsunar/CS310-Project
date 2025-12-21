import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/preferences_provider.dart';
import 'onboarding_screen.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, PreferencesProvider>(
      builder: (context, authProvider, prefsProvider, _) {
        if (prefsProvider.isLoading || authProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (authProvider.currentUser != null) {
          return const HomeScreen();
        }

        if (prefsProvider.hasCompletedOnboarding) {
          return const LoginScreen1();
        } else {
          return const OnboardingPage1();
        }
      },
    );
  }
}
