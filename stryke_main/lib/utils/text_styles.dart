  import 'package:flutter/material.dart';
  import 'package:google_fonts/google_fonts.dart';

  class ThemeTextStyles {
    static TextStyle textWidthSizing({required double size}) {
      return GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: size);
    }
    static TextStyle introScreenText_SubTitle = GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32);
    static TextStyle introScreenText = GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600);
    static TextStyle textFieldHints = GoogleFonts.poppins(color: const Color(0xFF717171), fontSize: 16, fontWeight: FontWeight.w400);
    static TextStyle textFieldInput = GoogleFonts.poppins(color: const Color(0xFFB7FF00), fontSize: 16, fontWeight: FontWeight.w400);
  }