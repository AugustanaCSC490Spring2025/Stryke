import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../components/my_text_field.dart';
import '../../../utils/button_styles.dart';
import '../../../utils/spacing.dart';
import '../../../utils/text_styles.dart';
import '../../intro/views/team_input.dart';

class InfoInputScreen extends StatefulWidget {
  const InfoInputScreen({super.key});

  @override
  State<InfoInputScreen> createState() => _InfoInputScreenState();
}

class _InfoInputScreenState extends State<InfoInputScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _heightFocusNode = FocusNode();

  String? _errorMsg;
  String? _dropdownValue;

  void dropdownCallback(String? selectedValue) {
    if (selectedValue != null) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
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
                  child: Icon(Icons.electric_bolt_rounded,
                      size: screenHeight * 0.08),
                ),
              ),
              verticalSpacing(screenHeight * 0.03),
              Align(
                alignment: Alignment.center,
                child: const Text(
                  "STRYKE On!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              verticalSpacing(screenHeight * 0.02),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * .05),
                child: const Column(
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
              verticalSpacing(screenHeight * 0.03),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * .05),
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
                              labelStyle:
                                  const TextStyle(color: Color(0xFFB7FF00)),
                              filled: true,
                              fillColor: const Color(0xFF1C1C1C),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xFFB7FF00)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
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
                      verticalSpacing(screenHeight * 0.01),
                      SizedBox(
                        height: 75,
                        child: MyTextField(
                          controller: _ageController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            errorStyle: const TextStyle(height: .8),
                            hintText: 'ex. 20',
                            labelText: "Age",
                            labelStyle:
                                const TextStyle(color: Color(0xFFB7FF00)),
                            filled: true,
                            fillColor: const Color(0xFF1C1C1C),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Color(0xFFB7FF00)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
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
                      verticalSpacing(screenHeight * 0.01),
                      RawKeyboardListener(
                        focusNode: _heightFocusNode,
                        onKey: (event) {
                          if (event is RawKeyDownEvent &&
                              event.logicalKey ==
                                  LogicalKeyboardKey.backspace) {
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
                              labelStyle:
                                  const TextStyle(color: Color(0xFFB7FF00)),
                              filled: true,
                              fillColor: const Color(0xFF1C1C1C),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xFFB7FF00)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Color(0xFFB7FF00)),
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

                              final regex =
                                  RegExp(r"^(\d{1,2})[' ]?\s?(\d{1,2})$");
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
                              final regex =
                                  RegExp(r"^(\d{1,2})[' ]?\s?(\d{1,2})$");
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
                      verticalSpacing(screenHeight * 0.01),
                      SizedBox(
                        height: 75,
                        child: MyTextField(
                          controller: _weightController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            errorStyle: const TextStyle(height: .8),
                            hintText: '(in lbs) ex. 185 ',
                            labelText: "Weight",
                            labelStyle:
                                const TextStyle(color: Color(0xFFB7FF00)),
                            filled: true,
                            fillColor: const Color(0xFF1C1C1C),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: Color(0xFFB7FF00)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
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
                      verticalSpacing(screenHeight * 0.01),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: const Color(0xffb7ff00))),
                          padding: const EdgeInsets.only(left: 20),
                          width: screenWidth * .9,
                          height: 63,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              iconEnabledColor: const Color(0xffb7ff00),
                              dropdownColor: const Color(0xFF1C1C1C),
                              style: ThemeTextStyles.textFieldInput,
                              value: _dropdownValue,
                              isExpanded: true,
                              hint: Text("Select Sex",
                                  style: ThemeTextStyles.textFieldInput),
                              onChanged: dropdownCallback,
                              items: const [
                                DropdownMenuItem(
                                  value: "Male",
                                  child: Text("Male"),
                                ),
                                DropdownMenuItem(
                                  value: "Female",
                                  child: Text("Female"),
                                ),
                                DropdownMenuItem(
                                  value: "Other",
                                  child: Text("Other"),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              verticalSpacing(screenHeight * 0.05),
              SizedBox(
                width: screenWidth * .9,
                height: 70,
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        DocumentSnapshot userDoc = await FirebaseFirestore
                            .instance
                            .collection("users")
                            .doc(user?.uid)
                            .get();

                        if (!userDoc.exists) {
                          // If no data exists for the user, add the user's data
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(user?.uid)
                              .set({
                            "first_Name": _nameController.text.split(' ').first,
                            "last_Name": _nameController.text.split(' ').last,
                            "age": _ageController.text,
                            "height": _heightController.text,
                            "Sex": _dropdownValue,
                          });
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(user?.uid)
                              .collection("Weight")
                              .doc()
                              .set({
                            "value": _weightController.text,
                            "timestamp": DateTime.now(),
                          });
                          await user?.updateDisplayName('${_nameController.text.split(' ').first} ${_nameController.text.split(' ').last}');
                        }

                        // Navigate once complete
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TeamInputScreen()),
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
              verticalSpacing(screenHeight * 0.005),
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
              verticalSpacing(screenHeight * .2),
            ],
          ),
        ),
      ),
    );
  }
}
