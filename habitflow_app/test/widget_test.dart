import 'package:flutter_test/flutter_test.dart';

import 'package:habit_flow/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Welcome to Habitflow'), findsOneWidget);
  });
}
