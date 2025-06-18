import 'package:flutter/material.dart';

class DrugInput extends StatelessWidget {
  final String label;
  final Function(String) onChanged;

  const DrugInput({
    super.key,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: const Icon(Icons.medication),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a drug name';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}
