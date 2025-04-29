import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:test_app/auth/google_sign_in/authentication.dart';
import 'package:test_app/screens/intro/views/sign_up_screen.dart';
import '../../../components/main_navigation.dart';
import '../../../components/my_text_field.dart';
import '../../../utils/spacing.dart';
import 'info_input_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


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
          child: Center(
            child: Icon(Icons.electric_bolt_rounded, size: screenHeight * 0.12),
              ),
            ),

            verticalSpacing(screenHeight * 0.04),

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

            verticalSpacing(screenHeight * 0.045),

            // Form Fields
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * .05),
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

                  verticalSpacing(screenHeight * 0.06),

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
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFB7FF00)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
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
                          verticalSpacing(screenHeight * 0.02),
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
                                    vertical: 22.5, horizontal: 22.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFB7FF00)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
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

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        final email = _emailController.text.trim();
                        final messenger = ScaffoldMessenger.of(context);
                        final nav = Navigator.of(context);
                        if (email.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please enter your email first")),
                          );
                          return;
                        }
                              try {
                                await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                                if (!mounted) return;
                                showDialog(
                                // ignore: use_build_context_synchronously
                                context: context,
                                builder: (_) => AlertDialog(
                                title: const Text('Email Sent'),
                               content: Text('A reset link has been sent to $email.'),
                                actions: [
                                 TextButton(
                                   onPressed: () => nav.pop(context),
                                       child: const Text('OK'),
                                    ),
                                 ],
                                ),
                              );
                              } on FirebaseAuthException catch (e) {
                                if (!mounted) return;
                                messenger.showSnackBar(SnackBar(content: Text(e.message ?? 'Failed to send email')),
                                );
                                        }
                                },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB7FF00)),
                      ),
                    ),
                  ),

                  verticalSpacing(screenHeight * 0.05),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      final nav = Navigator.of(context);
                      bool success = await _authService.loginUser(
                        _emailController.text,
                        _passwordController.text,
                      );
                      if (!success) {
                        setState(() => _loginError = 'Invalid');
                        return;
                      }
                      setState(() => _loginError = null);
                      bool userData = await _authService.checkIfUserExists();
                      if (userData) {
                        nav.push(
                          MaterialPageRoute(builder: (_) => const MainNavigation(index: 0)),
                        );
                      } else {
                        nav.push(
                          MaterialPageRoute(builder: (_) => const InfoInputScreen()),
                        );
                      }
                    },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB7FF00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
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

                  verticalSpacing(screenHeight * 0.05),

                  AnimatedContainer(
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      // Dark background
                      borderRadius: isRounded
                          ? BorderRadius.circular(30)
                          : BorderRadius.circular(0),
                      border: Border.all(color: Color.fromARGB(125, 255, 255, 255)),
                      // Light border
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(32, 0, 0, 0),
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

                        final nav = Navigator.of(context);

                        bool success = await _authService.googleSignIn();

                        if (success) {
                          //bool userData = await _authService.checkIfUserHasData();
                          bool userData = await _authService.checkIfUserExists();
                          if (!mounted) return;
                          if (userData == false) {
                            nav.push(
                              MaterialPageRoute(
                                  builder: (_) => const InfoInputScreen()),
                            );
                          } else {
                            nav.push(
                              MaterialPageRoute(
                                  builder: (_) => const MainNavigation(index: 0)),
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
                  verticalSpacing(screenHeight * 0.06),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()),
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
