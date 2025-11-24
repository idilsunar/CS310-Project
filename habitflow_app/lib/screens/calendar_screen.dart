import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});


  Widget buildDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> days = [
      {
        'day': 'Monday',
        'dots': [Colors.green, Colors.green, Colors.green, Colors.green],
        'ratio': '4/4'
      },
      {
        'day': 'Tuesday',
        'dots': [Colors.yellow, Colors.green, Colors.green, Colors.green],
        'ratio': '4/5'
      },
      {
        'day': 'Wednesday',
        'dots': [Colors.red, Colors.yellow, Colors.green],
        'ratio': '2/4'
      },
      {
        'day': 'Thursday',
        'dots': [Colors.yellow, Colors.green, Colors.red, Colors.yellow],
        'ratio': '3/6'
      },
      {
        'day': 'Friday',
        'dots': [Colors.red, Colors.green, Colors.green],
        'ratio': '3/4'
      },
      {
        'day': 'Saturday',
        'dots': [Colors.green],
        'ratio': '1/1'
      },
      {
        'day': 'Sunday',
        'dots': [Colors.red],
        'ratio': '0/1'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.calendar_month, size: 20),
            SizedBox(width: 6),
            Text("Calendar"),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/achievements');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'November 2025',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: days.length,
                itemBuilder: (context, i) {
                  final item = days[i];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            item['day'],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),


                        Expanded(
                          child: Row(
                            children: [
                              for (var color in item['dots']) buildDot(color),
                            ],
                          ),
                        ),

                        Text(item['ratio']),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),


            Row(
              children: [
                buildDot(Colors.green),
                const SizedBox(width: 4),
                const Text("Complete (100%)   "),
                buildDot(Colors.yellow),
                const SizedBox(width: 4),
                const Text("Partial (50%)   "),
                buildDot(Colors.red),
                const SizedBox(width: 4),
                const Text("Missed (0%)"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
