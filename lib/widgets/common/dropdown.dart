import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          labelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF01442C), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(
              item.toString(),
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
