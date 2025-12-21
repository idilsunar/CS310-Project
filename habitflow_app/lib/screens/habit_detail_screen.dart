import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

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

    Navigator.pop(context);
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

              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    side: const BorderSide(color: Color(0xFF6A00FF), width: 1.4),
                  ),
                  onPressed: _saveEdits,
                  child: const Text(
                    "Save changes",
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xFF6A00FF),
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
        value: value,
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
