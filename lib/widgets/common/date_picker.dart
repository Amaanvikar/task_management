import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final String label;
  final ValueChanged<DateTime?> onDateChanged;

  CustomDatePicker({
    required this.selectedDate,
    required this.label,
    required this.onDateChanged,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          initialValue: selectedDate != null
              ? DateFormat.yMd().format(selectedDate!)
              : '',
          readOnly: true,
          decoration: InputDecoration(
            labelText: label,
            hintText: 'Select a date',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF01442C), width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          ),
        ),
      ),
    );
  }
}
