import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reminder_provider.dart';
import '../providers/auth_provider.dart';
import '../models/reminder.dart';
import '../utils/app_colors.dart';

class ReminderSettingScreen extends StatefulWidget {
  const ReminderSettingScreen({super.key});

  @override
  State<ReminderSettingScreen> createState() => _ReminderSettingScreenState();
}

class _ReminderSettingScreenState extends State<ReminderSettingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      final reminderProvider = context.read<ReminderProvider>();
      if (auth.currentUser != null) {
        reminderProvider.loadReminder(auth.currentUser!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReminderProvider>();
    final auth = context.read<AuthProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (provider.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Reminder Settings"),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final reminder = provider.reminder ??
        Reminder(
          habit: "Reading",
          time: "08:00",
          days: List.generate(7, (_) => false),
        );

    final days = [
      {"label": "M", "full": "Mon"},
      {"label": "T", "full": "Tue"},
      {"label": "W", "full": "Wed"},
      {"label": "T", "full": "Thu"},
      {"label": "F", "full": "Fri"},
      {"label": "S", "full": "Sat"},
      {"label": "S", "full": "Sun"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reminder Settings"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.turquoise.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.fitness_center,
                          color: AppColors.turquoise,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Habit Type",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: reminder.habit,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: InputBorder.none,
                      ),
                      dropdownColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                      items: [
                        {"name": "Reading", "icon": Icons.menu_book},
                        {"name": "Workout", "icon": Icons.fitness_center},
                        {"name": "Study", "icon": Icons.school},
                        {"name": "Meditation", "icon": Icons.self_improvement},
                      ].map((e) => DropdownMenuItem(
                        value: e["name"] as String,
                        child: Row(
                          children: [
                            Icon(e["icon"] as IconData, size: 20, color: AppColors.turquoise),
                            const SizedBox(width: 12),
                            Text(e["name"] as String),
                          ],
                        ),
                      )).toList(),
                      onChanged: (v) {
                        provider.saveReminder(
                          reminder.copyWith(habit: v!),
                          auth.currentUser!.uid,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.peach.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.access_time,
                          color: AppColors.peach,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Reminder Time",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
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
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.alarm, color: AppColors.peach, size: 28),
                          const SizedBox(width: 12),
                          Text(
                            reminder.time,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.calendar_today,
                          color: Colors.green,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Repeat Days",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(7, (i) {
                      final isSelected = reminder.days[i];
                      return GestureDetector(
                        onTap: () {
                          final updatedDays = List<bool>.from(reminder.days);
                          updatedDays[i] = !updatedDays[i];
                          provider.saveReminder(
                            reminder.copyWith(days: updatedDays),
                            auth.currentUser!.uid,
                          );
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.turquoise
                                : (isDark ? const Color(0xFF2A2A2A) : Colors.grey[100]),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.turquoise
                                  : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              days[i]["label"]!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? Colors.grey[400] : Colors.grey[700]),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
