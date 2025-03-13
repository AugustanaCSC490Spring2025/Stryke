import 'package:flutter/material.dart';

import '../../../utils/button_styles.dart';
import '../../../utils/spacing.dart';
import '../../../utils/text_form_field_styles.dart';
import '../../../utils/text_styles.dart';

class InfoInputScreen extends StatefulWidget {
  const InfoInputScreen({super.key});

  @override
  State<InfoInputScreen> createState() => _InfoInputScreenState();
}

class _InfoInputScreenState extends State<InfoInputScreen> {

  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

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
              Text("Give us some Info", style: ThemeTextStyles.introScreenText_SubTitle,),
              horizontalSpacing(50)
            ],
          ),
          verticalSpacing(30),
          SizedBox(
            width: screenWidth * .7,
            child: TextFormField(
              controller: _ageController,
              style: ThemeTextStyles.textFieldInput,
              decoration: TextFormFieldsStyles.formTextFieldDefault(hintText: "ex: 25"),
            ),
          ),
          verticalSpacing(35),
          SizedBox(
            width: screenWidth * .7,
            child: TextFormField(
              controller: _heightController,
              style: ThemeTextStyles.textFieldInput,
              decoration: TextFormFieldsStyles.formTextFieldDefault(hintText: "ex: 6'0"),
            ),
          ),
          verticalSpacing(35),
          SizedBox(
            width: screenWidth * .7,
            child: TextFormField(
              controller: _weightController,
              style: ThemeTextStyles.textFieldInput,
              decoration: TextFormFieldsStyles.formTextFieldDefault(hintText: "ex: 185 (in lbs)"),
            ),
          ),
          verticalSpacing(35),
          SizedBox(
            width: screenWidth * .7,
            child: TextFormField(
              controller: _genderController,
              style: ThemeTextStyles.textFieldInput,
              decoration: TextFormFieldsStyles.formTextFieldDefault(hintText: "ex: Male"),
            ),
          ),
          verticalSpacing(35),
          SizedBox(
            width: screenWidth * .5,
            child: ElevatedButton(
                onPressed: (){},
                style: ButtonStyles.colorButton(backgroundColor: const Color(0xffb7ff00), textColor: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                child: Text("Join STRYKE")
            ),
          ),
        ],
      ),
    );
  }
}
