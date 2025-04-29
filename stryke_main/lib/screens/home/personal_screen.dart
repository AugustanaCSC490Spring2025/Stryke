import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../auth/google_sign_in/authentication.dart';
import '../../components/main_navigation.dart';
import '../../utils/spacing.dart';
import '../intro/views/splash_screen.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({super.key});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  final myUser = FirebaseAuth.instance.currentUser;
  final _authService = Authentication();

  String age = '';
  String height = '';
  String weight = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    if (myUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(myUser!.uid)
          .get();
        final weightQuery = await FirebaseFirestore.instance.collection('users').doc(myUser!.uid)
          .collection('Weight').
          orderBy('timestamp', descending: true)
          .limit(1).get();
        final weightDoc = weightQuery.docs.first;
      final data = userDoc.data();
      if (data != null) {
        setState(() {
          age = data['age'] ?? '';
          height = data['height'] ?? '';
          weight = weightDoc.get('value');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: verticalSpacing(screenHeight * .07)),
          //TOP BAR WITH PROFILE ICON AND USER NAME
          SliverAppBar(
            floating: false,
            pinned: false,
            snap: false,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF1C1C1C),
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.05),
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage(myUser!.photoURL ??
                            'https://example.com/default-avatar.png'),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.03,
                            right: screenWidth * 0.02),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // User's Name (white)
                            Text(
                              myUser!.displayName ?? 'User',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.02),
                      child: IconButton(
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: verticalSpacing(screenHeight * .02)),

          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Basics",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "edit",
                            style: TextStyle(
                              color: const Color(0xFFB7FF00),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
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
                                  style: const TextStyle(
                                    color: Color(0xFFB7FF00),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Age',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  height,
                                  style: const TextStyle(
                                    color: Color(0xFFB7FF00),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Height',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$weight lbs',
                                  style: const TextStyle(
                                    color: Color(0xFFB7FF00),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Weight',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
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
                                  "Personal Progress",
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            ListTile(
                              leading: Icon(Icons.show_chart,
                                  color: Color(0xFFB7FF00)),
                              title: Text("My Progress",
                                  style: TextStyle(color: Colors.white)),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MainNavigation(index: 1)),
                                );
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
                                  "Personal Management",
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),

                            ListTile(
                              leading: const Icon(Icons.flag, color: Color(0xFFB7FF00)),
                              title: const Text("Set Goals", style: TextStyle(color: Colors.white)),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MainNavigation(index: 2)),
                                );
                              },
                            ),

                            ListTile(
                              leading: const Icon(Icons.assignment, color: Color(0xFFB7FF00)), // Clipboard icon
                              title: const Text("Goal Reports", style: TextStyle(color: Colors.white)),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MainNavigation(index: 2)),
                                );
                              },
                            ),

                            ListTile(
                              leading: const Icon(Icons.edit, color: Color(0xFFB7FF00)), // Edit icon
                              title: const Text("Edit Personal Data", style: TextStyle(color: Colors.white)),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: const Color(0xFF303030),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                                            const TextField(
                                              decoration: InputDecoration(
                                                labelText: 'Age',
                                                labelStyle: TextStyle(color: Colors.white38),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white38),
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xFFB7FF00)),
                                                ),
                                              ),
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            const SizedBox(height: 10),
                                            const TextField(
                                              decoration: InputDecoration(
                                                labelText: 'Height',
                                                labelStyle: TextStyle(color: Colors.white38),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white38),
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xFFB7FF00)),
                                                ),
                                              ),
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            const SizedBox(height: 10),
                                            const TextField(
                                              decoration: InputDecoration(
                                                labelText: 'Weight',
                                                labelStyle: TextStyle(color: Colors.white38),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.white38),
                                                ),
                                                focusedBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xFFB7FF00)),
                                                ),
                                              ),
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text(
                                                    "Cancel",
                                                    style: TextStyle(color: Colors.white70),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(); // Placeholder for save action
                                                  },
                                                  child: const Text(
                                                    "Save",
                                                    style: TextStyle(color: Color(0xFFB7FF00)),
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
                            // "Sign Out" Section
                            ListTile(
                              leading: const Icon(Icons.exit_to_app, color: Color(0xFFB7FF00)),
                              title: const Text("Sign Out", style: TextStyle(color: Colors.white)),
                              onTap: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: const Color(0xFF303030),
                                      title: const Text("Sign Out", style: TextStyle(color: Colors.white)),
                                      content: const Text("Are you sure you want to sign out?",
                                          style: TextStyle(color: Colors.white70)),
                                      actionsAlignment: MainAxisAlignment.spaceEvenly,
                                      actions: [
                                        TextButton(
                                          child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                                          onPressed: () => Navigator.of(context).pop(false),
                                        ),
                                        TextButton(
                                          child: const Text("Sign Out", style: TextStyle(color: Color(0xFFB7FF00))),
                                          onPressed: () => Navigator.of(context).pop(true),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirm == true) {
                                  await _authService.signOut();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SplashScreen()),
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
                              leading: const Icon(Icons.question_answer, color: Color(0xFFB7FF00)),
                              title: const Text("FAQ*", style: TextStyle(color: Colors.white)),
                              onTap: () {
                                //
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.info_outline, color: Color(0xFFB7FF00)),
                              title: const Text("About*", style: TextStyle(color: Colors.white)),
                              onTap: () {

                              },
                            ),
                          ],
                        ),
                      ),
                      
                      verticalSpacing(screenHeight * .05)
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
