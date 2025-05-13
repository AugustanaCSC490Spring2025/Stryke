import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/main_navigation.dart';

Future<void> goNext({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required String userId,
  required Function(String?) setErrorMsg,
}) async {
  setErrorMsg(null);
  try {
    List<String> coachIDs = [];
    List<String> teamIDs = [];

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    try{
      coachIDs = List.from(userDoc['coach_IDs']);
    }catch (e) {
      coachIDs = [];
      }
    try{
      teamIDs = List.from(userDoc['team_IDs']);
    }
    catch (e) {
      teamIDs = [];
    }

    if (coachIDs.isNotEmpty){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainNavigation(index: 0),
        ),
      );    
    }else if (teamIDs.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainNavigation(index: 0),
        ),
      );
    } else {
      setErrorMsg("Please add a team code first");
      formKey.currentState!.validate();
    }
  } catch (e) {
    setErrorMsg("Please add a team code first");
    formKey.currentState!.validate();
  }
}

Future<void> joinTeam({
  required GlobalKey<FormState> formKey,
  required TextEditingController teamKeyController,
  required String userId,
  required Function(String?) setErrorMsg,
}) async {
  setErrorMsg(null);
  String code = teamKeyController.text.trim().toUpperCase();

  if (formKey.currentState!.validate()) {
    print("here");
    if (code[0] == "C"){
      print("here2");
      try {
        QuerySnapshot coachCodeQuery = await FirebaseFirestore.instance
          .collection('teams')
          .where('coach_Code', isEqualTo: code)
          .get();

        final teamDoc = coachCodeQuery.docs.first;

        if (teamDoc['coaches_IDs'].contains(userId)) {
          setErrorMsg("You are already in this team");
          formKey.currentState!.validate();
          return;
        } else {
          await FirebaseFirestore.instance
              .collection('teams')
              .doc(teamDoc.id)
              .update({
            'coaches_IDs': FieldValue.arrayUnion([userId]),
          });
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .update({
            'team_IDs': FieldValue.arrayUnion([teamDoc.id]),
          });
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .update({'is_Coach': true});
        }
        teamKeyController.clear();
        setErrorMsg(null);

      }catch (e) {
        setErrorMsg("Coach code does not exist");
        formKey.currentState!.validate();
      }
    }
    else {
    try {
      QuerySnapshot teamQuery = await FirebaseFirestore.instance
          .collection('teams')
          .where('team_Code', isEqualTo: code)
          .get();

      final teamDoc = teamQuery.docs.first;

      if (teamDoc['athlete_IDs'].contains(userId)) {
        setErrorMsg("You are already in this team");
        formKey.currentState!.validate();
        return;
      } else {
        await FirebaseFirestore.instance
            .collection('teams')
            .doc(teamDoc.id)
            .update({
          'athlete_IDs': FieldValue.arrayUnion([userId]),
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'team_IDs': FieldValue.arrayUnion([teamDoc.id]),
        });
      }

      teamKeyController.clear();
      setErrorMsg(null);
    } catch (e) {
      setErrorMsg("Team code does not exist");
      formKey.currentState!.validate();
    }
    }
  }else {
    setErrorMsg("Please enter a valid code");
    formKey.currentState!.validate();
  }
}
