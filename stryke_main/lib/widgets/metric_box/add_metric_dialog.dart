import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:test_app/widgets/date_picker_widget.dart';
import '../../database_services/exercise_service.dart';
import '../../screens/home/home_screen.dart';
import '../../utils/metric_entry.dart';

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
  DateTime? selectedDate;
  bool isLoadingMetric = false;

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
                      isLoadingMetric = true;
                    });
                    final field = await ExerciseServices().fetchGloabalExerciseTrackedField(newValue!);
                    setState(() {
                      trackedField = field;
                    });

                    final snapshot = await ExerciseServices().checkEntry(userID: userID, metricName: selectedMetric!);
                    if(snapshot.docs.isNotEmpty){
                      final doc = snapshot.docs.first;
                      final value = doc.get('value');
                      final timestamp = doc.get('timestamp') as Timestamp;
                      final date = DateFormat('MM/dd/yyyy').format(timestamp.toDate());

                      addedMetrics.add(selectedMetric!);
                      metricEntries.add(MetricEntry(
                        metricType: selectedMetric!, 
                        value: value, 
                        date: date
                      ));

                      refreshState();
                      Navigator.of(context).pop();
                    }else{
                      setState((){
                        isLoadingMetric = false;
                      });
                    }
                    
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
                
                if(isLoadingMetric)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: CircularProgressIndicator(),
                  )
                
                else if(selectedMetric != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: DatePickerDropdown(
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
                      onChanged: (value) {
                        setState(() {
                          fieldValue = value;
                        });
                      },
                    ),
                  ),
                ]  
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (selectedMetric != null) {
                    if (addedMetrics.contains(selectedMetric)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("You already have this displayed."),
                            backgroundColor: Colors.red),
                      );
                      return;
                    }
   
                    if (fieldValue!.isEmpty || selectedDate == null ) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Fill out all fields for $selectedMetric'),
                            backgroundColor: Colors.red),
                      );
                      return;
                    }
                    try {
                    await ExerciseServices().addUserEntry(
                      userID: userID,
                      exerciseName: selectedMetric!,
                      value: fieldValue!,
                      date: selectedDate!
                    );

                    FirebaseFirestore.instance
                    .collection('users')
                    .doc(userID)
                    .update({
                      'metric_preferences' : FieldValue.arrayUnion(['Back Squat']), // HARD CODED IN FIX IN WITH HOME SCREEN
                    });

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

                    refreshState(); 
                    Navigator.of(context).pop();
                    } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error saving preferences: $e')),
                      );
                    }
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