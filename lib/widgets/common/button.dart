import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

enum ButtonType { primary, secondary }

class CommonButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;
  final ButtonType buttonType;

  const CommonButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
    this.buttonType = ButtonType.primary,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = buttonType == ButtonType.primary
        ? const Color(0xFF01442C)
        : Colors.grey;
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: Colors.white),
            )
          : Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
    );
  }
}
