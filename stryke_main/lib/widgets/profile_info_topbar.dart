import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/google_sign_in/authentication.dart';
import '../screens/home/notification_page.dart';
import '../screens/intro/views/intro_screen.dart';

class ProfileInfoTopbar extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final User myUser;

  const ProfileInfoTopbar(
      {super.key,
      required this.screenWidth,
      required this.screenHeight,
      required this.myUser});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: const Color(0xFF303030),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: const Text(
                        'Account Options',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: const Text(
                        'Choose an action:',
                        style: TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            await Authentication().signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const IntroScreen()),
                            ); // Your method
                          },
                          child: const Text('Sign Out',
                              style: TextStyle(color: Color(0xFFB7FF00))),
                        ),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: const Color(0xFF303030),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  title: const Text(
                                    'Confirm Deletion',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  content: const Text(
                                    'Are you sure you want to delete your account? This action cannot be undone.',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Cancel',
                                          style:
                                              TextStyle(color: Colors.white60)),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await Authentication().deleteAccount(
                                            context);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => const IntroScreen()),
                                        );
                                      },
                                      child: const Text('Delete',
                                          style: TextStyle(
                                              color: Colors.redAccent)),
                                    ),
                                  ],
                                );
                              },
                            );
                            // Make sure this exists
                          },
                          child: const Text('Delete Account',
                              style: TextStyle(color: Colors.redAccent)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel',
                              style: TextStyle(color: Colors.white60)),
                        ),
                      ],
                    );
                  },
                );
              },
              child: CircleAvatar(
                radius: screenWidth * .04,
                backgroundImage: NetworkImage(
                  myUser.photoURL ??
                      'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg',
                ),
              ),
            ),
            SizedBox(width: screenWidth * .03),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${myUser.displayName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * .05,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsPage()),
                );
              },
              icon:
                  const Icon(Icons.notifications_outlined, color: Colors.white),
              iconSize: screenWidth * .05,
            ),
          ],
        ),
      ),
    );
  }
}
