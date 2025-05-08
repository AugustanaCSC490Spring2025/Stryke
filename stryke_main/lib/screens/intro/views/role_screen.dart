import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../utils/button_styles.dart';
import '../../../utils/spacing.dart';

class RoleInputScreen extends StatefulWidget {
  const RoleInputScreen({Key? key}) : super(key: key);

  @override
  State<RoleInputScreen> createState() => _RoleInputScreenState();
}

class _RoleInputScreenState extends State<RoleInputScreen>{
    final user = FirebaseAuth.instance.currentUser;
    final String coachesKey = "augie_coach";
    String? _selectedRole;
    String? _errorMsg;

    Future<void> _goNext() async{
        setState(() {
            _errorMsg = null;
        });
        try{
            
        }catch (e) {
            setState(() {
                _errorMsg = "Please select a role first";
            });
        }
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
                width: screenWidth * .99,
                child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color(0xFFB7FF00),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                ),
                child: const Icon(Icons.electric_bolt_rounded, size: 100),
                ),
            ),
            verticalSpacing(screenHeight * .05),
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
            verticalSpacing(screenHeight * .05),
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
            verticalSpacing(screenHeight * .05),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    RadioListTile(
                        title: Text('Coach'),
                        value: 'Coach',
                        groupValue: _selectedRole,
                        onChanged: (value) {
                            setState(() {
                                _selectedRole = value;
                            });
                        },
                    ),
                    horizontalSpacing(screenWidth * .05),
                    RadioListTile(
                        title: Text('Athlete'),
                        value: 'Athlete',
                        groupValue: _selectedRole,
                        onChanged: (value) {
                            setState(() {
                                _selectedRole = value;
                            });
                        },
                    ),
                ],
            ),
            verticalSpacing(screenHeight * .05),
            if(_selectedRole == "Coach") ... [
                
            ],
            verticalSpacing(screenHeight * .5),
            SizedBox(
                width: screenWidth * .45,
                height: screenHeight * .075,
                child: ElevatedButton(
                    onPressed:() => _goNext(),
                    style: ButtonStyles.colorButton(
                        backgroundColor: const Color(0xffb7ff00),
                        textColor: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                        child: const Text("Done"),
                ),
            ),


            ],
        )
        )
        );   
    }
}