import 'package:flutter/material.dart';
import 'package:test_app/utils/button_styles.dart';
import 'package:test_app/utils/spacing.dart';
import 'package:test_app/utils/text_form_field_styles.dart';
import 'package:test_app/utils/text_styles.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>{

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
          backgroundColor: const Color(0xFF1C1C1C),
          body: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.25,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFB7FF00),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(40)),
                  ),
                  child: Icon(Icons.bolt_sharp, size: screenHeight * .15),
                ),
              ),
              verticalSpacing(40),
              SizedBox(
                width: screenWidth * .7,
                child: TextFormField(
                    controller: _emailController,
                    style: ThemeTextStyles.textFieldInput,
                    decoration: TextFormFieldsStyles.formTextFieldDefault(hintText: "Email"),
                ),
              ),
              verticalSpacing(35),
              SizedBox(
                width: screenWidth * .7,
                child: TextFormField(
                    controller: _usernameController,
                    style: ThemeTextStyles.textFieldInput,
                    decoration: TextFormFieldsStyles.formTextFieldDefault(hintText: "Username"),
                ),
              ),
              verticalSpacing(35),
               SizedBox(
                width: screenWidth * .7,
                child: TextFormField(
                    controller: _passwordController,
                    obscureText: obscurePassword,
                    style: ThemeTextStyles.textFieldInput,
                    decoration: TextFormFieldsStyles.formTextFieldDefault(hintText: "Password"),
                ),
              ),
              verticalSpacing(35),
               SizedBox(
                width: screenWidth * .7,
                child: TextFormField(
                    controller: _passwordConfirmController,
                    obscureText: obscurePassword,
                    style: ThemeTextStyles.textFieldInput,
                    decoration: TextFormFieldsStyles.formTextFieldDefault(hintText: "Confirm Password"),
                ),
              ),
              verticalSpacing(35),
              SizedBox(
                child: ElevatedButton(
                    onPressed: (){},
                    style: ButtonStyles.colorButton(backgroundColor: const Color(0xffb7ff00), textColor: Colors.black, fontWeight: FontWeight.bold),
                    child: Text("Create Account")
                    ),
              )



            ],
          ),
    );
  }
}

  