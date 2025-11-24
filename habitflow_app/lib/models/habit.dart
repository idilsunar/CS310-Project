class Habit {
  String name;
  bool isDone;
  String? category;
  String? frequency;
  String? color;

  Habit({
    required this.name,
    this.isDone = false,
    this.category,
    this.frequency,
    this.color,
  });
}

