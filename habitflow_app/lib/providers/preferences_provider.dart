import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _hasCompletedOnboarding = false;
  int _lastSelectedTab = 0;
  bool _notificationsEnabled = true;
  
  String _dailyNote = '';

  bool _isLoading = false;

  bool get isDarkMode => _isDarkMode;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  int get lastSelectedTab => _lastSelectedTab;
  bool get notificationsEnabled => _notificationsEnabled;
  
  String get dailyNote => _dailyNote;

  bool get isLoading => _isLoading;

  String? _currentUserId;

  PreferencesProvider() {
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _hasCompletedOnboarding =
          prefs.getBool('hasCompletedOnboarding') ?? false;
      _lastSelectedTab = prefs.getInt('lastSelectedTab') ?? 0;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    } catch (e) {
      debugPrint('Error loading preferences: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserPreferences(String userId) async {
    _currentUserId = userId;
    try {
      final prefs = await SharedPreferences.getInstance();
      _dailyNote = prefs.getString('dailyNote_$userId') ?? '';
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user preferences: $e');
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
  
  Future<void> saveDailyNote(String note) async {
    _dailyNote = note;
    notifyListeners();

    if (_currentUserId != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('dailyNote_$_currentUserId', note);
      } catch (e) {
        debugPrint('Error saving daily note: $e');
      }
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notificationsEnabled', enabled);
    } catch (e) {
      debugPrint('Error saving notifications setting: $e');
    }
  }

  Future<void> clearPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _isDarkMode = false;
      _hasCompletedOnboarding = false;
      _lastSelectedTab = 0;
      _notificationsEnabled = true;
      
      _dailyNote = '';

      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing preferences: $e');
    }
  }
}
