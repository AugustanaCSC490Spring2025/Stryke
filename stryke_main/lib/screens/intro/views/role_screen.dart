import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../components/main_navigation.dart';
import '../../../components/my_text_field.dart';
import '../../../utils/button_styles.dart';
import '../../../utils/spacing.dart';

class RoleInputScreen extends StatefulWidget {
  const RoleInputScreen({Key? key}) : super(key: key);

  @override
  State<RoleInputScreen> createState() => _RoleInputScreenState();
}

class _RoleInputScreenState extends State<RoleInputScreen>{
    final user = FirebaseAuth.instance.currentUser;

    String? _errorMsg;

    Future<void> _goNext() async{

    }

    @override
    Widget build(BuildContext context) {
      double screenHeight = MediaQuery.of(context).size.height;
      double screenWidth = MediaQuery.of(context).size.width;

      return Scaffold(
        backgroundColor: const Color(0xFF1C1C1C),
        body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            children: [
                SizedBox(
                height: screenHeight * .125,
                child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color(0xFFB7FF00),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                ),
                child: const Icon(Icons.electric_bolt_rounded, size: 100),
                ),
            ),
            verticalSpacing(30),
            const Align(
                alignment: Alignment.center,
                child: Text(
                    "STRYKE On!",
                    style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    ),
                )   ,
            ),
            verticalSpacing(20),
            const Align(
                alignment: Alignment.center,
                child: Text(
                    "Choose Your Role:",
                    style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    ),
                )
            ), 
            ],
        )
        )
        );   
    }
}