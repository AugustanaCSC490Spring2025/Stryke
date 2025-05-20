import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up with email & password
  Future<bool> signUpUser(String email, String password, BuildContext context) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print("SignUp Error: ${e.message}");

      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("This email is already registered. Try logging in."),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      return false;
    }
  }

  // Login with email & password
  Future<bool> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true; // Success, no error
    } on FirebaseAuthException catch (e) {
      log("Error: \n $e");
      return false; // Return error message
    }
  }

  // Google Sign-In
  Future<bool> googleSignIn() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      return true;
    } catch (e) {
      return false;
    }
  }


  Future<bool> checkIfUserHasData() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return false;

    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!docSnapshot.exists) {
        print("User doc does not exist for UID: ${user.uid}");
        return false;
      }

      final data = docSnapshot.data();
      if (data == null) {
        print("No data found in user doc: ${user.uid}");
        return false;
      }

      // Check specific fields you require to consider the user profile complete
      final requiredFields = ['first_Name', 'last_Name', 'age', 'height'];
      for (final field in requiredFields) {
        if (data[field] == null || (data[field] is String && (data[field] as String).trim().isEmpty)) {
          print("Missing or empty field '$field' for UID: ${user.uid}");
          return false;
        }
      }

      print("User data is complete for UID: ${user.uid}");
      return true;

    } catch (e) {
      print("Error checking user data: $e");
      return false;
    }
  }


  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print("User signed out.");
    } catch (e) {
      print("Sign out failed: $e");
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final uid = user.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      await user.delete();

      await FirebaseAuth.instance.signOut();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account successfully deleted.'),
          backgroundColor: Color(0xFF303030),
          behavior: SnackBarBehavior.floating,
        ),
      );

    } catch (e) {
      print('Error deleting account: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete account. Try again.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

}
