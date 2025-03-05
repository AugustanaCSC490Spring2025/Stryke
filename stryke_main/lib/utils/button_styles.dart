import 'package:flutter/material.dart';

class ButtonStyles {
  static ButtonStyle colorButton({
    required Color backgroundColor,
    required Color textColor,
    double fontSize = 16, // Default size
    FontWeight fontWeight = FontWeight.normal, // Default weight
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: textColor,
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }

  static ButtonStyle transparentButton({
    required Color textColor,
    Color? borderColor,
    double borderWidth = 2.0,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextButton.styleFrom(
      foregroundColor: textColor, // Text color
      backgroundColor: Colors.transparent, // Transparent background
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: borderColor != null
            ? BorderSide(color: borderColor, width: borderWidth)
            : BorderSide.none,
      ),
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
