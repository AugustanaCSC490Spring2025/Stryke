import 'package:flutter/material.dart';

class FaqWidget extends StatelessWidget {
  const FaqWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFF2A2A2A),
      title: const Text("FAQ*", style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Q: How do I add a metric?",
              style: TextStyle(color: Colors.white70)),
            Text("A: Tap the + button on the home screen and select the exercise.",
              style: TextStyle(color: Colors.white)),
            SizedBox(height: 12),
            Text("Q: How do I delete my account?",
              style: TextStyle(color: Colors.white70)),
            Text("A: Click on your profile icon in the top left of any screen, and tap delete account.",
              style: TextStyle(color: Colors.white)),
            SizedBox(height: 12),
            Text("Q: How do I join another team?",
              style: TextStyle(color: Colors.white70)),
            Text("A: On the personal screen, click add team and input the code you recieved from your coach.",
              style: TextStyle(color: Colors.white)),
            SizedBox(height: 12),
            Text("Q: How do I update or edit a mistake from a past input?",
              style: TextStyle(color: Colors.white70)),
            Text("A: At the moment, inputs can’t be edited once submitted. A future update will include editing and deleting entries..",
              style: TextStyle(color: Colors.white)),
            SizedBox(height: 12),
            Text("Q: Why can I not check in?", 
              style: TextStyle(color: Colors.white70)),
            Text("A: At the moment, check in location is set to to the Carver Center. So you must be within 100 yards of the Carver Center to check in.", 
              style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close", style: TextStyle(color: Color(0xFFB7FF00)))
        )
      ],
    );
  }
}