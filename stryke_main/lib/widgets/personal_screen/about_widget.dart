import 'package:flutter/material.dart';

class AboutWidget extends StatelessWidget {
  const AboutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFF2A2A2A),
      title: const Text("About", style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(   
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "This fitness tracking app is designed to help Augustana student-athletes and coaches track performance metrics in the weight room. "
              "Stryke uses cloud synchronization, goal-setting, progress bars, charts, real-time data tracking, and personalized fitness logging.\n"
              "Crafted using Flutter’s flexible UI framework and Firebase’s real-time backend services.\n\n"
              "Created by Johnny Breeden, Matthew Hawkins, Kacper Cebula, Gavin McCorry, and Tommy Anderson.",
            style: TextStyle(color: Colors.white,)),
          ],
        ),
      ),
      actions: [
        TextButton(
         child: const Text("Close", style: TextStyle(color: Color(0xFFB7FF00))),
        onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}