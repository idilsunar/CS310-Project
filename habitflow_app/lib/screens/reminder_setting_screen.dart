import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reminder_provider.dart';
import '../providers/auth_provider.dart';
import '../models/reminder.dart';

class ReminderSettingScreen extends StatelessWidget {
  const ReminderSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReminderProvider>();
    final auth = context.read<AuthProvider>();

    final reminder = provider.reminder ??
        Reminder(
          habit: "Reading",
          time: "08:00",
          days: List.generate(7, (_) => false),
        );

    final days = ["M", "T", "W", "T", "F", "S", "S"];

    return Scaffold(
      appBar: AppBar(title: const Text("Reminder Settings")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: reminder.habit,
              items: ["Reading", "Workout", "Study", "Meditation"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) {
                provider.saveReminder(
                  reminder.copyWith(habit: v!),
                  auth.currentUser!.uid,
                );
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  provider.saveReminder(
                    reminder.copyWith(time: picked.format(context)),
                    auth.currentUser!.uid,
                  );
                }
              },
              child: Text(reminder.time),
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 8,
              children: List.generate(7, (i) {
                return ChoiceChip(
                  label: Text(days[i]),
                  selected: reminder.days[i],
                  onSelected: (v) {
                    final updatedDays = List<bool>.from(reminder.days);
                    updatedDays[i] = v;
                    provider.saveReminder(
                      reminder.copyWith(days: updatedDays),
                      auth.currentUser!.uid,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
