import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up with email & password
  Future<bool> signUpUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print("SignUp Error: ${e.message}");
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
    print("User ID: ${user.uid} + 1");
    try {
      final docSnapshot = await _firestore.collection('users')
          .doc(user.uid)
          .get();

      if (!docSnapshot.exists) {
        print("User ID: ${user.uid} + 2");
        return false;
      }

      final data = docSnapshot.data();
      if (data == null || data.isEmpty) {
        print("User ID: ${user.uid} + 3");
        return false;
      }
      print("User ID: ${user.uid} + 4");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkIfUserExists() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        return false;
      }

      final docSnapshot = await FirebaseFirestore.instance.collection('users')
          .doc(user.uid)
          .get();

      if (!docSnapshot.exists) {
        return false;
      }

      return true;
    } catch (e) {
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
}
