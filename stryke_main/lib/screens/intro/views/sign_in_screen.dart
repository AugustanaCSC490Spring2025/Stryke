import 'package:firebase_auth/firebase_auth.dart';
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
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();

  bool obscurePassword = true;
  bool isRounded = false;

  Future<bool> signupUser() async {
    try {
      if (_passwordController.text == _passwordConfirmController.text) {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text,
            );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords don't match")),
        );
        return false;
      }    
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup failed: Please enter Username and Password")),
      );
      return false;
    }
  }


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

              //CREATE ACCOUNT TEXT
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

              //Email field
              verticalSpacing(30),
              SizedBox(
                width: screenWidth * .7,
                child: TextFormField(
                    controller: _emailController,
                    style: ThemeTextStyles.textFieldInput,
                    decoration: TextFormFieldsStyles.formTextFieldDefault(hintText: "Email"),
                ),
              ),

              //Password field
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
              //confirm password field
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

              //create account
              verticalSpacing(35),
              SizedBox(
                width: screenWidth * .5,
                child: ElevatedButton(
                    onPressed: () async {
                      bool success = await signupUser();
                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InfoInputScreen()
                          ),
                        );
                      }
                    },
                    style: ButtonStyles.colorButton(backgroundColor: const Color(0xffb7ff00), textColor: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                    child: Text("Create Account")
                    ),
              ),

              //sign in with google
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

  