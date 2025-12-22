import 'package:cloud_firestore/cloud_firestore.dart';

class HabitCompletion {
  String id;
  String habitId;
  String userId;
  DateTime date;
  CompletionStatus status;
  DateTime createdAt;

  HabitCompletion({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.date,
    required this.status,
    required this.createdAt,
  });

  factory HabitCompletion.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return HabitCompletion(
      id: doc.id,
      habitId: data['habitId'] ?? '',
      userId: data['userId'] ?? '',
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: CompletionStatus.fromString(data['status'] ?? 'missed'),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'habitId': habitId,
      'userId': userId,
      'date': Timestamp.fromDate(DateTime(date.year, date.month, date.day)), // Store date only
      'status': status.value,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  HabitCompletion copyWith({
    String? id,
    String? habitId,
    String? userId,
    DateTime? date,
    CompletionStatus? status,
    DateTime? createdAt,
  }) {
    return HabitCompletion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum CompletionStatus {
  completed('completed'),
  partial('partial'),
  missed('missed');

  final String value;
  const CompletionStatus(this.value);

  static CompletionStatus fromString(String value) {
    return CompletionStatus.values.firstWhere(
          (e) => e.value == value,
      orElse: () => CompletionStatus.missed,
    );
  }
}