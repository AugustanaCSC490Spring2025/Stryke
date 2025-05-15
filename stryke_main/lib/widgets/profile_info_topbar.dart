import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/home/notification_page.dart';

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
            CircleAvatar(
              radius: 22.0,
              backgroundImage: NetworkImage(myUser.photoURL ??
                  'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg'),
            ),
            SizedBox(width: screenWidth * .03),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${myUser.displayName}!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * .035,
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
              iconSize: 26,
            ),
          ],
        ),
      ),
    );
  }
}
