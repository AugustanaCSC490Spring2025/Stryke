import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up with email & password
  Future<bool> signUpUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
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
      return true;  // Success, no error
    } on FirebaseAuthException catch (e) {
      return false;  // Return error message
    }
  }

  // Google Sign-In
  Future<bool> googleSignIn() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      print("Google Sign-In successful.");
      return true;
    } catch (e) {
      print("Google Sign-In failed: $e");
      return false;
    }
  }

  // Check if user exists in Firestore
  Future<bool> checkIfUserExists() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.exists;
    } catch (e) {
      print("User existence check failed: $e");
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

  