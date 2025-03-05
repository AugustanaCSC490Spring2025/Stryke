import 'package:flutter/material.dart';

class ButtonStyles {
  static ButtonStyle colorButton (Color color, Color textColor){
    return ButtonStyle(backgroundColor: MaterialStateProperty.all(color), foregroundColor: MaterialStateProperty.all(textColor));
  }
}