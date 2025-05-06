import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../database_services/exercise_service.dart';
import '../../screens/home/home_screen.dart';

Future<void> showAddMetricDialog({
  required BuildContext context,
  required List<String> metricBoxExercises,
  required Set<String> addedMetrics,
  required List<MetricEntry> metricEntries,
  required String userID,
  required VoidCallback refreshState,
}) {
  String? selectedMetric;
  String? fieldValue;
  DateTime selectedDate = DateTime.now();

  return showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF303030),
            title: const Text(
              'Add New Metric',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔽 Pick your metric
                DropdownButton<String>(
                  hint: const Text(
                    'Select Metric...',
                    style: TextStyle(color: Colors.white70),
                  ),
                  dropdownColor: const Color(0xFF303030),
                  value: selectedMetric,
                  onChanged: (val) => setState(() => selectedMetric = val),
                  items: metricBoxExercises
                      .where((m) => !addedMetrics.contains(m))
                      .map((m) => DropdownMenuItem(
                            value: m,
                            child: Text(
                              m,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),

                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Value',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (val) => fieldValue = val,
                ),
                const SizedBox(height: 12),

                GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                      builder: (c, child) => Theme(
                        data: Theme.of(c).copyWith(
                          colorScheme: ColorScheme.dark(
                            primary: const Color(0xFFB7FF00),
                            onPrimary: Colors.black,
                            surface: const Color(0xFF303030),
                            onSurface: Colors.white,
                          ),
                          dialogBackgroundColor: const Color(0xFF303030),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) setState(() => selectedDate = picked);
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white60),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('MM/dd/yyyy').format(selectedDate),
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (selectedMetric != null && fieldValue != null && fieldValue!.isNotEmpty) {
                    await ExerciseServices()
                        .addUserExercise(userID: userID, exerciseName: selectedMetric!, value: fieldValue!, date: selectedDate);

                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userID)
                        .collection('metric_preferences')
                        .doc(selectedMetric!)
                        .set({});

                    QuerySnapshot snap = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userID)
                        .collection(selectedMetric!)
                        .orderBy('timestamp', descending: true)
                        .limit(1)
                        .get();

                    if (snap.docs.isNotEmpty) {
                      var doc = snap.docs.first;
                      Timestamp ts = doc.get('timestamp');
                      String dateFormatted = DateFormat('MM/dd/yyyy').format(ts.toDate());

                      metricEntries.add(
                        MetricEntry(
                          metricType: selectedMetric!,
                          value: fieldValue!,
                          date: dateFormatted,
                        ),
                      );
                      addedMetrics.add(selectedMetric!);
                    }

                    refreshState();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
