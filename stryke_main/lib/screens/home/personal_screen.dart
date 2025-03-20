import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
            pinned: true,
            snap: false,
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
                double screenWidth = MediaQuery.of(context).size.width;
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
                                  '20',
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
                                  "5'10''",
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
                                  '165 lbs',
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
                            // "Set Goals" Section
                            ListTile(
                              leading: const Icon(Icons.flag, color: Color(0xFFB7FF00)),
                              title: const Text("Set Goals", style: TextStyle(color: Colors.white)),
                              onTap: () {
                                // Add the navigation or logic for "Set Goals" here
                              },
                            ),
                            // "Goal Reports" Section
                            ListTile(
                              leading: const Icon(Icons.assignment, color: Color(0xFFB7FF00)), // Clipboard icon
                              title: const Text("Goal Reports", style: TextStyle(color: Colors.white)),
                              onTap: () {
                                // Add the navigation or logic for "Goal Reports" here
                              },
                            ),
                            // "Edit Personal Data" Section
                            ListTile(
                              leading: const Icon(Icons.edit, color: Color(0xFFB7FF00)), // Edit icon
                              title: const Text("Edit Personal Data", style: TextStyle(color: Colors.white)),
                              onTap: () {
                                // Add the navigation or logic for "Edit Personal Data" here
                              },
                            ),
                            // "Sign Out" Section
                            ListTile(
                              leading: const Icon(Icons.exit_to_app, color: Color(0xFFB7FF00)), // Sign out icon
                              title: const Text("Sign Out", style: TextStyle(color: Colors.white)),
                              onTap: () async {
                                // Add sign-out logic here
                                await _authService.signOut();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SplashScreen()),
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
                              leading: const Icon(Icons.question_answer, color: Color(0xFFB7FF00)), // Big "I" icon
                              title: const Text("FAQ", style: TextStyle(color: Colors.white)),
                              onTap: () {
                                // Add the navigation or logic for "Get Help Here" here
                              },
                            ),
                            // "About" Section with saved icon
                            ListTile(
                              leading: const Icon(Icons.info_outline, color: Color(0xFFB7FF00)), // Saved icon
                              title: const Text("About", style: TextStyle(color: Colors.white)),
                              onTap: () {
                                // Add the navigation or logic for "About" here
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      verticalSpacing(screenHeight * .15)
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
