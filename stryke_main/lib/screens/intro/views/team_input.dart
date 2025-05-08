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
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * .125,
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
          const Align(
            alignment: Alignment.center,
            child: Text(
              "STRYKE On!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          verticalSpacing(20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: [
                Text(
                  "Now enter your 5 letter team code!",
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
                  verticalSpacing(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth * .45,
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
                              fontSize: 20),
                          child: const Text("Add Team"),
                        ),
                      ),
                      horizontalSpacing(20),
                      SizedBox(
                        width: screenWidth * .45,
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
                          style: ButtonStyles.colorButton(
                              backgroundColor: const Color(0xffb7ff00),
                              textColor: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          child: const Text("Done"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
