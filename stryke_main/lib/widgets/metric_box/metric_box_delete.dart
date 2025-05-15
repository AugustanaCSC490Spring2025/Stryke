import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void handleDeleteMetric({
  required BuildContext context,
  required String userId,
  required String metricName,
}) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: const Color(0xFF303030), // dark background
        title: const Text("Confirm Delete", 
            style: TextStyle(color: Colors.white)),
        content: Text("Are you sure you want to delete all data for \"$metricName\"?", 
            style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // close dialog
            },
          ),
          TextButton(
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Navigator.of(dialogContext).pop(); // close dialog

              try {
                // 1. Delete all documents in metric collection
                QuerySnapshot snapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection(metricName)
                    .get();

                for (DocumentSnapshot doc in snapshot.docs) {
                  await doc.reference.delete();
                }

                // 2. Remove from metrics array in user's main document. Collection ceases to exist if empty
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .update({
                      'metric_preferences': FieldValue.arrayRemove([metricName])
                    });

                // 3. Navigate back to home
                if (context.mounted) {
                  Navigator.of(context).pop();  // pop InputScreen
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
