import 'package:flutter/material.dart';

class SimpleFormScreen extends StatefulWidget {
  const SimpleFormScreen({super.key});

  @override
  State<SimpleFormScreen> createState() => _SimpleFormScreenState();
}

class _SimpleFormScreenState extends State<SimpleFormScreen> {

  final _formKey = GlobalKey<FormState>();

  String _habitName = '';
  int _targetPerWeek = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Habit (Form)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),


        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Habit name',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _habitName = value!.trim();
                },

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a habit name';
                  }
                  if (value.trim().length < 3) {
                    return 'At least 3 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),


              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Target per week',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _targetPerWeek = int.tryParse(value ?? '0') ?? 0;
                },
                validator: (value) {
                  final parsed = int.tryParse(value ?? '');
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a positive number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),


              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    // 4) Tüm TextFormField validator'larını çalıştırır
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      // FORM GEÇERSİZ => hata mesajları zaten alanların altında çıktı
      // ek olarak AlertDialog gösteriyoruz
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Form not valid'),
          content: const Text('Please fix the errors and try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Geçerliyse değerleri kaydet
    _formKey.currentState!.save();

    // Burada normalde listeye eklerdin, ama bu projede sadece demo yetiyor
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Habit saved'),
        content: Text(
          'Habit: $_habitName\nTarget per week: $_targetPerWeek',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // dialog
              Navigator.pop(context); // form ekranı
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
