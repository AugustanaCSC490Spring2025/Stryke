import 'package:flutter/material.dart';
import 'package:test_app/utils/button_styles.dart';
import 'package:test_app/utils/text_form_field_styles.dart';

import '../../../utils/spacing.dart';
import '../../../utils/text_styles.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.5,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFB7FF00),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(40)),
              ),
              child: const Icon(Icons.bolt_sharp, size: 300),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    )),
                Expanded(
                  child: Text(
                    "Please Login",
                    textAlign: TextAlign.center,
                    style: ThemeTextStyles.introScreenText_SubTitle,
                  ),
                ),
                horizontalSpacing(48),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 35),
            child: Form(
              child: Column(
                children: [
                  SizedBox(
                    width: screenWidth * .8,
                    child: TextFormField(
                        controller: _usernameController,
                        style: ThemeTextStyles.textFieldInput,
                        decoration: TextFormFieldsStyles.formTextFieldDefault(
                            hintText: "Username")),
                  ),
                  verticalSpacing(35),
                  SizedBox(
                    width: screenWidth * .8,
                    child: TextFormField(
                        controller: _passwordController,
                        style: ThemeTextStyles.textFieldInput,
                        decoration: TextFormFieldsStyles.formTextFieldDefault(
                            hintText: "Password")),
                  ),
                  verticalSpacing(50),
                  SizedBox(
                      width: screenWidth * .7,
                      child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyles.colorButton(
                              backgroundColor: const Color(0xFFB7FF00),
                              textColor: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              verticalPadding: 20),
                          child: const Text('Login')))
                ],
              ),
            ),
          )
        ],
      ),
    );
    ;
  }
}
