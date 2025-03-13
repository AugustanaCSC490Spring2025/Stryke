import 'package:firebase_auth/firebase_auth.dart';

class Authentication{
  void signUpuser(String email, String password) async {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email, 
      password: password,
    );
  }

  void loginUser(String email, String password) async{
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email, 
      password: password
    );
  }
}

  