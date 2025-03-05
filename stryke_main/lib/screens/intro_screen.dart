import 'package:flutter/material.dart';
import 'package:test_app/screens/auth/views/sign_in_screen.dart';
import 'package:test_app/screens/auth/views/welcome_screen.dart';
import '../utils/button_styles.dart';
import '../utils/spacing.dart';
import '../utils/text_styles.dart';
import 'auth/views/sign_up_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(40)),
                ),
                child: const Icon(Icons.bolt_sharp, size: 300),
              ),
            ),
            const SizedBox(height: 20), // Added spacing
            Center(
              child: Text(
                "Say Hello to \n the STRYKE App",
                style: ThemeTextStyles.introScreenText_SubTitle,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10), // Added spacing
            Center(
              child: Text(
                "Join your team to track your metrics \n and see the progress you have made in season!",
                style: ThemeTextStyles.introScreenText,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20), // Added spacing
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const WelcomeScreen(selectedTab: 1)),
                );
              },
              child: Text("Sign Up", style: ThemeTextStyles.introScreenText),
              style: ButtonStyles.colorButton(Colors.green, Colors.black)
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const WelcomeScreen(selectedTab: 0)),
                );
              },
              child: Text("Sign In", style: ThemeTextStyles.introScreenText),
              style: ButtonStyles.colorButton(Colors.white, Colors.black87),
            ),
            verticalSpacing(150), // Kept your existing spacing method
          ],
        ),
      ),
    );
  }
}
