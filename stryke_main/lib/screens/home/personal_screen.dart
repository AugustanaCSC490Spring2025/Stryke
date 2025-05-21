import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../auth/google_sign_in/authentication.dart';
import '../../components/main_navigation.dart';
import '../../utils/spacing.dart';
import '../../widgets/profile_info_topbar.dart';
import '../intro/views/intro_screen.dart';
import '../intro/views/team_input.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({super.key});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  final myUser = FirebaseAuth.instance.currentUser;
  final _authService = Authentication();
  bool isLoading = false;
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();

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
                                  "Personal Management",
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),

                            ListTile(
                              leading: const Icon(Icons.add,
                                  color: Color(0xFFB7FF00)),
                              title: const Text("Add Team",
                                  style: TextStyle(color: Colors.white)),
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TeamInputScreen()),
                                );
                              },
                            ),

                            ListTile(
                                leading: const Icon(Icons.assignment,
                                    color: Color(0xFFB7FF00)),
                                // Clipboard icon
                                title: const Text("My Teams",
                                    style: TextStyle(color: Colors.white)),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      print("Loaded teamIDs: $teamIDs");
                                      return AlertDialog(
                                        backgroundColor:
                                            const Color(0xFF303030),
                                        title: const Text('My Teams',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        content: SizedBox(
                                          width: double.maxFinite,
                                          child: teamIDs.isEmpty
                                              ? const Text('No teams.',
                                                  style: TextStyle(
                                                      color: Colors.white70))
                                              : FutureBuilder<List<String>>(
                                                  future: Future.wait(
                                                      teamIDs.map((id) async {
                                                    final doc =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('teams')
                                                            .doc(id)
                                                            .get();
                                                    final data = doc.data();
                                                    return data?['name'] ?? id;
                                                  })),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData)
                                                      return const CircularProgressIndicator();
                                                    final teamNames =
                                                        snapshot.data!;
                                                    return ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          teamNames.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return ListTile(
                                                          title: Text(
                                                              teamNames[index],
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          trailing: IconButton(
                                                            icon: const Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red),
                                                            onPressed: () =>
                                                                deleteTeam(
                                                                    teamIDs[
                                                                        index]),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text('Close',
                                                style: TextStyle(
                                                    color: Color(0xFFB7FF00))),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }),

                            ListTile(
                              leading: const Icon(Icons.edit,
                                  color: Color(0xFFB7FF00)),
                              // Edit icon
                              title: const Text("Edit Personal Data",
                                  style: TextStyle(color: Colors.white)),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: const Color(0xFF303030),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "Edit Personal Data",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            TextFormField(
                                              controller: _nameController,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              keyboardType: TextInputType.name,
                                              decoration: const InputDecoration(
                                                hintText: 'ex. Phil Foden',
                                                labelText: "First & Last name",
                                                labelStyle: TextStyle(
                                                    color: Colors.white38),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white38),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xFFB7FF00)),
                                                ),
                                                errorStyle:
                                                    TextStyle(height: 0.8),
                                              ),
                                              validator: (val) {
                                                if (val == null ||
                                                    val.trim().isEmpty) {
                                                  return 'Please fill in this field';
                                                } else if (!RegExp(
                                                        r'^[A-Za-z]+ [A-Za-z]+$')
                                                    .hasMatch(val.trim())) {
                                                  return 'Please enter your first and last name';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 10),
                                            TextFormField(
                                              controller: _ageController,
                                              // Add this controller in your state
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                labelText: 'Age',
                                                hintText: 'ex. 21',
                                                labelStyle: TextStyle(
                                                    color: Colors.white38),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white38),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xFFB7FF00)),
                                                ),
                                                errorStyle:
                                                    TextStyle(height: 0.8),
                                              ),
                                              validator: (val) {
                                                if (val == null ||
                                                    val.isEmpty) {
                                                  return 'Please enter your age';
                                                } else if (int.tryParse(val) ==
                                                    null) {
                                                  return 'Age must be a number';
                                                }
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 10),
                                            TextFormField(
                                              controller: _heightController,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              keyboardType: TextInputType.text,
                                              decoration: const InputDecoration(
                                                hintText: "ex. 6' 2",
                                                labelText: 'Height',
                                                labelStyle: TextStyle(
                                                    color: Colors.white38),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white38),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xFFB7FF00)),
                                                ),
                                                errorStyle:
                                                    TextStyle(height: 0.8),
                                              ),
                                              onChanged: (val) {
                                                final regex = RegExp(
                                                    r"^(\d{1,2})[' ]?\s?(\d{1,2})$");
                                                final match = regex
                                                    .firstMatch(val.trim());

                                                if (match != null) {
                                                  final feet = int.tryParse(
                                                      match.group(1)!);
                                                  final inches = int.tryParse(
                                                      match.group(2)!);

                                                  if (feet != null &&
                                                      inches != null &&
                                                      feet >= 4 &&
                                                      feet <= 7 &&
                                                      inches >= 0 &&
                                                      inches <= 11) {
                                                    final formatted =
                                                        "$feet' $inches";
                                                    _heightController.value =
                                                        TextEditingValue(
                                                      text: formatted,
                                                      selection: TextSelection
                                                          .collapsed(
                                                              offset: formatted
                                                                  .length),
                                                    );
                                                  }
                                                }
                                              },
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.white70),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    final userId = FirebaseAuth
                                                        .instance
                                                        .currentUser
                                                        ?.uid;
                                                    final name = _nameController
                                                        .text
                                                        .trim();
                                                    final age = _ageController
                                                        .text
                                                        .trim();
                                                    final height =
                                                        _heightController.text
                                                            .trim();

                                                    final nameValid =
                                                        name.contains(' ');
                                                    final ageValid =
                                                        age.isNotEmpty;

                                                    final heightRegex = RegExp(
                                                        r"^(\d{1,2})[' ]?\s?(\d{1,2})$");
                                                    final match = heightRegex
                                                        .firstMatch(height);
                                                    final heightValid = match != null &&
                                                        int.tryParse(match
                                                                .group(1)!) !=
                                                            null &&
                                                        int.tryParse(match
                                                                .group(2)!) !=
                                                            null &&
                                                        int.parse(match.group(1)!) >=
                                                            4 &&
                                                        int.parse(match
                                                                .group(1)!) <=
                                                            7 &&
                                                        int.parse(match
                                                                .group(2)!) >=
                                                            0 &&
                                                        int.parse(match
                                                                .group(2)!) <=
                                                            11;


                                                    if (userId != null &&
                                                        nameValid &&
                                                        ageValid &&
                                                        heightValid) {
                                                      final parts =
                                                          name.split(' ');
                                                      final firstName =
                                                          parts.first;
                                                      final lastName = parts
                                                          .sublist(1)
                                                          .join(' ');

                                                      await myUser?.updateDisplayName("$firstName $lastName");

                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection("users")
                                                          .doc(userId)
                                                          .update({
                                                        "first_Name": firstName,
                                                        "last_Name": lastName,
                                                        "age": age,
                                                        "height": height,
                                                      });

                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => const MainNavigation(index: 1)),
                                                      );

                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                "Please enter valid name, age, and height.")),
                                                      );
                                                    }
                                                  },

                                                  child: const Text(
                                                    "Save",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFFB7FF00)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
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
                            // "Get Help Here" Section
                            ListTile(
                              leading: const Icon(Icons.question_answer,
                                  color: Color(0xFFB7FF00)),
                              title: const Text("FAQ*",
                                  style: TextStyle(color: Colors.white)),
                              onTap: () {
                                //
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.info_outline,
                                  color: Color(0xFFB7FF00)),
                              title: const Text("About*",
                                  style: TextStyle(color: Colors.white)),
                              onTap: () {},
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
