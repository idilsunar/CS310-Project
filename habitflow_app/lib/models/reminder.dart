class Reminder {
  final String habit;
  final String time;
  final List<bool> days;

  Reminder({
    required this.habit,
    required this.time,
    required this.days,
  });

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      habit: map['habit'],
      time: map['time'],
      days: List<bool>.from(map['days']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'habit': habit,
      'time': time,
      'days': days,
    };
  }

  Reminder copyWith({
    String? habit,
    String? time,
    List<bool>? days,
  }) {
    return Reminder(
      habit: habit ?? this.habit,
      time: time ?? this.time,
      days: days ?? this.days,
    );
  }
}
