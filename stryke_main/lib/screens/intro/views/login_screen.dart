import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:test_app/screens/home/home_screen.dart';
import 'package:test_app/screens/intro/views/sign_up_screen.dart';

import '../../../components/my_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loginRequired = false;
  bool obscurePassword = true;
  String? _errorMsg;

  Future<bool> loginUser() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMsg = "Passwords do not match!";
      });
      return false;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      return true; // Login successful
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMsg = e.message;
      });
      return false; // Login failed
    }
  }

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
                child: Icon(
                  Icons.electric_bolt_sharp,
                  size: 100,
                  color: Colors.black,
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
                          MyTextField(
                              controller: _emailController,
                              style: const TextStyle(color: Colors.white),
                              hintText: 'Email',
                              decoration: InputDecoration(
                                hintText: "Email",
                                labelText: "Email",
                                labelStyle:
                                    const TextStyle(color: Color(0xFFB7FF00)),
                                filled: true,
                                fillColor: const Color(0xFF1C1C1C),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 22.5, horizontal: 10.0),
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
                          const SizedBox(height: 40),
                          MyTextField(
                            controller: _passwordController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Password",
                              labelText: "Password",
                              labelStyle:
                                  const TextStyle(color: Color(0xFFB7FF00)),
                              filled: true,
                              fillColor: const Color(0xFF1C1C1C),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 22.5, horizontal: 10.0),
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
                            hintText: 'Password',
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
                          const SizedBox(height: 10),

                          /* MyTextField(
                      controller: _confirmPasswordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        labelStyle: const TextStyle(color: Color(0xFFB7FF00)),
                        filled: true,
                        fillColor: const Color(0xFF1C1C1C),
                        contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Color(0xFFB7FF00)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Color(0xFFB7FF00)),
                        ),
                      ),
                      hintText: 'Password',
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
                    ),*/
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

                  const SizedBox(height: 80),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          bool success = await loginUser();
                          if (success) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
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
                        'Login',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  const Text(
                    'By Continuing you Agree to be STAY HARD!',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),

                  const SizedBox(height: 65),

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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
