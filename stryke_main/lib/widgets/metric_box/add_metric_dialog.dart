import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:test_app/widgets/date_time_picker_widget.dart';
import '../../database_services/exercise_service.dart';
import '../../utils/metric_entry.dart';

Future<String?> showAddMetricDialog({
  required BuildContext context,
  required List metricBoxExercises,
  required Set<String> addedMetrics,
  required List<MetricEntry> metricEntries,
  required String userID,
}) {
  String? selectedMetric;
  String? trackedField;
  String? fieldValue;
  DateTime? selectedDate;
  bool isLoadingMetric = false;

  return showDialog<String>(
    context: context,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (BuildContext sbContext, StateSetter setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF303030),
            title: const Text(
              'Add New Metric',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  hint: const Text(
                    'Select Metric...',
                    style: TextStyle(color: Colors.white24),
                  ),
                  dropdownColor: const Color(0xFF303030),
                  value: selectedMetric,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  underline: const SizedBox(),
                  onChanged: (newValue) async {
                    setState(() {
                      selectedMetric = newValue;
                      trackedField = null;
                      fieldValue = null;
                      selectedDate = null;
                      isLoadingMetric = true;
                    });
                    // fetch the unit or field label
                    final field = await ExerciseServices()
                        .fetchGloabalExerciseTrackedField(newValue!);
                    setState(() {
                      trackedField = field;
                      isLoadingMetric = false;
                    });
                  },
                  items: metricBoxExercises
                      .map((name) => DropdownMenuItem<String>(
                            value: name,
                            child: Text(name,
                                style: const TextStyle(color: Colors.white)),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 10),
                if (isLoadingMetric)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: CircularProgressIndicator(),
                  )
                else if (selectedMetric != null && trackedField != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: DateTimePickerDropdown(
                      selectedDate: selectedDate,
                      onDatePicked: (date) {
                        setState(() {
                          selectedDate = date;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter $trackedField',
                        hintStyle: const TextStyle(color: Colors.white24),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                      ),
                      onChanged: (value) => fieldValue = value,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  // Validation
                  if (selectedMetric == null) return;
                  if (addedMetrics.contains(selectedMetric)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("You already have this displayed."),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  if (selectedDate == null || fieldValue?.isEmpty == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please pick a date and enter $trackedField'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  try {
                    // Write the new exercise entry
                    await ExerciseServices().addUserEntry(
                      userID: userID,
                      exerciseName: selectedMetric!,
                      value: fieldValue!,
                      date: selectedDate!,
                    );

                    // Append metric_preferences
                    final userRef = FirebaseFirestore.instance
                        .collection('users')
                        .doc(userID);
                    await userRef.set(
                      {
                        'metric_preferences':
                            FieldValue.arrayUnion([selectedMetric]),
                      },
                      SetOptions(merge: true),
                    );

                    // Update local lists
                    addedMetrics.add(selectedMetric!);
                    metricEntries.add(MetricEntry(
                      metricType: selectedMetric!,
                      value: fieldValue!,
                      date: DateFormat('MM/dd/yyyy').format(selectedDate!),
                    ));

                    // Close only the dialog
                    Navigator.of(dialogContext).pop(selectedMetric);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error saving metric: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Add'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(null),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    },
  );
}
