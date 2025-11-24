import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  final bool showAppBar;

  const CalendarScreen({super.key, this.showAppBar = true});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _currentMonthOffset = 0;

  final List<String> months = [
    'September 2025',
    'October 2025',
    'November 2025',
    'December 2025',
    'January 2026',
    'February 2026',
  ];

  final Map<int, List<Map<String, dynamic>>> monthData = {
    0: [
      {'day': 'Monday', 'dots': [Colors.green, Colors.green, Colors.green], 'ratio': '3/3'},
      {'day': 'Tuesday', 'dots': [Colors.yellow, Colors.green], 'ratio': '2/3'},
      {'day': 'Wednesday', 'dots': [Colors.red, Colors.yellow, Colors.green], 'ratio': '2/4'},
      {'day': 'Thursday', 'dots': [Colors.green, Colors.green], 'ratio': '2/2'},
      {'day': 'Friday', 'dots': [Colors.red, Colors.green, Colors.green], 'ratio': '3/4'},
      {'day': 'Saturday', 'dots': [Colors.green], 'ratio': '1/1'},
      {'day': 'Sunday', 'dots': [Colors.yellow], 'ratio': '1/2'},
    ],
    1: [
      {'day': 'Monday', 'dots': [Colors.green, Colors.yellow, Colors.green], 'ratio': '3/4'},
      {'day': 'Tuesday', 'dots': [Colors.yellow, Colors.green, Colors.green], 'ratio': '3/4'},
      {'day': 'Wednesday', 'dots': [Colors.red, Colors.yellow], 'ratio': '1/3'},
      {'day': 'Thursday', 'dots': [Colors.yellow, Colors.green, Colors.red], 'ratio': '2/4'},
      {'day': 'Friday', 'dots': [Colors.green, Colors.green, Colors.green], 'ratio': '3/3'},
      {'day': 'Saturday', 'dots': [Colors.green, Colors.yellow], 'ratio': '2/2'},
      {'day': 'Sunday', 'dots': [Colors.red], 'ratio': '0/1'},
    ],
    2: [
      {'day': 'Monday', 'dots': [Colors.green, Colors.green, Colors.green, Colors.green], 'ratio': '4/4'},
      {'day': 'Tuesday', 'dots': [Colors.yellow, Colors.green, Colors.green, Colors.green], 'ratio': '4/5'},
      {'day': 'Wednesday', 'dots': [Colors.red, Colors.yellow, Colors.green], 'ratio': '2/4'},
      {'day': 'Thursday', 'dots': [Colors.yellow, Colors.green, Colors.red, Colors.yellow], 'ratio': '3/6'},
      {'day': 'Friday', 'dots': [Colors.red, Colors.green, Colors.green], 'ratio': '3/4'},
      {'day': 'Saturday', 'dots': [Colors.green], 'ratio': '1/1'},
      {'day': 'Sunday', 'dots': [Colors.red], 'ratio': '0/1'},
    ],
    3: [
      {'day': 'Monday', 'dots': [Colors.green, Colors.green], 'ratio': '2/2'},
      {'day': 'Tuesday', 'dots': [Colors.yellow, Colors.green, Colors.green], 'ratio': '3/4'},
      {'day': 'Wednesday', 'dots': [Colors.green, Colors.yellow, Colors.green], 'ratio': '3/4'},
      {'day': 'Thursday', 'dots': [Colors.yellow, Colors.green], 'ratio': '2/3'},
      {'day': 'Friday', 'dots': [Colors.red, Colors.green], 'ratio': '2/3'},
      {'day': 'Saturday', 'dots': [Colors.green, Colors.green], 'ratio': '2/2'},
      {'day': 'Sunday', 'dots': [Colors.yellow], 'ratio': '1/2'},
    ],
    4: [
      {'day': 'Monday', 'dots': [Colors.green, Colors.green, Colors.green], 'ratio': '3/3'},
      {'day': 'Tuesday', 'dots': [Colors.green, Colors.green], 'ratio': '2/2'},
      {'day': 'Wednesday', 'dots': [Colors.red, Colors.yellow, Colors.green, Colors.green], 'ratio': '3/5'},
      {'day': 'Thursday', 'dots': [Colors.yellow, Colors.green, Colors.yellow], 'ratio': '2/4'},
      {'day': 'Friday', 'dots': [Colors.green, Colors.green, Colors.green], 'ratio': '3/3'},
      {'day': 'Saturday', 'dots': [Colors.green], 'ratio': '1/1'},
      {'day': 'Sunday', 'dots': [Colors.red], 'ratio': '0/1'},
    ],
    5: [
      {'day': 'Monday', 'dots': [Colors.green, Colors.green, Colors.green, Colors.green], 'ratio': '4/4'},
      {'day': 'Tuesday', 'dots': [Colors.yellow, Colors.green, Colors.green], 'ratio': '3/4'},
      {'day': 'Wednesday', 'dots': [Colors.green, Colors.yellow, Colors.green], 'ratio': '3/4'},
      {'day': 'Thursday', 'dots': [Colors.yellow, Colors.green, Colors.green], 'ratio': '3/4'},
      {'day': 'Friday', 'dots': [Colors.green, Colors.green], 'ratio': '2/2'},
      {'day': 'Saturday', 'dots': [Colors.green, Colors.yellow], 'ratio': '2/2'},
      {'day': 'Sunday', 'dots': [Colors.yellow], 'ratio': '1/2'},
    ],
  };

  Widget buildDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  void _previousMonth() {
    if (_currentMonthOffset > 0) {
      setState(() {
        _currentMonthOffset--;
      });
    }
  }

  void _nextMonth() {
    if (_currentMonthOffset < months.length - 1) {
      setState(() {
        _currentMonthOffset++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = monthData[_currentMonthOffset]!;

    final content = Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      color: _currentMonthOffset > 0 ? Colors.black : Colors.grey,
                    ),
                    onPressed: _currentMonthOffset > 0 ? _previousMonth : null,
                  ),
                  Text(
                    months[_currentMonthOffset],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.chevron_right,
                      color: _currentMonthOffset < months.length - 1 ? Colors.black : Colors.grey,
                    ),
                    onPressed: _currentMonthOffset < months.length - 1 ? _nextMonth : null,
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: days.length,
            itemBuilder: (context, i) {
              final item = days[i];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        item['day'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Wrap(
                        spacing: 4,
                        children: [
                          for (var color in item['dots']) buildDot(color),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item['ratio'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(
              top: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  buildDot(Colors.green),
                  const SizedBox(width: 6),
                  const Text("Complete", style: TextStyle(fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  buildDot(Colors.yellow),
                  const SizedBox(width: 6),
                  const Text("Partial", style: TextStyle(fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  buildDot(Colors.red),
                  const SizedBox(width: 6),
                  const Text("Missed", style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    if (widget.showAppBar) {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.calendar_month, size: 20),
              SizedBox(width: 6),
              Text("Calendar"),
            ],
          ),
          centerTitle: true,
        ),
        body: content,
      );
    }

    return content;
  }
}