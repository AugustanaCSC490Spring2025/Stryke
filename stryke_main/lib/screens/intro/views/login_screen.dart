import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:test_app/auth/google_sign_in/authentication.dart';
import 'package:test_app/screens/home/home_screen.dart';
import 'package:test_app/screens/intro/views/sign_up_screen.dart';

import '../../../components/my_text_field.dart';
import '../../../utils/spacing.dart';
import 'info_input_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = Authentication();
  final _formKey = GlobalKey<FormState>();
  bool loginRequired = false;
  bool obscurePassword = true;
  bool isRounded = false;
  String? _errorMsg;
  String? _loginError;


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Icon
            Container(
              height: screenHeight * 0.125,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFB7FF00),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(40)),
              ),
              child: const Center(
                child: Icon(Icons.electric_bolt_rounded, size: 100,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Back Button & Title

            const Align(
              alignment: Alignment.center,
              child: Text(
                "Welcome back to STRYKE!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 45),

            // Form Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Text(
                    "The Best College Student-Athlete Tracking App!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 65),

                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 90,
                            child: MyTextField(
                                controller: _emailController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "ex. user@gmail.com",
                                  labelText: "Email",
                                  labelStyle:
                                      const TextStyle(color: Color(0xFFB7FF00)),
                                  filled: true,
                                  fillColor: const Color(0xFF1C1C1C),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 22.5, horizontal: 20.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFB7FF00)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFB7FF00)),
                                  ),
                                ),
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                errorMsg: _errorMsg,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please fill in this field';
                                  } else if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                                      .hasMatch(val)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                }),
                          ),
                          verticalSpacing(20),
                          SizedBox(
                            height: 90,
                            child: MyTextField(
                              controller: _passwordController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "ex. Test1234!",
                                labelText: "Password",
                                labelStyle:
                                    const TextStyle(color: Color(0xFFB7FF00)),
                                filled: true,
                                fillColor: const Color(0xFF1C1C1C),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 22.5, horizontal: 20.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFB7FF00)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFB7FF00)),
                                ),
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
                              ),
                              obscureText: obscurePassword,
                              keyboardType: TextInputType.visiblePassword,
                              prefixIcon: const Icon(CupertinoIcons.lock_fill),
                              errorMsg: _errorMsg,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'Please fill in this field';
                                } else if (!RegExp(
                                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                                    .hasMatch(val)) {
                                  return 'Please enter a valid password';
                                } else if (_loginError != null) {
                                  return 'Invalid credentials. Please try again.';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )),

                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB7FF00)),
                    ),
                  ),

                  verticalSpacing(55),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          bool success = await _authService.loginUser(_emailController.text, _passwordController.text);
                          if (success) {
                            setState(() {
                              _loginError = null;
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                            );
                          } else {
                            setState(() {
                              _loginError =
                                  'Invalid';
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB7FF00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),

                  verticalSpacing(45),

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
                        bool success = await _authService.googleSignIn();

                        if (success) {
                          bool userExists = await _authService.checkIfUserExists();

                          if (userExists == false) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const InfoInputScreen()),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
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
                              "Sign In with Google",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors
                                    .white, // Light text color for dark mode
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  verticalSpacing(45),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUnScreen()),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Click here to ',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFB7FF00),
                              // Green color for Sign Up
                              fontWeight: FontWeight.bold, // Bold style
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
