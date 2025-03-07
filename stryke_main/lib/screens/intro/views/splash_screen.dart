import 'package:flutter/material.dart';

import 'intro_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const IntroScreen()),
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.only(right: 7),
                decoration: const BoxDecoration(
                  color: Color(0xFFB7FF00),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: const Icon(Icons.bolt_sharp, size: 40),
              ),
              const Text(
                "STRYKE",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

