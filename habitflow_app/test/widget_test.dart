import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_flow/models/habit.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('Simple MaterialApp renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('HabitFlow')),
            body: const Center(child: Text('Welcome to HabitFlow')),
          ),
        ),
      );

      expect(find.text('HabitFlow'), findsOneWidget);
      expect(find.text('Welcome to HabitFlow'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('Habit information displays in a Card widget', (WidgetTester tester) async {
      final testHabit = Habit(
        id: 'test1',
        name: 'Exercise Daily',
        isDone: false,
        createdBy: 'user123',
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Card(
              child: ListTile(
                title: Text(testHabit.name),
                trailing: Checkbox(
                  value: testHabit.isDone,
                  onChanged: (value) {},
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Exercise Daily'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
    });
  });
}
