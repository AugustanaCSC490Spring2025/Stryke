import 'package:flutter/material.dart';
import '../../../utils/button_styles.dart';
import '../../../utils/spacing.dart';
import '../../../utils/text_styles.dart';
import '../../intro/views/sign_up_screen.dart';
import 'login_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth * 0.7;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.5,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFB7FF00),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                ),
                child: const Icon(Icons.electric_bolt_rounded, size: 300),
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
                          MaterialPageRoute<void>(
                              builder: (context) =>
                              const SignUnScreen()),
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
                            context, MaterialPageRoute(
                            builder:(context) => const LoginScreen())
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
      ),
    );
  }
}

