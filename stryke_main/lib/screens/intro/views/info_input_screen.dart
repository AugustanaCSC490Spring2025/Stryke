import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app/screens/home/home_screen.dart';

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
  String? _dropdownValue;
  final  _firstNameController = TextEditingController();
  final  _lastNameController = TextEditingController();
  final  _ageController = TextEditingController();
  final  _heightController = TextEditingController();
  final  _weightController = TextEditingController();

  void dropdownCallback(String? selectedValue) {
    if (selectedValue != null) {
      setState(() {
        _dropdownValue = selectedValue;
        print(_dropdownValue);
      });
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
            height: screenHeight * 0.125,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFB7FF00),
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(40)),
              ),
              child: Icon(Icons.electric_bolt_sharp, size: 100),
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
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              Text(
                "Give us some Info",
                style: ThemeTextStyles.introScreenText_SubTitle,
              ),
              horizontalSpacing(50)
            ],
          ),
          verticalSpacing(25),
          SizedBox(
            width: screenWidth * .7,
            child: TextFormField(
              controller: _firstNameController,
              style: ThemeTextStyles.textFieldInput,
              decoration: TextFormFieldsStyles.formTextFieldDefault(
                  hintText: "First Name"),
            ),
          ),
          verticalSpacing(25),
          SizedBox(
            width: screenWidth * .7,
            child: TextFormField(
              controller: _lastNameController,
              style: ThemeTextStyles.textFieldInput,
              decoration: TextFormFieldsStyles.formTextFieldDefault(
                  hintText: "Last Name"),
            ),
          ),
          verticalSpacing(25),
          SizedBox(
            width: screenWidth * .7,
            child: TextFormField(
              controller: _ageController,
              style: ThemeTextStyles.textFieldInput,
              decoration:
                  TextFormFieldsStyles.formTextFieldDefault(hintText: "Age (25)"),
            ),
          ),
          verticalSpacing(25),
          SizedBox(
            width: screenWidth * .7,
            child: TextFormField(
              controller: _heightController,
              style: ThemeTextStyles.textFieldInput,
              decoration: TextFormFieldsStyles.formTextFieldDefault(
                  hintText: "Height (6'0\")"),
            ),
          ),
          verticalSpacing(25),
          SizedBox(
            width: screenWidth * .7,
            child: TextFormField(
              controller: _weightController,
              style: ThemeTextStyles.textFieldInput,
              decoration: TextFormFieldsStyles.formTextFieldDefault(
                  hintText: "Weight (185)"),
            ),
          ),
          verticalSpacing(25),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xffb7ff00))),
              padding: EdgeInsets.only(left: 20),
              width: screenWidth * .7,
              height: 60,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  iconEnabledColor: const Color(0xffb7ff00),
                  dropdownColor: const Color(0xFF717171),
                  style: ThemeTextStyles.textFieldInput,
                  value: _dropdownValue,
                  isExpanded: true,
                  hint:
                      Text("Select Sex", style: ThemeTextStyles.textFieldInput),
                  onChanged: dropdownCallback,
                  items: const [
                    DropdownMenuItem(
                      child: Text("Male"),
                      value: "Male",
                    ),
                    DropdownMenuItem(
                      child: Text("Female"),
                      value: "Female",
                    ),
                    DropdownMenuItem(
                      child: Text("Other"),
                      value: "Other",
                    ),
                  ],
                ),
              )),
          verticalSpacing(25),
          SizedBox(
            width: screenWidth * .5,
            child: ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance.collection("users").add({
                    "first_Name": _firstNameController.text,
                    "last_Name": _lastNameController.text,
                    "age": _ageController.text,
                    "height": _heightController.text,
                    "weight": _weightController.text,
                    "Sex": _dropdownValue,
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                style: ButtonStyles.colorButton(
                    backgroundColor: const Color(0xffb7ff00),
                    textColor: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                child: Text("Join STRYKE")),
          ),
        ],
      ),
    );
  }
}
