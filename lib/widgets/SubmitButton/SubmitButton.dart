import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSubmitButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final Color? backgroundColor;
  const CustomSubmitButton({
    required this.buttonText,
    this.onPressed,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: MaterialStatePropertyAll(
          Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
        ),
        backgroundColor: MaterialStatePropertyAll(
          this.backgroundColor ?? Theme.of(context).colorScheme.primary,
        ),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),
      ),
      child: Text(
        buttonText,
        style: GoogleFonts.josefinSans(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
