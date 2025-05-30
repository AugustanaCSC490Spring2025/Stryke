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
    double buttonWidth = screenWidth * 0.8;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.4,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFB7FF00),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                ),
                child: Icon(Icons.electric_bolt, size: screenHeight * 0.2),
              ),
            ),
            verticalSpacing(screenHeight * 0.03),
            Center(
              child: Text(
                "Say Hello to \n The STRYKE App",
                style: ThemeTextStyles.introScreenText_SubTitle,
                textAlign: TextAlign.center,
              ),
            ),
            verticalSpacing(screenHeight * 0.03),
            Center(
              child: Text(
                "Join your team to track your metrics \n and see the progress you have made in season!",
                style: ThemeTextStyles.introScreenText,
                textAlign: TextAlign.center,
              ),
            ),
            verticalSpacing(screenHeight * 0.045),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    width: buttonWidth,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              const SignUpScreen()),
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
                  verticalSpacing(screenHeight * 0.025),
                  SizedBox(
                    width: buttonWidth,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
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
                  verticalSpacing(screenHeight * .2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

