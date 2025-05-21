import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/metric_box/add_metric_dialog.dart';
import '../../widgets/metric_box/metric_box_builder.dart';
import 'package:test_app/database_services/exercise_service.dart';
import 'package:intl/intl.dart';
import '../../widgets/profile_info_topbar.dart';
import '../../widgets/attendance/workout_checkin.dart';
import '../../utils/metric_entry.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? myUser = FirebaseAuth.instance.currentUser;
  bool isLoading = true;
  List<String> preferences = [];
  List<MetricEntry> metricEntries = [];
  List<String> metricBoxExercises = [];
  Set<String> addedMetrics = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadGlobalExercises();
  }

  Future<void> _loadUserData() async {
    if (addedMetrics.isNotEmpty) return;

    setState(() => isLoading = true);
    final userRef = FirebaseFirestore.instance.collection('users').doc(myUser!.uid);
    final userDoc = await userRef.get();

    List<String> prefs;
    final data = userDoc.data();
    if (!userDoc.exists || data?['metric_preferences'] == null) {
      prefs = ['Weight'];
      await userRef.set({'metric_preferences': prefs}, SetOptions(merge: true));
    } else {
      prefs = List<String>.from(data!['metric_preferences']);
    }

    setState(() {
      preferences = prefs;
    });

    await _loadUserPreferences();
    setState(() => isLoading = false);
  }

  Future<void> _loadUserPreferences() async {
    metricEntries.clear();
    addedMetrics.clear();

    for (var metric in preferences) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(myUser!.uid)
          .collection(metric)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final value = doc.get('value').toString();
        final ts = doc.get('timestamp') as Timestamp;
        final date = DateFormat('MM/dd/yyyy').format(ts.toDate());
        metricEntries.add(MetricEntry(metricType: metric, value: value, date: date));
        addedMetrics.add(metric);
      }
    }
  }

Future<void> _loadGlobalExercises() async {
  final rawList = await ExerciseServices().fetchGlobalExerciseNames();
  //Puts list into alphabetical order
  final List<String> names = rawList.cast<String>()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  setState(() {
    metricBoxExercises = names;
  });
}

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: screenHeight * .07)),
          ProfileInfoTopbar(screenWidth: screenWidth, screenHeight: screenHeight, myUser: myUser!),
          SliverToBoxAdapter(child: SizedBox(height: screenHeight * .025)),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * .05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //Check In Widget 
                    WorkoutCheckInCard(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      userId: myUser?.uid,
                    ),

                    SizedBox(height: screenHeight * .02),
                    Divider(color: Colors.white24, thickness: 1),
                    SizedBox(height: screenHeight * .02),
                    const Text('Your Metrics...', style: TextStyle(color: Colors.white, fontSize: 15)),
                    SizedBox(height: screenHeight * .01),

                    //Add Metric Boxes with streambuilder to always update new data  
                    ...preferences.map((entry){
                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('users').doc(myUser!.uid)
                          .collection(entry)
                          .orderBy('timestamp', descending: true)
                          .limit(1)
                          .snapshots(), 

                        builder: (context, snapshot){
                          if(!snapshot.hasData){
                            return CircularProgressIndicator();
                          }
                          final doc = snapshot.data!.docs.first;
                          final value = doc['value'];
                          final timestamp = (doc['timestamp'] as Timestamp).toDate();
                          final dateStr = DateFormat('MM/dd/yyyy').format(timestamp);

                          //Build actual metric boxes
                          return buildMetricBox(context, entry, value, dateStr);
                        },
                      );
                    }),

                    //Metric Boxes on Tap functionality 
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB7FF00),
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * .35,
                              vertical: screenHeight * .025),
                        ),
                        onPressed: () async {
                          final newMetric = await showAddMetricDialog(
                            context: context,
                            metricBoxExercises: metricBoxExercises,
                            addedMetrics: addedMetrics,
                            metricEntries: metricEntries,
                            userID: myUser!.uid,
                          );
                          if (newMetric == null) return;

                          // Append preference in Firestore
                          final userRef = FirebaseFirestore.instance.collection('users').doc(myUser!.uid);
                          await userRef.update({
                            'metric_preferences': FieldValue.arrayUnion([newMetric]),
                          });

                          setState(() {
                            preferences.add(newMetric);
                          });
                        },
                        child: const Icon(Icons.add, color: Colors.black, size: 25),
                      ),
                    ),
                    SizedBox(height: screenHeight * .2),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
