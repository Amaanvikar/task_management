import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String? Function(T?)? validator;
  final String label;
  final ValueChanged<T?>? onChanged;

  CustomDropdown({
    required this.value,
    required this.items,
    required this.label,
    this.validator,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: DropdownButtonFormField<T>(
        value: value,
        onChanged: onChanged,
        validator: validator,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF01442C), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(item.toString()),
          );
        }).toList(),
      ),
    );
  }
}
