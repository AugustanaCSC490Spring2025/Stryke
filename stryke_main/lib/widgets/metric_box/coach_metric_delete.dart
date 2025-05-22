import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/main_navigation.dart';

void handleRemoveAthleteFromTeam({
  required BuildContext context,
  required String? teamId,
  required String athleteId,
}) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: const Color(0xFF303030),
        title: const Text("Confirm Removal", style: TextStyle(color: Colors.white)),
        content: const Text(
          "Are you sure you want to remove this athlete from the team?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text("Cancel", style: TextStyle(color: Colors.white60)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop(); // Close the dialog
              try {
                final FirebaseFirestore firestore = FirebaseFirestore.instance;

                // 1. Remove athlete from the team document
                await firestore.collection('teams').doc(teamId).update({
                  'athlete_IDs': FieldValue.arrayRemove([athleteId]),
                });

                // 2. Remove team from the athlete's user document
                await firestore.collection('users').doc(athleteId).update({
                  'team_IDs': FieldValue.arrayRemove([teamId]),
                });

                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainNavigation(index: 0)),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to remove athlete: $e')),
                );
              }
            },
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}
