import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/widgets/personal_screen/about_widget.dart';
import 'package:test_app/widgets/personal_screen/faq_widget.dart';
import 'package:test_app/widgets/personal_screen/personal_management_widget.dart';
import '../../auth/google_sign_in/authentication.dart';
import '../../utils/spacing.dart';
import '../../widgets/profile_info_topbar.dart';
import '../intro/views/intro_screen.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({super.key});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  final myUser = FirebaseAuth.instance.currentUser;
  final _authService = Authentication();
  bool isLoading = false;
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();

  String age = '';
  String height = '';
  String weight = '';
  List<String> teamIDs = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    isLoading = true;
    if (myUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(myUser!.uid)
          .get();

      final data = userDoc.data();
      final weightQuery = await FirebaseFirestore.instance
          .collection('users')
          .doc(myUser!.uid)
          .collection('Weight')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      final weightDoc = weightQuery.docs.first;

      if (data != null) {
        setState(() {
          age = data['age'] ?? '';
          height = data['height'] ?? '';
          weight = weightDoc.get('value');
          teamIDs = List<String>.from(data['team_IDs'] ?? []);
        });
      }
    }
    isLoading = false;
  }

  void deleteTeam(String teamId) async {
    final userId = myUser!.uid;
    final teamDocRef = FirebaseFirestore.instance.collection('teams').doc(teamId);
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(userId);

    final teamSnapshot = await teamDocRef.get();
    if (!teamSnapshot.exists) return;

    final teamData = teamSnapshot.data()!;
    final List<dynamic> athleteIDs = teamData['athlete_IDs'] ?? [];
    final List<dynamic> coachIDs = teamData['coach_IDs'] ?? [];

    final updates = <String, dynamic>{};

    if (athleteIDs.contains(userId)) {
      updates['athlete_IDs'] = FieldValue.arrayRemove([userId]);
    }
    if (coachIDs.contains(userId)) {
      updates['coach_IDs'] = FieldValue.arrayRemove([userId]);
      await userDocRef.update({'is_coach': false});
    }

    if (updates.isNotEmpty) {
      await teamDocRef.update(updates);
    }

    // Remove team ID from user's own team list
    await userDocRef.update({
      'team_IDs': FieldValue.arrayRemove([teamId]),
    });

    setState(() {
      teamIDs.remove(teamId);
    });

    Navigator.of(context).pop(); // Close dialog
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF1C1C1C),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: verticalSpacing(screenHeight * .07)),

          //TOP BAR WITH PROFILE ICON AND USER NAME
          ProfileInfoTopbar(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              myUser: myUser!),

          SliverToBoxAdapter(child: verticalSpacing(screenHeight * .025)),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.05, right: screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Basics",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * .022,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        decoration: BoxDecoration(
                          color: const Color(0xFF303030),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  age,
                                  style: TextStyle(
                                    color: const Color(0xFFB7FF00),
                                    fontSize: screenWidth * .03,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Age',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * .02,
                                    fontWeight: FontWeight.bold,
                                ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  height,
                                  style: TextStyle(
                                    color: const Color(0xFFB7FF00),
                                    fontSize: screenWidth * .03,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Height',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * .02,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$weight lbs',
                                  style: TextStyle(
                                    color: const Color(0xFFB7FF00),
                                    fontSize: screenWidth * .03,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Weight',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * .02,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      verticalSpacing(screenHeight * .025),

                      PersonalManagementWidget(
                        teamIDs: teamIDs, 
                        nameController: nameController, 
                        ageController: ageController, 
                        heightController: heightController, 
                        deleteTeam: deleteTeam, 
                        myUser: myUser
                      ),

                      verticalSpacing(screenHeight * .025),
                      // PERSONAL PROGRESS
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.035),
                        decoration: BoxDecoration(
                          color: const Color(0xFF303030),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Navigate",
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            ListTile(
                              leading: const Icon(Icons.exit_to_app,
                                  color: Color(0xFFB7FF00)),
                              title: const Text("Sign Out",
                                  style: TextStyle(color: Colors.white)),
                              onTap: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: const Color(0xFF303030),
                                      title: const Text("Sign Out",
                                          style:
                                          TextStyle(color: Colors.white)),
                                      content: const Text(
                                          "Are you sure you want to sign out?",
                                          style:
                                          TextStyle(color: Colors.white70)),
                                      actionsAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      actions: [
                                        TextButton(
                                          child: const Text("Cancel",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                        ),
                                        TextButton(
                                          child: const Text("Sign Out",
                                              style: TextStyle(
                                                  color: Color(0xFFB7FF00))),
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirm == true) {
                                  await _authService.signOut();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const IntroScreen()),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      verticalSpacing(screenHeight * .025),

                      //Help section container
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.035),
                        decoration: BoxDecoration(
                          color: const Color(0xFF303030),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Help Section",
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),

                            // FAQ and About Dialog Interaction
                            ListTile(
                              leading: const Icon(Icons.question_answer,
                                  color: Color(0xFFB7FF00)),
                              title: const Text("FAQ*",
                                  style: TextStyle(color: Colors.white)),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => FaqWidget()
                                );
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.info_outline,
                                  color: Color(0xFFB7FF00)),
                              title: const Text("About*",
                                  style: TextStyle(color: Colors.white)),
                              onTap: () {
                                showDialog(
                                  context: context, 
                                  builder: (context) => AboutWidget()
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      verticalSpacing(screenHeight * .2)
                    ],
                  ),
                );
              },
              childCount: 1,
            ),
          )
        ],
      ),
    );
  }
}
