import 'package:flutter/material.dart';
import 'package:stryke_main/utils/text_styles.dart';
import 'package:stryke_main/utils/spacing.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),),
                  child: Icon(Icons.bolt_sharp, size: 300,),
                ),
              ),
              Text("Say Hello to \n the Stryke App", style: ThemeTextStyles.introScreenTextBold, ),// Center
              Text("Join your team to track your metrics \n and see the progress you have made in season!",
                style: ThemeTextStyles.introScreenText,),
              ElevatedButton(onPressed: (){}, child: Text("Sign Up", 
                style: ThemeTextStyles.introScreenText,)),
              ElevatedButton(onPressed: (){}, child: Text("Login", 
                style: ThemeTextStyles.introScreenText, )),
              verticalSpacing(150),
            ],
          ),
        ),
      ),
    );
  }
}
