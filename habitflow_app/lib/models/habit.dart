import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  String id;
  String name;
  bool isDone;
  String? category;
  String? frequency;
  String? color;
  String createdBy;
  DateTime createdAt;

  Habit({
    required this.id,
    required this.name,
    this.isDone = false,
    this.category,
    this.frequency,
    this.color,
    required this.createdBy,
    required this.createdAt,
  });

  factory Habit.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Habit(
      id: doc.id,
      name: data['name'] ?? '',
      isDone: data['isDone'] ?? false,
      category: data['category'],
      frequency: data['frequency'],
      color: data['color'],
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'isDone': isDone,
      'category': category,
      'frequency': frequency,
      'color': color,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Habit copyWith({
    String? id,
    String? name,
    bool? isDone,
    String? category,
    String? frequency,
    String? color,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      isDone: isDone ?? this.isDone,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      color: color ?? this.color,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
