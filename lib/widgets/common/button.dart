import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    // Set colors based on button type
    Color backgroundColor;
    if (buttonType == ButtonType.primary) {
      backgroundColor = Color(0xFF01442C);
    } else {
      backgroundColor = Colors.grey;
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
      child: isLoading
          ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator())
          : Text(
              label,
              style: GoogleFonts.montserrat(
                color: Colors.white,
              ),
            ),
    );
  }
}
