import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../components/main_navigation.dart';
import '../../../components/my_text_field.dart';
import '../../../utils/button_styles.dart';
import '../../../utils/spacing.dart';

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

  Future<void> _joinTeam({bool addAnother = false}) async {
      setState(() {
        _errorMsg = null;
      });

    if (_formKey.currentState!.validate()) {
      String teamCode = _teamKeyController.text.trim().toUpperCase();
      String userId = user!.uid;

      try {
        // Check if the team code exists in Firestore
        QuerySnapshot teamDocQuery = await FirebaseFirestore.instance
            .collection('teams')
            .where('team_Code', isEqualTo: teamCode)
            .get();
        print("here");
        final teamDoc = teamDocQuery.docs.first;
        // Add the user to the team in Firestore
        if (teamDoc['athlete_IDs'].contains(userId)) {
          setState(() {
            _errorMsg = "You are already in this team";
          });
          _formKey.currentState!.validate();
          return;
        }else{        
          await FirebaseFirestore.instance
            .collection('teams')
            .doc(teamDoc.id)
            .update({
          'athlete_IDs': FieldValue.arrayUnion([userId]),
        });
        }

      // Navigate to the next screen or show success message
          setState(() {
            _teamKeyController.clear();
            _errorMsg = null;
          });

      } catch (e) {
        setState(() {
          _errorMsg = "Team code does not exist";
        });
        _formKey.currentState!.validate();
      }
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
            height: screenHeight * .125,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFB7FF00),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
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
                          borderSide: const BorderSide(color: Color(0xFFB7FF00)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Color(0xFFB7FF00)),
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
                        } else{
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
                          onPressed: () => _joinTeam(addAnother: true), 
                          style: ButtonStyles.colorButton(
                            backgroundColor: const Color(0xffb7ff00),
                            textColor: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                          child: const Text("Add Another Team"),),
                      ),
                      horizontalSpacing(20),
                      SizedBox(
                        width: screenWidth * .45,
                        height: 70,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => const MainNavigation(index: 0))), 
                          style: ButtonStyles.colorButton(
                            backgroundColor: const Color(0xffb7ff00),
                            textColor: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                          child: const Text("Done"),),
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
