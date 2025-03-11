import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:test_app/screens/auth/views/sign_in_screen_old.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
>>>>>>> 7329290e072312e977a6bd8b057e9b265dd00920
import 'package:test_app/screens/auth/views/welcome_screen.dart';
import '../../../bloc/authentication_bloc/authentication_bloc.dart';
import '../../../utils/button_styles.dart';
import '../../../utils/spacing.dart';
import '../../../utils/text_styles.dart';
<<<<<<< HEAD
=======
import '../../intro/views/sign_in_screen.dart';
import '../../auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import '../../auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import '../../auth/views/sign_up_screen.dart';
>>>>>>> 7329290e072312e977a6bd8b057e9b265dd00920
import 'login_screen.dart';
import 'package:test_app/screens/auth/google_sign_in/google_auth.dart';

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
                        MaterialPageRoute<void>(
                            builder: (context) =>
                            const SignInScreen()), 
                            // const WelcomeScreen(selectedTab: 0)) // not working BACK END PURPOSE

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
                verticalSpacing(4),
                SizedBox(
                  width: buttonWidth,
                  child: ElevatedButton(
                    onPressed: GoogleAuth().googlesignin,
                    child: const Text("Sign in with Google"),
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

