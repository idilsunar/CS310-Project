import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Calendar Screen Placeholder'),
            const SizedBox(height: 20),
            Image.network(
              'https://picsum.photos/200', // örnek bir random resim
              height: 120,
            ),
          ],
        ),
      ),
    );
  }
}