import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/components/main_navigation.dart';
import 'package:test_app/screens/intro/views/info_input_screen.dart';
import 'package:test_app/utils/spacing.dart';
import 'package:test_app/widgets/text_input/text_input.dart';
import '../../../auth/google_sign_in/authentication.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = Authentication();
  final _formKey = GlobalKey<FormState>();
  bool loginRequired = false;
  bool obscurePassword = true;
  bool isRounded = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.2,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFB7FF00),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(40)),
                ),
                child: Icon(Icons.electric_bolt_rounded,
                    size: screenHeight * 0.12),
              ),
            ),

            verticalSpacing(screenHeight * 0.04),

            const Align(
              alignment: Alignment.center,
              child: Text(
                "Welcome to STRYKE!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            verticalSpacing(screenHeight * 0.005),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * .05),
              child: Column(
                children: [
                  const Text(
                    "Create your account below to get started!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  verticalSpacing(screenHeight * 0.03),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                              height: 90,
                              child: buildTextInput(
                                  obscure: false,
                                  label: "Email",
                                  hint: "ex. user@gmail.com",
                                  controller: _emailController,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Please fill in this field';
                                    } else if (!RegExp(
                                            r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                                        .hasMatch(val)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  })),
                          verticalSpacing(screenHeight * 0.005),
                          buildTextInput(
                              label: "Password",
                              hint: "ex. Test1234!",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? CupertinoIcons.eye_fill
                                      : CupertinoIcons.eye_slash_fill,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                              ),
                              obscure: obscurePassword,
                              controller: _passwordController,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please fill in this field';
                                }
                                // Check for missing conditions and build the error message
                                String errorMessage = '';
                                if (!RegExp(r'^(?=.*?[A-Z])').hasMatch(val)) {
                                  errorMessage +=
                                      '• At least one uppercase letter\n';
                                }
                                if (!RegExp(r'^(?=.*?[a-z])').hasMatch(val)) {
                                  errorMessage +=
                                      '• At least one lowercase letter\n';
                                }
                                if (!RegExp(r'^(?=.*?[0-9])').hasMatch(val)) {
                                  errorMessage += '• At least one number\n';
                                }
                                if (!RegExp(
                                        r'^(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])')
                                    .hasMatch(val)) {
                                  errorMessage +=
                                      '• At least one special character\n';
                                }
                                if (val.length < 8) {
                                  errorMessage += '• Minimum of 8 characters\n';
                                }
                                // If any condition is missing, return the error message
                                if (errorMessage.isNotEmpty) {
                                  return 'Password must contain:\n$errorMessage';
                                }
                                return null; // Return null if password is valid
                              }),
                          verticalSpacing(screenHeight * 0.025),
                          SizedBox(
                              height: 90,
                              child: buildTextInput(
                                obscure: true,
                                label: "Confirm Password",
                                hint: 'ex. Test1234!',
                                controller: _confirmPasswordController,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please fill in this field';
                                  } else if (val != _passwordController.text) {
                                    return 'Please enter a correct password';
                                  }
                                  return null;
                                },
                              )),
                        ],
                      )),
                  verticalSpacing(screenHeight * 0.02),
                  SizedBox(
                    width: screenWidth * .7,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          bool success = await _authService.signUpUser(
                            _emailController.text,
                            _passwordController.text,
                            context,
                          );

                          if (success) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const InfoInputScreen(),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB7FF00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //sign in with google
            verticalSpacing(screenHeight * 0.035),

            AnimatedContainer(
              curve: Curves.ease,
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                color: Colors.black,
                // Dark background
                borderRadius: isRounded
                    ? BorderRadius.circular(30)
                    : BorderRadius.circular(0),
                border: Border.all(color: Colors.white.withOpacity(0.5)),
                // Light border
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () async {
                  setState(() {
                    isRounded = !isRounded;
                  });
                  // Call your Google sign-in function
                  bool success = await _authService.googleSignIn();

                  if (success) {
                    //bool userData = await _authService.checkIfUserHasData();
                    bool userData = await _authService.checkIfUserExists();

                    if (userData == false) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InfoInputScreen()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MainNavigation(index: 0)),
                      );
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/google_logo.png',
                        // The Google logo asset
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Sign Up with Google",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white, // Light text color for dark mode
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            verticalSpacing(screenHeight * 0.055),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    TextSpan(
                      text: 'Click Here',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFB7FF00), // Green color for Sign Up
                        fontWeight: FontWeight.bold, // Bold style
                      ),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpacing(screenHeight * .2),
          ],
        ),
      ),
    );
  }

  @override // Prevent memory leaks and help run smoother
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
