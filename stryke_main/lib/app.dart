

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import 'auth_page.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  const MyApp (this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "STRYKE",
      home: AuthPage()
    );
  }
}



