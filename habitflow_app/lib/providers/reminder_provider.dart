import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/reminder.dart';
import '../repositories/reminder_repository.dart';

class ReminderProvider extends ChangeNotifier {
  final ReminderRepository _repository = ReminderRepository();

  Reminder? _reminder;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<Reminder?>? _subscription;

  Reminder? get reminder => _reminder;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void loadReminder(String userId) {
    _isLoading = true;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _repository.getReminder(userId).listen(
      (reminder) {
        _reminder = reminder;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> saveReminder(Reminder reminder, String userId) async {
    try {
      await _repository.saveReminder(reminder, userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
