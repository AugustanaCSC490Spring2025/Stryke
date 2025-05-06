 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/metric_box/add_metric_dialog.dart';
import '../../widgets/metric_box/metric_box_builder.dart';
import '../../utils/spacing.dart';
import 'package:test_app/database_services/exercise_service.dart';
import 'package:intl/intl.dart';
import '../../widgets/profile_info_topbar.dart';
import '../../widgets/attendance/workout_checkin.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class MetricEntry {
  final String metricType;
  final String value;
  final String date;

  MetricEntry({
    required this.metricType,
    required this.value,
    required this.date,
  });
}

class _HomePageState extends State<HomePage> {
  User? myUser = FirebaseAuth.instance.currentUser;
  String? weight;
  bool isLoading = true;
  List<MetricEntry> metricEntries = [];
  List metricBoxExercises = [];
  Set<String> addedMetrics = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadGlobalExercises();
  }

  // Function to load user data from Firestore
  Future<void> _loadUserData() async {
    setState(() => isLoading = true);

    QuerySnapshot weightSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(myUser!.uid)
        .collection('Weight')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (weightSnapshot.docs.isNotEmpty) {
      DocumentSnapshot weightDoc = weightSnapshot.docs.first;
      Timestamp timestamp = weightDoc.get('timestamp');
      String date = DateFormat('MM/dd/yyyy').format(timestamp.toDate());
      setState(() {
        weight = weightDoc['value'].toString();
        metricEntries.add(MetricEntry(
          metricType: "Weight",
          value: weight!,
          date: date,
        ));
      });
    }

    setState(() => isLoading = false);
  }

  Future<void> _loadGlobalExercises() async {
    ExerciseServices().fetchGlobalExerciseNames().then((exerciseNames) {
      setState(() {
        metricBoxExercises = exerciseNames;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF1C1C1C),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: CustomScrollView(
        slivers: [
          // HEIGHT BEFORE PROFILE BAR
          SliverToBoxAdapter(child: verticalSpacing(screenHeight * .03)),

          //TOP BAR WITH PROFILE ICON AND USER NAME
          ProfileInfoTopbar(screenWidth: screenWidth, screenHeight: screenHeight, myUser: myUser!),

          SliverToBoxAdapter(child: verticalSpacing(screenHeight * .025)),

          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.05, right: screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WorkoutCheckInCard(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      userId: myUser?.uid,
                    ),
                    verticalSpacing(screenHeight * .02),

                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    verticalSpacing(screenHeight * .02),

                    const Text(
                      "Your Metrics...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),

                    verticalSpacing(screenHeight * .01),

                    ...metricEntries
                        .map((entry) => buildMetricBox(
                            context, entry.metricType, entry.value, entry.date)),

                    // Dynamically add the metric boxes here

                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB7FF00),
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * .35,
                              vertical: screenHeight * .025),
                        ),
                        onPressed: () {
                          showAddMetricDialog(
                            context: context,
                            metricBoxExercises: metricBoxExercises,
                            addedMetrics: addedMetrics,
                            metricEntries: metricEntries,
                            userID: myUser!.uid,
                            refreshState: () => setState(() {}),
                          );
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: Colors.black, size: 25),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              verticalSpacing(screenHeight * .05),
            ]),
          ),
        ],
      ),
    );
  }
}