import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/screens/intro/views/info_input_screen.dart';
import 'package:test_app/utils/spacing.dart';

import '../../../components/my_text_field.dart';
import 'login_screen.dart';

class SignUnScreen extends StatefulWidget {
  const SignUnScreen({super.key});

  @override
  State<SignUnScreen> createState() => _SignUnScreenState();
}

class _SignUnScreenState extends State<SignUnScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loginRequired = false;
  bool obscurePassword = true;
  String? _errorMsg;
  bool isRounded = false;

  Future<bool> signUpUser() async {
    try {
      if (_passwordController.text == _confirmPasswordController.text) {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords don't match")),
        );
        return false;
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Signup failed: Please enter Username and Password")),
      );
      return false;
    }
  }

  Future<bool> googleSignIn() async {
    await Future.delayed(const Duration(seconds: 1));
    return true; // Change this based on actual result
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.125,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFB7FF00),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(40)),
              ),
              child: const Icon(Icons.electric_bolt_sharp, size: 100),
            ),
          ),

          const SizedBox(height: 40),

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

          const SizedBox(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                const SizedBox(height: 50),
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
                                borderSide:
                                    const BorderSide(color: Color(0xFFB7FF00)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    const BorderSide(color: Color(0xFFB7FF00)),
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
                              }
                              return null;
                            },
                          ),
                        ),
                        verticalSpacing(20),
                        SizedBox(
                          height: 90,
                          child: MyTextField(
                            controller: _confirmPasswordController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              hintText: 'ex. Test1234!',
                              labelStyle:
                                  const TextStyle(color: Color(0xFFB7FF00)),
                              filled: true,
                              fillColor: const Color(0xFF1C1C1C),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 22.5, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    const BorderSide(color: Color(0xFFB7FF00)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    const BorderSide(color: Color(0xFFB7FF00)),
                              ),
                            ),
                            obscureText: obscurePassword,
                            keyboardType: TextInputType.visiblePassword,
                            prefixIcon: const Icon(CupertinoIcons.lock_fill),
                            errorMsg: _errorMsg,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please fill in this field';
                              } else if (val != _passwordController.text) {
                                return 'Please enter a correct password';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    )),
                verticalSpacing(35),
                SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool success = await signUpUser();
                        if (success) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const InfoInputScreen()),
                          );
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
                      'Sign Up',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //sign in with google
          verticalSpacing(30),

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
                bool success = await googleSignIn();

                if (success) {
                  // Navigate to another screen if sign-in is successful
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const InfoInputScreen()), // Replace HomePage with your target screen
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/google_logo.png', // The Google logo asset
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Sign in with Google",
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

          verticalSpacing(50),

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
        ],
      ),
    );
  }
}
