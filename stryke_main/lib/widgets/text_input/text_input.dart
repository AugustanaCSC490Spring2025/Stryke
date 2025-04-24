import 'package:flutter/material.dart';
import 'package:test_app/components/my_text_field.dart';

Widget buildTextInput({
  required String label,
  required String hint,
  required TextEditingController controller,
  required FormFieldValidator<String>? validator,
  bool obscure = false,
  Widget? suffixIcon,
  Widget? prefixIcon,
}) {
  return MyTextField(
    controller: controller,
    obscureText: obscure,
    keyboardType:
        obscure ? TextInputType.visiblePassword : TextInputType.emailAddress,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hint,
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFFB7FF00)),
      filled: true,
      fillColor: const Color(0xFF1C1C1C),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 22.5, horizontal: 20.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFB7FF00)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFB7FF00)),
      ),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
    ),
    validator: validator,
  );
}
