import 'package:flutter/material.dart';

class ReminderSettingScreen extends StatefulWidget {
  const ReminderSettingScreen({super.key});

  @override
  State<ReminderSettingScreen> createState() => _ReminderSettingScreenState();
}

class _ReminderSettingScreenState extends State<ReminderSettingScreen> {
  String selectedHabit = "Habit Selection";
  TimeOfDay? selectedTime;
  List<bool> weekDays = List.generate(7, (_) => false);

  final List<String> days = ["M", "T", "W", "T", "F", "S", "S"];

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  InputDecoration myDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reminder Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Set daily reminders for your habits.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            Row(
              children: const [
                Icon(Icons.list),
                SizedBox(width: 10),
                Text("Habit Selection", style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: myDecoration("Habit Selection"),
              initialValue: selectedHabit,
              items: [
                "Habit Selection",
                "Reading",
                "Workout",
                "Study",
                "Meditation",
              ].map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
              onChanged: (value) {
                setState(() {
                  selectedHabit = value!;
                });
              },
            ),
            const SizedBox(height: 32),
            Row(
              children: const [
                Icon(Icons.access_time),
                SizedBox(width: 10),
                Text("Time Setting", style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: pickTime,
                child: Text(
                  selectedTime == null
                      ? "Pick Time"
                      : selectedTime!.format(context),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: const [
                Icon(Icons.calendar_month),
                SizedBox(width: 10),
                Text("Repeat Days", style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: List.generate(7, (i) {
                return ChoiceChip(
                  label: Text(days[i]),
                  selected: weekDays[i],
                  onSelected: (value) {
                    setState(() {
                      weekDays[i] = value;
                    });
                  },
                );
              }),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Save Reminders"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

