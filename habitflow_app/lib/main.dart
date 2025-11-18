import 'package:flutter/material.dart';
import 'screens/habitDetailScreen.dart';
import 'screens/progressPageScreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProgressPageScreen(),
    );
  }
}
