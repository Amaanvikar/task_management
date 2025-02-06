import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final int? maxLines;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  CustomTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
    this.maxLines = 1,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onTap: onTap,
      readOnly: onTap != null,
      onChanged: onChanged,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
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
    );
  }
}
