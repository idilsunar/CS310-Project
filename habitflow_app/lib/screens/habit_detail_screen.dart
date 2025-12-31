import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../providers/preferences_provider.dart';
import '../utils/app_colors.dart';
import '../services/notification_service.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  late final TextEditingController nameController;

  late String selectedCategory;
  late String selectedFrequency;
  late String selectedColor;
  late bool hasReminder;
  late TimeOfDay reminderTime;
  late List<bool> reminderDays;
  
  final List<String> categoryList = const [
    'Study',
    'Health',
    'Work',
    'School',
    'Workout',
    'Homework',
  ];

  final List<String> frequencyList = const [
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
    'Weekends',
  ];

  final List<String> colorList = const [
    'Red',
    'Orange',
    'Blue',
    'Green',
    'Yellow',
    'Purple',
    'Grey',
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.habit.name);
    
    selectedCategory = (widget.habit.category != null &&
        categoryList.contains(widget.habit.category))
        ? widget.habit.category!
        : categoryList.first;

    selectedFrequency = (widget.habit.frequency != null &&
        frequencyList.contains(widget.habit.frequency))
        ? widget.habit.frequency!
        : frequencyList.first;

    selectedColor =
    (widget.habit.color != null && colorList.contains(widget.habit.color))
        ? widget.habit.color!
        : colorList.first;
    
    hasReminder = widget.habit.hasReminder;
    reminderTime = _parseTime(widget.habit.reminderTime ?? '08:00');
    reminderDays = widget.habit.reminderDays ?? List.generate(7, (_) => false);
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _saveEdits() async {
    final newName = nameController.text.trim();
    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Habit name cannot be empty')),
      );
      return;
    }

    final updates = <String, dynamic>{
      'name': newName,
      'category': selectedCategory,
      'frequency': selectedFrequency,
      'color': selectedColor,
      'hasReminder': hasReminder,
      'reminderTime': '${reminderTime.hour.toString().padLeft(2, '0')}:${reminderTime.minute.toString().padLeft(2, '0')}',
      'reminderDays': reminderDays,
    };

    await context.read<HabitProvider>().updateHabit(widget.habit.id, updates);

    if (!mounted) return;

    final err = context.read<HabitProvider>().error;
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err)),
      );
      return;
    }

    final prefsProvider = context.read<PreferencesProvider>();
    final notificationService = NotificationService();
    
    if (hasReminder && reminderDays.any((day) => day) && prefsProvider.notificationsEnabled) {
      await notificationService.scheduleHabitReminder(
        habitId: widget.habit.id,
        habitName: newName,
        time: reminderTime,
        days: reminderDays,
      );
    } else {
      await notificationService.cancelHabitReminder(widget.habit.id);
    }

    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      size: 26,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Habit details",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 26),
                ],
              ),
              const SizedBox(height: 30),

              Text(
                "Habit Name",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),

              const SizedBox(height: 25),
              Text(
                "Category",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                value: selectedCategory,
                items: categoryList,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => selectedCategory = value);
                },
              ),

              const SizedBox(height: 25),
              Text(
                "Frequency",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                value: selectedFrequency,
                items: frequencyList,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => selectedFrequency = value);
                },
              ),

              const SizedBox(height: 25),
              Text(
                "Specific habit color",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                value: selectedColor,
                items: colorList,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => selectedColor = value);
                },
              ),

              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E2A3A) : AppColors.turquoise.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? const Color(0xFF2A3F5F) : AppColors.turquoise.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.notifications_active, color: AppColors.turquoise, size: 24),
                            const SizedBox(width: 12),
                            Text(
                              "Reminder",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: hasReminder,
                          onChanged: (value) {
                            setState(() => hasReminder = value);
                          },
                          activeColor: AppColors.turquoise,
                        ),
                      ],
                    ),
                    if (hasReminder) ...[
                      const SizedBox(height: 20),
                      Text(
                        "Time",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: reminderTime,
                          );
                          if (picked != null) {
                            setState(() => reminderTime = picked);
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.access_time, color: AppColors.turquoise),
                              const SizedBox(width: 12),
                              Text(
                                reminderTime.format(context),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Repeat Days",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(7, (i) {
                          final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                reminderDays[i] = !reminderDays[i];
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: reminderDays[i]
                                    ? AppColors.turquoise
                                    : (isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: reminderDays[i]
                                      ? AppColors.turquoise
                                      : (isDark ? Colors.grey.shade700 : Colors.grey.shade400),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  days[i],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: reminderDays[i]
                                        ? Colors.white
                                        : (isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    side: BorderSide(color: AppColors.navyBlue, width: 1.4),
                  ),
                  onPressed: _saveEdits,
                  child: Text(
                    "Save changes",
                    style: TextStyle(
                      fontSize: 17,
                      color: AppColors.navyBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: const InputDecoration(border: InputBorder.none),
        dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        icon: const Icon(Icons.keyboard_arrow_down),
        items: items
            .toSet()
            .map(
              (item) => DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
          ),
        )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
