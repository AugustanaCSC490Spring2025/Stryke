import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centering both vertically and horizontally
        children: [
          Icon(
            Icons.show_chart, // The yield icon
            size: 100, // Large icon size
            color: Color(0xFFB7FF00), // Icon color (yellow for the yield sign)
          ),
          SizedBox(height: 20), // Adding space between the icon and the text
          Text(
            'YOUR PROGRESS', // The text you want to show
            style: TextStyle(
              fontSize: 40, // Large font size
              fontWeight: FontWeight.bold, // Bold text
              color: Colors.white, // White color for the text
            ),
          ),
        ],
      ),
    );
  }
}
