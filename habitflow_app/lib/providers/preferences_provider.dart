import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _hasCompletedOnboarding = false;
  int _lastSelectedTab = 0;
  bool _isLoading = false;

  bool get isDarkMode => _isDarkMode;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  int get lastSelectedTab => _lastSelectedTab;
  bool get isLoading => _isLoading;

  PreferencesProvider() {
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;
      _lastSelectedTab = prefs.getInt('lastSelectedTab') ?? 0;
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveTheme(bool isDarkMode) async {
    _isDarkMode = isDarkMode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', isDarkMode);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }

  Future<void> toggleTheme() async {
    await saveTheme(!_isDarkMode);
  }

  Future<void> setOnboardingComplete(bool completed) async {
    _hasCompletedOnboarding = completed;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasCompletedOnboarding', completed);
    } catch (e) {
      debugPrint('Error saving onboarding status: $e');
    }
  }

  Future<void> saveTab(int tabIndex) async {
    _lastSelectedTab = tabIndex;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('lastSelectedTab', tabIndex);
    } catch (e) {
      debugPrint('Error saving tab: $e');
    }
  }

  Future<void> loadTab() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _lastSelectedTab = prefs.getInt('lastSelectedTab') ?? 0;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading tab: $e');
    }
  }

  Future<void> clearPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _isDarkMode = false;
      _hasCompletedOnboarding = false;
      _lastSelectedTab = 0;
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing preferences: $e');
    }
  }
}
