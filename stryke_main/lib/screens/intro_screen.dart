import 'package:flutter/material.dart';
import 'package:test_app/screens/auth/views/welcome_screen.dart';
import '../utils/button_styles.dart';
import '../utils/spacing.dart';
import '../utils/text_styles.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {


    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = MediaQuery.of(context).size.width * 0.7;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.5,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFB7FF00),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
              ),
              child: const Icon(Icons.bolt_sharp, size: 300),
            ),
          ),
          verticalSpacing(30),
          Center(
            child: Text(
              "Say Hello to \n The STRYKE App",
              style: ThemeTextStyles.introScreenText_SubTitle,
              textAlign: TextAlign.center,
            ),
          ),
          verticalSpacing(50),
          Center(
            child: Text(
              "Join your team to track your metrics \n and see the progress you have made in season!",
              style: ThemeTextStyles.introScreenText,
              textAlign: TextAlign.center,
            ),
          ),
          verticalSpacing(40),
          Center(
            child: Column(
              children: [
                SizedBox(
                  width: buttonWidth,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const WelcomeScreen(selectedTab: 1)),
                      );
                    },
                    style: ButtonStyles.colorButton(
                      backgroundColor: const Color(0xFFB7FF00),
                      textColor: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                    child: const Text("Sign Up"),
                  ),
                ),
                verticalSpacing(24),
                SizedBox(
                  width: buttonWidth,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const WelcomeScreen(selectedTab: 0)),
                      );
                    },
                    style: ButtonStyles.transparentButton(
                      borderColor: Colors.white,
                      textColor: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                    child: const Text("Login"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
