import 'package:flutter/material.dart';
import 'package:test_app/utils/text_styles.dart';

class TextFormFieldsStyles {
  static InputDecoration formTextFieldDefault({required String hintText})
  {
    return InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFFB7FF00)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFFB7FF00), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: Color(0xFFB7FF00), width: 2),
        ),
        hintText: hintText,
        hintStyle: ThemeTextStyles.textFieldHints,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24)
    );
  }
}