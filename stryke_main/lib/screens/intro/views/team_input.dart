import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<String> joinedTeamCodes = [];

  @override
  void initState() {
    super.initState();
    _loadJoinedTeams();
  }

  Future<void> _loadJoinedTeams() async {
    if (user == null) return;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      final data = userDoc.data() as Map<String, dynamic>?;

      if (data != null && data['team_IDs'] != null) {
        setState(() {
          joinedTeamCodes = List<String>.from(data['team_IDs']);
        });
      }
    } catch (e) {
      print('Error loading team IDs: $e');
    }
  }

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
                    Icon(Icons.electric_bolt_rounded, size: screenHeight * .2),
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
                  verticalSpacing(screenHeight * .03),

                  // ✅ Joined teams box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF303030),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Teams You've Joined:",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (joinedTeamCodes.isEmpty)
                          const Text(
                            "You haven't joined any teams yet.",
                            style: TextStyle(color: Colors.white38),
                          )
                        else
                          ...joinedTeamCodes.map(
                            (team) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                team,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                            ),
                          ),
                      ],
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
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * .025),
                          child: SizedBox(
                            width: screenWidth * 0.7,
                            height: 70,
                            child: ElevatedButton(
                              onPressed: () async {
                                await joinTeam(
                                  formKey: _formKey,
                                  teamKeyController: _teamKeyController,
                                  userId: user!.uid,
                                  setErrorMsg: (msg) {
                                    setState(() {
                                      _errorMsg = msg;
                                    });
                                  },
                                );

                                if (_errorMsg == null || _errorMsg!.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('🎉 You successfully joined the team!'),
                                      backgroundColor: Color(0xFF303030),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  _teamKeyController.clear();
                                  await _loadJoinedTeams(); // ✅ refresh list
                                }
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
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * .1),
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
