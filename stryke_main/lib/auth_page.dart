import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/screens/home/home_screen.dart';
//import 'package:test_app/screens/home/views/home_screen.dart';
import 'package:test_app/screens/intro/views/intro_screen.dart';
import 'package:test_app/screens/intro/views/splash_screen.dart';
import 'navi_bug.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomePage();
            } else {
              return SplashScreen();
            }
          }
      )
    );
  }
}