import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/screens/home/home_screen.dart';

import '../../../components/my_text_field.dart';
import '../../../utils/button_styles.dart';
import '../../../utils/spacing.dart';
import '../../../utils/text_styles.dart';

class InfoInputScreen extends StatefulWidget {
  const InfoInputScreen({super.key});

  @override
  State<InfoInputScreen> createState() => _InfoInputScreenState();
}

class _InfoInputScreenState extends State<InfoInputScreen> {
  String? _dropdownValue;
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMsg;
  bool _isLoading = false;
  final FocusNode _heightFocusNode = FocusNode();

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
              child: const Icon(Icons.electric_bolt_rounded, size: 100),
            ),
          ),
          verticalSpacing(30),
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
              const Text(
                "STRYKE On!",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              horizontalSpacing(50)
            ],
          ),
          verticalSpacing(20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: [
                Text(
                  "Now input some basic information about yourself to finish joining STRYKE!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          verticalSpacing(30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 75,
                    child: MyTextField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(height: .8),
                          hintText: 'ex. Phil Foden',
                          labelText: "First & Last name",
                          labelStyle: const TextStyle(color: Color(0xFFB7FF00)),
                          filled: true,
                          fillColor: const Color(0xFF1C1C1C),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                const BorderSide(color: Color(0xFFB7FF00)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:
                                const BorderSide(color: Color(0xFFB7FF00)),
                          ),
                        ),
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        errorMsg: _errorMsg,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please fill in this field';
                          } else if (!RegExp(r'^[A-Za-z]+ [A-Za-z]+$')
                              .hasMatch(val)) {
                            return 'Please enter your first and last name';
                          }
                          return null;
                        }),
                  ),
                  verticalSpacing(10),
                  SizedBox(
                    height: 75,
                    child: MyTextField(
                      controller: _ageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        errorStyle: const TextStyle(height: .8),
                        hintText: 'ex. 20',
                        labelText: "Age",
                        labelStyle: const TextStyle(color: Color(0xFFB7FF00)),
                        filled: true,
                        fillColor: const Color(0xFF1C1C1C),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              const BorderSide(color: Color(0xFFB7FF00)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              const BorderSide(color: Color(0xFFB7FF00)),
                        ),
                      ),
                      obscureText: false,
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon: const Icon(CupertinoIcons.lock_fill),
                      errorMsg: _errorMsg,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please fill in this field';
                        } else if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                          return 'Please enter a valid age';
                        }
                        return null;
                      },
                    ),
                  ),
                  verticalSpacing(10),
                  RawKeyboardListener(
                    focusNode: _heightFocusNode,
                    onKey: (event) {
                      if (event is RawKeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.backspace) {
                        _heightController.clear();
                      }
                    },
                    child: SizedBox(
                      height: 75,
                      child: MyTextField(
                        controller: _heightController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(height: .8),
                          hintText: 'ex. 6\' 2',
                          labelText: "Height",
                          labelStyle: const TextStyle(color: Color(0xFFB7FF00)),
                          filled: true,
                          fillColor: const Color(0xFF1C1C1C),
                          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Color(0xFFB7FF00)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Color(0xFFB7FF00)),
                          ),
                        ),
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        prefixIcon: const Icon(CupertinoIcons.lock_fill),
                        errorMsg: _errorMsg,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please fill in this field';
                          }

                          final regex = RegExp(r"^(\d{1,2})[' ]?\s?(\d{1,2})$");
                          final match = regex.firstMatch(val.trim());

                          if (match == null) {
                            return 'Enter height like 5\' 10 or 5\' 2';
                          }

                          final feet = int.tryParse(match.group(1)!);
                          final inches = int.tryParse(match.group(2)!);

                          if (feet == null || inches == null) {
                            return 'Invalid height values';
                          }

                          if (feet < 4 || feet > 7) {
                            return 'Feet must be between 4 and 7';
                          }

                          if (inches < 0 || inches > 11) {
                            return 'Inches must be between 0 and 11';
                          }

                          return null;
                        },
                        onChanged: (val) {
                          final regex = RegExp(r"^(\d{1,2})[' ]?\s?(\d{1,2})$");
                          final match = regex.firstMatch(val!.trim());

                          if (match != null) {
                            final feet = match.group(1);
                            final inches = match.group(2);
                            final formattedHeight = "$feet' $inches";

                            _heightController.value = TextEditingValue(
                              text: formattedHeight,
                              selection: TextSelection.collapsed(
                                offset: formattedHeight.length,
                              ),
                            );
                          }
                          return null;
                        },
                      ),

                    ),
                  ),
                  verticalSpacing(10),
                  SizedBox(
                    height: 75,
                    child: MyTextField(
                      controller: _weightController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        errorStyle: const TextStyle(height: .8),
                        hintText: '(in lbs) ex. 185 ',
                        labelText: "Weight",
                        labelStyle: const TextStyle(color: Color(0xFFB7FF00)),
                        filled: true,
                        fillColor: const Color(0xFF1C1C1C),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              const BorderSide(color: Color(0xFFB7FF00)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              const BorderSide(color: Color(0xFFB7FF00)),
                        ),
                      ),
                      obscureText: false,
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon: const Icon(CupertinoIcons.lock_fill),
                      errorMsg: _errorMsg,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please fill in this field';
                        } else if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                          return 'Please enter weight';
                        }
                        return null;
                      },
                    ),
                  ),
                  verticalSpacing(10),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xffb7ff00))),
                      padding: const EdgeInsets.only(left: 20),
                      width: screenWidth * .9,
                      height: 63,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          iconEnabledColor: const Color(0xffb7ff00),
                          dropdownColor: const Color(0xFF717171),
                          style: ThemeTextStyles.textFieldInput,
                          value: _dropdownValue,
                          isExpanded: true,
                          hint: Text("Select Sex",
                              style: ThemeTextStyles.textFieldInput),
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
                ],
              ),
            ),
          ),
          verticalSpacing(45),
          SizedBox(
            width: screenWidth * .9,
            height: 70,
            child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Perform async tasks like sending data
                    await FirebaseFirestore.instance.collection("users").add({
                      "first_Name": _nameController.text.split(' ').first,
                      "last_Name": _nameController.text.split(' ').last,
                      "age": _ageController.text,
                      "height": _heightController.text,
                      "weight": _weightController.text,
                      "Sex": _dropdownValue,
                    });

                    // Navigate once complete
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  }
                },
                style: ButtonStyles.colorButton(
                    backgroundColor: const Color(0xffb7ff00),
                    textColor: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                child: const Text("Join STRYKE")),
          ),
          verticalSpacing(5),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'By Continuing you Agree',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                TextSpan(
                  text: ' Terms & Conditions',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFB7FF00),
                    // Green color for Sign Up
                    fontWeight: FontWeight.bold, // Bold style
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
