 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/components/exerciseDropDown.dart';
import '../../widgets/add_metric_dialog.dart';
import '../../widgets/metric_box_builder.dart';
import '../../utils/spacing.dart';
import 'package:test_app/database_services/exerciseService.dart';
import 'package:intl/intl.dart';
import '../../widgets/profile_info_topbar.dart';
import '../../widgets/workout_checkin.dart';

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
  List<ExerciseDropdownItem> _exerciseOptions = [];
  ExerciseDropdownItem? _quickAddValue;
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

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(myUser!.uid)
        .get();

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
    final exercises = await ExerciseServices().fetchGlobalExercises();
    ExerciseServices().fetchGlobalExerciseNames().then((exerciseNames) {
      setState(() {
        _exerciseOptions = exercises;
        metricBoxExercises = exerciseNames;
      });
    });
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

          SliverToBoxAdapter(child: verticalSpacing(screenHeight * .035)),

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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     const Text(
                    //       "Quick Add",
                    //       style: TextStyle(color: Colors.white, fontSize: 15),
                    //     ),
                    //   ],
                    // ),
                    // const Padding(padding: EdgeInsets.only(top: 5)),
                    // Container(
                    //   padding: EdgeInsets.all(screenWidth * 0.05),
                    //   decoration: BoxDecoration(
                    //     color: const Color(0xFF303030),
                    //     borderRadius: BorderRadius.circular(20),
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       const SizedBox(width: 5),
                    //       Expanded(
                    //         child: DropdownButton<ExerciseDropdownItem>(
                    //           hint: const Text(
                    //             "Select Exercise: ",
                    //             style: TextStyle(color: Colors.white24),
                    //           ),
                    //           underline: SizedBox(),
                    //           dropdownColor: const Color(0xFF303030),
                    //           value: _quickAddValue,
                    //           icon: const Icon(
                    //             Icons.arrow_drop_down,
                    //             color: Colors.white,
                    //           ),
                    //           iconSize: 30,
                    //           isExpanded: true,
                    //           onChanged: (ExerciseDropdownItem? newValue) {
                    //             setState(() {
                    //               _quickAddValue = newValue;
                    //             });
                    //           },
                    //           items: _exerciseOptions.map((exercise) {
                    //             return DropdownMenuItem<ExerciseDropdownItem>(
                    //               value: exercise,
                    //               child: Text(exercise.name,
                    //                   style:
                    //                       const TextStyle(color: Colors.white)),
                    //             );
                    //           }).toList(),
                    //         ),
                    //       ),
                    //       Container(
                    //           width: 2,
                    //           height: screenWidth * 0.1,
                    //           color: Color(0xFF1C1C1C)),
                    //       const SizedBox(width: 5),
                    //       Expanded(
                    //         child: TextField(
                    //           decoration: InputDecoration(
                    //             hintText: "input here",
                    //             hintStyle: TextStyle(color: Colors.white24),
                    //             border: InputBorder.none,
                    //           ),
                    //           style: TextStyle(color: Colors.white),
                    //         ),
                    //       ),
                    //       IconButton(
                    //         icon:
                    //             const Icon(Icons.add, color: Color(0xFFB7FF00)),
                    //         onPressed: () async {},
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
                          backgroundColor: const Color(0x80B7FF00),
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * .25,
                              vertical: screenHeight * .02),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                                color: Color(0xFFB7FF00), width: 2),
                          ),
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
                            Icon(Icons.add, color: Colors.white70, size: 25),
                            SizedBox(width: 8),  // Space between icon and text
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