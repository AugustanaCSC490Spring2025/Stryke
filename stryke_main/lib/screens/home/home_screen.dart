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
  late List<String> preferences;
  List<MetricEntry> metricEntries = [];
  List metricBoxExercises = [];
  Set<String> addedMetrics = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadGlobalExercises();
  }

  // Getting userdata
  Future<void> _loadUserData() async {
    setState(() => isLoading = true);

    final userRef = FirebaseFirestore.instance
      .collection('users')
      .doc(myUser!.uid);

    final userDoc = await userRef.get();

    List<String> prefs;

    if (!userDoc.exists){
      prefs = ['Weight'];
      await userRef.set({
        'metric_preferences' : prefs,
      }); 
    } else {
      final data = userDoc.data()!;
      if (data['metric_preferences'] == null){
        prefs = ['Weight'];
        await userRef.update({
          'metric_preferences' : prefs,
        });
      } else {
        prefs = List<String>.from(data['metric_preferences']);
      }

      setState(() {
        preferences = prefs;
      });
    }
    
   await _loadUserPreferences(preferences);

    setState(() => isLoading = false);
  }

  // Function to load user data from Firestore
  Future<void> _loadUserPreferences(List<String> preferences) async {

    if (preferences.isEmpty){
      preferences.add('Weight');
    }

    for (var collection in preferences){
          QuerySnapshot collectionSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(myUser!.uid)
        .collection(collection)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

      if (collectionSnapshot.docs.isNotEmpty) {
        DocumentSnapshot weightDoc = collectionSnapshot.docs.first;
        Timestamp timestamp = weightDoc.get('timestamp');
        String date = DateFormat('MM/dd/yyyy').format(timestamp.toDate());
        setState(() {
          weight = weightDoc['value'].toString();
          metricEntries.add(MetricEntry(
            metricType: collection,
            value: weight!,
            date: date,
        ));
      });
    }

    }
  }

  Future<void> _loadGlobalExercises() async {
    ExerciseServices().fetchGlobalExerciseNames().then((exerciseNames) {
      setState(() {
        metricBoxExercises = exerciseNames;
      });
    });
  }

  Future<void> _addPreferences() async {
    
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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