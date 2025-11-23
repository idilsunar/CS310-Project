import 'package:flutter/material.dart';
import 'achievements_screen.dart';

enum HabitStatus { completed, partial, missed }

class DaySummary {
  final String dayName;
  final List<HabitStatus> statuses;

  DaySummary({required this.dayName, required this.statuses});

  int get total => statuses.length;
  int get completed =>
      statuses.where((s) => s == HabitStatus.completed).length;
}

class CalendarScreen extends StatelessWidget {
  CalendarScreen({super.key});

  final List<DaySummary> _days = [
    DaySummary(dayName: 'Monday', statuses: [
      HabitStatus.completed,
      HabitStatus.completed,
      HabitStatus.completed,
      HabitStatus.completed,
    ]),
    DaySummary(dayName: 'Tuesday', statuses: [
      HabitStatus.completed,
      HabitStatus.completed,
      HabitStatus.completed,
      HabitStatus.partial,
      HabitStatus.missed,
    ]),
    DaySummary(dayName: 'Wednesday', statuses: [
      HabitStatus.completed,
      HabitStatus.partial,
      HabitStatus.missed,
      HabitStatus.missed,
    ]),
    DaySummary(dayName: 'Thursday', statuses: [
      HabitStatus.completed,
      HabitStatus.partial,
      HabitStatus.partial,
      HabitStatus.missed,
      HabitStatus.missed,
      HabitStatus.completed,
    ]),
    DaySummary(dayName: 'Friday', statuses: [
      HabitStatus.completed,
      HabitStatus.completed,
      HabitStatus.partial,
      HabitStatus.missed,
    ]),
    DaySummary(dayName: 'Saturday', statuses: [
      HabitStatus.completed,
    ]),
    DaySummary(dayName: 'Sunday', statuses: [
      HabitStatus.missed,
    ]),
  ];

  Color _statusColor(HabitStatus status) {
    switch (status) {
      case HabitStatus.completed:
        return Colors.green;
      case HabitStatus.partial:
        return Colors.orange;
      case HabitStatus.missed:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,


      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/achievements');

        },
        label: const Text("Achievements"),
        icon: const Icon(Icons.emoji_events_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "Calendar",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {},
                  ),
                  Column(
                    children: const [
                      Text(
                        "Calendar",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "November 2025",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 10),


              Expanded(
                child: ListView.separated(
                  itemCount: _days.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final day = _days[index];
                    return Row(
                      children: [

                        SizedBox(
                          width: 100,
                          child: Text(
                            day.dayName,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),


                        Expanded(
                          child: Wrap(
                            spacing: 6,
                            children: day.statuses
                                .map((status) => Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: _statusColor(status),
                                shape: BoxShape.circle,
                              ),
                            ))
                                .toList(),
                          ),
                        ),


                        Text(
                          '${day.completed}/${day.total}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _LegendDot(color: Colors.green, label: "Complete (100%)"),
                  SizedBox(width: 16),
                  _LegendDot(color: Colors.orange, label: "Partial (50%)"),
                  SizedBox(width: 16),
                  _LegendDot(color: Colors.red, label: "Missed (0%)"),
                ],
              ),

              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
