import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../database_services/exerciseService.dart';
import '../screens/home/home_screen.dart';
// Import your services and models here

Future<void> showAddMetricDialog({
  required BuildContext context,
  required List metricBoxExercises,
  required Set<String> addedMetrics,
  required List<MetricEntry> metricEntries,
  required String userID,
  required Function refreshState,
}) async {
  String? selectedMetric;
  String? trackedField;
  String? fieldValue;

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF303030),
            title: const Text('Add New Metric',
                style: TextStyle(color: Colors.white, fontSize: 24)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  hint: const Text('Select Metric...',
                      style: TextStyle(color: Colors.white24)),
                  dropdownColor: const Color(0xFF303030),
                  value: selectedMetric,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  underline: const SizedBox(),
                  onChanged: (newValue) async {
                    setState(() {
                      selectedMetric = newValue;
                      trackedField = '';
                      fieldValue = '';
                    });
                    final field = await ExerciseServices().fetchGloabalExerciseTrackedField(newValue!);
                    setState(() {
                      trackedField = field;
                    });
                  },
                  items:
                      metricBoxExercises.map<DropdownMenuItem<String>>((name) {
                    return DropdownMenuItem(
                        value: name,
                        child: Text(name,
                            style: const TextStyle(color: Colors.white)));
                  }).toList(),
                ),
                const SizedBox(height: 10),
                if(selectedMetric != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter $trackedField',
                        hintStyle: const TextStyle(color: Colors.white24),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          fieldValue = value;
                        });
                      },
                    ),
                  ),
                
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (selectedMetric != null) {
                    if (addedMetrics.contains(selectedMetric)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("You already have this metric."),
                            backgroundColor: Colors.red),
                      );
                      return;
                    }
                    final allFieldsFilled = fieldValue!.isNotEmpty;
                    if (!allFieldsFilled) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Fill out all fields for $selectedMetric'),
                            backgroundColor: Colors.red),
                      );
                      return;
                    }

                    await ExerciseServices().addUserExercise(
                      userID: userID,
                      exerciseName: selectedMetric!,
                      value: fieldValue!,
                    );

                    QuerySnapshot snapshot = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userID)
                        .collection(selectedMetric!)
                        .orderBy('timestamp', descending: true)
                        .limit(1)
                        .get();

                    Timestamp timestamp = snapshot.docs.first.get('timestamp');
                    String date = DateFormat('MM/dd/yyyy').format(timestamp.toDate());

                    addedMetrics.add(selectedMetric!);
                    metricEntries.add(MetricEntry(
                        metricType: selectedMetric!,
                        value: fieldValue!,
                        date: date));

                    refreshState(); // Trigger setState in parent
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Add'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    },
  );
}
