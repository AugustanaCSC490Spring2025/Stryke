import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/screens/intro/views/info_input_screen.dart';
import 'package:test_app/screens/intro/views/intro_screen.dart';
import 'components/main_navigation.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "STRYKE",
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot.data!.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!userSnapshot.hasData ||
                    !userSnapshot.data!.exists ||
                    (userSnapshot.data!.data() as Map<String, dynamic>).isEmpty) {
                  return const InfoInputScreen(); // Replace with your screen to collect user info
                }

                return const MainNavigation(index: 0); // Home screen
              },
            );
          } else {
            return const IntroScreen();
          }
        },
      ),
    );
  }
}
