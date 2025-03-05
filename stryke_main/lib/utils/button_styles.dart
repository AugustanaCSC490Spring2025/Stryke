import 'package:flutter/material.dart';

class ButtonStyles {
  static ButtonStyle colorButton (Color color){
    return ButtonStyle(backgroundColor: MaterialStateProperty.all(color),);
  }
}