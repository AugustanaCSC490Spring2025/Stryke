import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../components/my_text_field.dart';
import '../../../utils/button_styles.dart';
import '../../../utils/spacing.dart';
import '../../../utils/team_join.dart';

class TeamInputScreen extends StatefulWidget {
  const TeamInputScreen({Key? key}) : super(key: key);

  @override
  State<TeamInputScreen> createState() => _TeamInputScreenState();
}

class _TeamInputScreenState extends State<TeamInputScreen> {
  final _teamKeyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;

  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * .35,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFB7FF00),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(40)),
                ),
                child:
                    Icon(Icons.electric_bolt_rounded, size: screenHeight * .22),
              ),
            ),
            verticalSpacing(screenHeight * .035),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Time to Team Up!",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            verticalSpacing(screenHeight * .015),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * .05),
              child: Column(
                children: [
                  Text(
                    "Enter your 5 letter team code below.",
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
              padding: EdgeInsets.symmetric(horizontal: screenWidth * .05),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 75,
                      child: MyTextField(
                        controller: _teamKeyController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(height: .8),
                          hintText: "XXXXX",
                          labelText: "Team Code",
                          labelStyle: const TextStyle(color: Color(0xFFB7FF00)),
                          filled: true,
                          fillColor: const Color(0xFF1C1C1C),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 22.5, horizontal: 20.0),
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
                        errorMsg: _errorMsg,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Please enter a team code";
                          } else if (_errorMsg != null) {
                            return _errorMsg;
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Add Team Button at the top
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * .025),
                          // adjust as needed
                          child: SizedBox(
                            width: screenWidth * 0.7,
                            height: 70,
                            child: ElevatedButton(
                              onPressed: () {
                                joinTeam(
                                  formKey: _formKey,
                                  teamKeyController: _teamKeyController,
                                  userId: user!.uid,
                                  setErrorMsg: (msg) {
                                    setState(() {
                                      _errorMsg = msg;
                                    });
                                  },
                                );
                              },
                              style: ButtonStyles.colorButton(
                                backgroundColor: const Color(0xffb7ff00),
                                textColor: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              child: const Text("Add Team"),
                            ),
                          ),
                        ),

                        verticalSpacing(screenHeight * .005),
                        Text(
                          "This adds a team to your profile.",
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        // Done Button at the very bottom
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * .1),
                          // adjust as needed
                          child: SizedBox(
                            width: screenWidth * 0.7,
                            height: 70,
                            child: ElevatedButton(
                              onPressed: () {
                                goNext(
                                  context: context,
                                  formKey: _formKey,
                                  userId: user!.uid,
                                  setErrorMsg: (msg) {
                                    setState(() {
                                      _errorMsg = msg;
                                    });
                                  },
                                );
                              },
                              style: ButtonStyles.transparentButton(
                                borderColor: const Color(0xffb7ff00),
                                textColor: const Color(0xffb7ff00),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                              child: const Text("Done"),
                            ),
                          ),
                        ),
                        verticalSpacing(screenHeight * .005),
                        Text(
                          "Now continue to the app and enjoy your experience!",
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    verticalSpacing(screenHeight * .2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
