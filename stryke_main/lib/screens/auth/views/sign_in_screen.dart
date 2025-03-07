import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/my_text_field.dart';
import '../../home/views/home_screen.dart';
import '../blocs/sign_in_bloc/sign_in_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
        listener: (context, state) {
          if(state is SignInSuccess) {
            setState(() {
              signInRequired = false;
            });
          } else if(state is SignInProcess) {
            setState(() {
              signInRequired = true;
            });
          } else if(state is SignInFailure) {
            setState(() {
              signInRequired = false;
              _errorMsg = 'Invalid email or password';
            });
          }
        }, child: Form(
      key: _formkey,
      child: Column(
        children:[
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * .9,
            child: MyTextField(
              controller: emailController,
              hintText: "Email",
              obscureText: false,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(CupertinoIcons.mail_solid),
              errorMsg: _errorMsg,
              validator: (val){
                if(val!.isEmpty) {
                  return "Email cannot be empty";
                } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(val)){
                  return "Invalid email";
                }
                return null;
              }
            )
          ),
          const SizedBox(height: 10),
          SizedBox(
              width: MediaQuery.of(context).size.width * .9,
              child: MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: const Icon(CupertinoIcons.lock_fill),
                  errorMsg: _errorMsg,
                  validator: (val){
                    if(val!.isEmpty) {
                      return "Please fill in this field";
                    } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$').hasMatch(val)){
                      /*
                        At least 8 characters
                        At least one uppercase letter
                        At least one lowercase letter
                        At least one digit
                        At least one special character (e.g., !@#$%^&*)
                       */
                      return "Please enter a valid password";
                    }
                    return null;
                  },
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                        if (obscurePassword) {
                          iconPassword = CupertinoIcons.eye_fill;
                        } else {
                          iconPassword = CupertinoIcons.eye_slash_fill;
                          }
                      });
                    },
                    icon: Icon(iconPassword)
                ),
              )
          ),
          const SizedBox(height: 20),
          !signInRequired ? SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: TextButton(
              onPressed: () {
                if(_formkey.currentState!.validate()){
                  context.read<SignInBloc>().add(SignInRequired(
                    emailController.text,
                    passwordController.text)
                  );
                }
              },
              style: TextButton.styleFrom(
                elevation: 3.0,
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60.0),
                )
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 1.0),
                child: Text(
                  "Sign In",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
              )
            ),
          )
          : const CircularProgressIndicator(),
       ],
      ),
    ),
    );
  }
}
