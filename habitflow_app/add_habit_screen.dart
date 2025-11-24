import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _category;
  String? _frequency;
  String? _color;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Habit',
          style: AppTextStyles.title,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Habit Name',
                  labelStyle: AppTextStyles.subtitle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
                onSaved: (val) => _name = val,
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: AppTextStyles.subtitle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                items: const [
                  DropdownMenuItem(child: Text('Study'), value: 'Study'),
                  DropdownMenuItem(child: Text('Health'), value: 'Health'),
                  DropdownMenuItem(child: Text('Work'), value: 'Work'),
                  DropdownMenuItem(child: Text('School'), value: 'School'),
                  DropdownMenuItem(child: Text('Workout'), value: 'Workout'),
                  DropdownMenuItem(child: Text('Homework'), value: 'Homework'),
                ],
                validator: (value) => value == null ? 'Required' : null,
                onChanged: (value) => _category = value,
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Frequency',
                  labelStyle: AppTextStyles.subtitle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                items: const [
                  DropdownMenuItem(child: Text('Daily'), value: 'Daily'),
                  DropdownMenuItem(child: Text('Weekly'), value: 'Weekly'),
                  DropdownMenuItem(child: Text('Monthly'), value: 'Monthly'),
                  DropdownMenuItem(child: Text('Yearly'), value: 'Yearly'),
                  DropdownMenuItem(child: Text('Weekends'), value: 'Weekends'),
                ],
                validator: (value) => value == null ? 'Required' : null,
                onChanged: (value) => _frequency = value,
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Color',
                  labelStyle: AppTextStyles.subtitle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                items: const [
                  DropdownMenuItem(child: Text('Red'), value: 'Red'),
                  DropdownMenuItem(child: Text('Orange'), value: 'Orange'),
                  DropdownMenuItem(child: Text('Blue'), value: 'Blue'),
                  DropdownMenuItem(child: Text('Green'), value: 'Green'),
                  DropdownMenuItem(child: Text('Yellow'), value: 'Yellow'),
                  DropdownMenuItem(child: Text('Purple'), value: 'Purple'),
                  DropdownMenuItem(child: Text('Grey'), value: 'Grey'),
                ],
                validator: (value) => value == null ? 'Required' : null,
                onChanged: (value) => _color = value,
              ),

              const SizedBox(height: 30),

              // SAVE
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle:
                    AppTextStyles.button.copyWith(color: Colors.white),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      final newHabit = Habit(
                        name: _name!,
                        category: _category,
                        frequency: _frequency,
                        color: _color,
                      );

                      Navigator.pop(context, newHabit);
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => const AlertDialog(
                          title: Text('Form error'),
                          content:
                          Text('Please fix the errors shown in the form.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ),

              const SizedBox(height: 12),

              // CANCEL
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: AppColors.primary),
                    textStyle: AppTextStyles.button,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}