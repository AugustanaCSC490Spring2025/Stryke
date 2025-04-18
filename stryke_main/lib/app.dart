import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/screens/home/home_screen.dart';
import 'package:test_app/screens/intro/views/splash_screen.dart';
import 'components/main_navigation.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "STRYKE",
      home: StreamBuilder<User?>(
        stream:
            FirebaseAuth.instance.authStateChanges(), // Listen to auth changes
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show loading indicator while checking auth
          }
          if (snapshot.hasData) {
            // Quick lug shortcut
            // User is logged in
            return const MainNavigation(
                index: 0); // Go to the main navigation page
          } else {
            // return const HomePage();
            // User is not logged in
            return const SplashScreen(); // Stay on AuthPage or navigate to login
          }
        },
      ),
    );
  }
}
