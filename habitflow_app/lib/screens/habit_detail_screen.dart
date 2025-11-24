import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;
  
  const HabitDetailScreen({super.key, required this.habit});

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  late TextEditingController nameController;
  late String selectedCategory;
  late String selectedFrequency;
  late String selectedColor;

  final List<String> categoryList = [
    "Sports and activities",
    "Health",
    "Work",
    "Study",
    "Personal growth"
  ];

  final List<String> frequencyList = [
    "Every day",
    "4 times per week",
    "3 times per week",
    "Once a week"
  ];

  final List<String> colorList = [
    "Blue",
    "Red",
    "Green",
    "Purple",
    "Orange"
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.habit.name);
    selectedCategory = widget.habit.category ?? "Sports and activities";
    selectedFrequency = widget.habit.frequency ?? "4 times per week";
    selectedColor = widget.habit.color ?? "Blue";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    child: const Icon(Icons.arrow_back, size: 26),
                  ),
                  const Spacer(),
                  const Text(
                    "Habit details",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  const Spacer(),
                  const SizedBox(width: 26),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                "Habit Name",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                "Category",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                value: selectedCategory,
                items: categoryList,
                onChanged: (value) {
                  setState(() => selectedCategory = value!);
                },
                backgroundColor: Colors.green.shade100,
              ),
              const SizedBox(height: 25),
              const Text(
                "Frequency",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                value: selectedFrequency,
                items: frequencyList,
                onChanged: (value) {
                  setState(() => selectedFrequency = value!);
                },
              ),
              const SizedBox(height: 25),
              const Text(
                "Specific habit color",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              _buildDropdown(
                value: selectedColor,
                items: colorList,
                onChanged: (value) {
                  setState(() => selectedColor = value!);
                },
                backgroundColor: Colors.blue.shade100,
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
                  onPressed: () {
                    widget.habit.name = nameController.text;
                    widget.habit.category = selectedCategory;
                    widget.habit.frequency = selectedFrequency;
                    widget.habit.color = selectedColor;
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Edit habit",
                    style: TextStyle(
                        fontSize: 17,
                        color: Color(0xFF6A00FF),
                        fontWeight: FontWeight.w600),
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
    required Function(String?) onChanged,
    Color? backgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: const InputDecoration(border: InputBorder.none),
        icon: const Icon(Icons.keyboard_arrow_down),
        items: items
            .map((item) => DropdownMenuItem(
          value: item,
          child: Text(item),
        ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

