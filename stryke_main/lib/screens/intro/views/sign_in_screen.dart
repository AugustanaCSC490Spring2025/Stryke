import 'package:flutter/material.dart';
import 'package:test_app/screens/intro/views/info_input_screen.dart';
import 'package:test_app/utils/button_styles.dart';
import 'package:test_app/utils/spacing.dart';
import 'package:test_app/utils/text_form_field_styles.dart';
import 'package:test_app/utils/text_styles.dart';
import 'package:test_app/auth/google_sign_in/google_auth.dart';
import '../../../utils/text_styles.dart';


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
  bool isRounded = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
          backgroundColor: const Color(0xFF1C1C1C),
          body: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.35,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFB7FF00),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(40)),
                  ),
                  child: Icon(Icons.bolt_sharp, size: screenHeight * .2),
                ),
              ),
              verticalSpacing(25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      }, 
                      icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white,)
                  ),
                  Text("Create Account", style: ThemeTextStyles.introScreenText_SubTitle,),
                  horizontalSpacing(50)
                ],
              ),
              verticalSpacing(30),
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
                width: screenWidth * .5,
                child: ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (context) =>
                            const InfoInputScreen()),
                      );
                    },
                    style: ButtonStyles.colorButton(backgroundColor: const Color(0xffb7ff00), textColor: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                    child: Text("Create Account")
                    ),
              ),
              verticalSpacing(20),
              AnimatedContainer(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  borderRadius: isRounded ? BorderRadius.circular(14) : BorderRadius.circular(0),
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isRounded = !isRounded;
                    });
                    GoogleAuth().googlesignin();
                  },
                  child: Text("Sign In With Google", style: ThemeTextStyles.textWidthSizing(size: 14),),
                )
              )
            ],
          ),
    );
  }
}

  