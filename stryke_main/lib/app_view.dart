import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:test_app/screens/auth/views/welcome_screen.dart';
//import 'package:test_app/screens/home/views/home_screen.dart';
import 'package:test_app/screens/intro/views/intro_screen.dart';
import 'bloc/authentication_bloc/authentication_bloc.dart';
import 'navi_bug.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorObservers: [MyNavigatorObserver()],
      title: "Stryke App",
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          surface: Colors.grey.shade100,
          onSurface: Colors.black,
          primary: Colors.green,
          onPrimary: Colors.white,
          tertiary: Colors.lightGreenAccent,
        ),
      ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            print('Authentication status: ${state.status}' " preview");
            if (state.status == AuthenticationStatus.authenticated) {
              print('Authentication status: ${state.status}' " home");
              return BlocProvider(
                create: (context) => SignInBloc(
                  context.read<AuthenticationBloc>().userRepository,
                ),
                // child: const HomeScreen(),
              );
            } else {
              print('Authentication status: ${state.status}' + " intro");
              return const IntroScreen();
            }
          },
        ),
    );
  }
}