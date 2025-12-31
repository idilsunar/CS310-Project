import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Notification tapped: ${details.payload}');
      },
    );

    _isInitialized = true;
  }

  Future<bool> requestPermissions() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final iosPlugin = _notifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

    bool granted = true;

    if (androidPlugin != null) {
      granted = await androidPlugin.requestNotificationsPermission() ?? false;
    }

    if (iosPlugin != null) {
      granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      ) ?? false;
    }

    return granted;
  }

  Future<void> scheduleHabitReminder({
    required String habitId,
    required String habitName,
    required TimeOfDay time,
    required List<bool> days,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    await cancelHabitReminder(habitId);

    for (int i = 0; i < days.length; i++) {
      if (days[i]) {
        await _scheduleDayReminder(
          habitId: habitId,
          habitName: habitName,
          time: time,
          dayOfWeek: i + 1,
        );
      }
    }
  }

  Future<void> _scheduleDayReminder({
    required String habitId,
    required String habitName,
    required TimeOfDay time,
    required int dayOfWeek,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    while (scheduledDate.weekday != dayOfWeek || scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'habit_reminders',
      'Habit Reminders',
      channelDescription: 'Notifications for habit reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final notificationId = '${habitId}_$dayOfWeek'.hashCode;

    await _notifications.zonedSchedule(
      notificationId,
      'Time for $habitName!',
      'Don\'t forget to complete your habit today.',
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );

    debugPrint('Scheduled notification for $habitName on day $dayOfWeek at ${time.hour}:${time.minute}');
  }

  Future<void> cancelHabitReminder(String habitId) async {
    for (int i = 1; i <= 7; i++) {
      final notificationId = '${habitId}_$i'.hashCode;
      await _notifications.cancel(notificationId);
    }
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}

