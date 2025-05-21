import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app/components/main_navigation.dart';
void handleDeleteMetric({
  required BuildContext context,
  required String userId,
  required String metricName,
}) {
  if (metricName == 'Weight') {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF303030),
          title: const Text("Action Not Allowed", style: TextStyle(color: Colors.white)),
          content: const Text("The 'Weight' metric cannot be deleted.", style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text("OK", style: TextStyle(color: Color(0xFFB7FF00))),
            ),
          ],
        );
      },
    );
    return;
  }

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: const Color(0xFF303030),
        title: const Text("Confirm Delete", style: TextStyle(color: Colors.white)),
        content: Text("Are you sure you want to delete all data for \"$metricName\"?",
            style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                QuerySnapshot snapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection(metricName)
                    .get();

                for (DocumentSnapshot doc in snapshot.docs) {
                  await doc.reference.delete();
                }

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .update({
                  'metric_preferences': FieldValue.arrayRemove([metricName])
                });

                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainNavigation(index: 0),
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete metric: $e')),
                );
              }
            },
          ),
        ],
      );
    },
  );
}
