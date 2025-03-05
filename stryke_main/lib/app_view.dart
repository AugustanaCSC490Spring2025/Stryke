import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/screens/auth/views/welcome_screen.dart';
import 'package:test_app/screens/home/views/home_screen.dart';
import 'package:test_app/screens/intro_screen.dart';
import 'package:test_app/screens/splash_screen.dart';

import 'bloc/authentication_bloc/authentication_bloc.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pizza Delivery",
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          surface: Colors.grey.shade100,
          onSurface: Colors.black,
          primary: Colors.green,
          onPrimary: Colors.white,
          tertiary: Colors.lightGreenAccent
        )
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: ((context, state) {
          if(state.status == AuthenticationStatus.authenticated){
            return const HomeScreen();
          } else {
            return const SplashScreen();
          }
        }),
      )
    );
  }
}