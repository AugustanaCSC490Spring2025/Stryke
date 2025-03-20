import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../auth/google_sign_in/authentication.dart';
import '../intro/views/splash_screen.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({super.key});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  final _authService = Authentication();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await _authService.signOut();
          Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const SplashScreen()));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFB7FF00),
          foregroundColor: Colors.black,
        ),
        child: Text('Sign Out'),
      ),
    );
  }
}
