import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  getUser() async {
    if (user == null) {
      return null;
    } else {
      return user;
    }
  }

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

  // Check if user exists in Firestore
  Future<bool> checkIfUserExists() async {
    if (user == null) return false;

    try {
      final docSnapshot = await _firestore.collection('users').doc(user?.uid).get();

      if (!docSnapshot.exists) {
        return false; // Document doesn't exist
      }

      final data = docSnapshot.data();
      if (data == null || data.isEmpty) {
        return false; // Document exists but no data
      }

      return true; // Document exists and has data
    } catch (e) {
      return false; // Error occurred
    }
  }


  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      print("User signed out.");
    } catch (e) {
      print("Sign out failed: $e");
    }
  }
}
