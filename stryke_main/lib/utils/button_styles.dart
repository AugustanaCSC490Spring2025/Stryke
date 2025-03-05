import 'package:flutter/material.dart';

class ButtonStyles {
  static ButtonStyle colorButton({
    required Color backgroundColor,
    required Color textColor,
    double fontSize = 16,  // Default size
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
}
