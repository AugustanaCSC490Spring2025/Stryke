import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget{
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final FocusNode? focusNode;
  final String? errorMsg;
  final dynamic decoration;
  final dynamic style;

  const MyTextField({super.key,
    required this.controller,
    required this.obscureText,
    required this.keyboardType,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.errorMsg,
    required this.decoration,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onTap: onTap,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      decoration: decoration,
      style: style,
      );
  }
}