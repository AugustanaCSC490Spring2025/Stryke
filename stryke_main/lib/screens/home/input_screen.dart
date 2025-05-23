import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/database_services/exercise_service.dart';
import 'package:test_app/utils/spacing.dart';
import 'package:test_app/widgets/date_time_picker_widget.dart';
import 'package:test_app/widgets/line_chart_widget.dart';
import 'package:test_app/database_services/firestore_service.dart';
import 'package:test_app/models/stat_point.dart';
import '../../widgets/goal_card.dart';
import 'package:test_app/data_filters_players/filter_manager.dart';
import '../../widgets/metric_box/metric_box_delete.dart';

class InputScreen extends StatefulWidget {
  final String metricName;

  const InputScreen({super.key, required this.metricName});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  late Future<List<StatPoint>> _statData;
  DateTime? selectedDate;
  final myUser = FirebaseAuth.instance.currentUser;
  final valueController = TextEditingController();
  Map<String, String>? fieldValues;
  String selectedFilter = 'W';
  double goalValue = 0;
  double currentValue = 0;
  bool isGoalLoaded = true;

  @override
  void initState() {
    super.initState();
    _statData = FirestoreService().fetchStatData(widget.metricName);
    loadGoalAndCurrentValue();
  }

  void loadGoalAndCurrentValue() async {
    final fetchedGoal = await ExerciseServices()
        .fetchGoal(userID: myUser!.uid, goalName: widget.metricName);

    QuerySnapshot recentDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(myUser!.uid)
        .collection(widget.metricName)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    String rawVal = recentDoc.docs.first['value'];
    double current = double.tryParse(rawVal) ?? 0;

    //create fetchRecentDoc method?
    setState(() {
      goalValue = fetchedGoal;
      currentValue = current;
      isGoalLoaded = false;
    });
  }

  void _showEditGoalDialog() async {
    TextEditingController controller =
        TextEditingController(text: goalValue.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1C),
        title: const Text("Edit Goal", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Enter new goal",
            hintStyle: TextStyle(color: Colors.white38),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text("Cancel", style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              final input = double.tryParse(controller.text);
              if (input != null && input > 0) {
                setState(() {
                  goalValue = input;
                });
                ExerciseServices().addGoal(
                    userID: myUser!.uid,
                    goalAmount: goalValue.toString(),
                    goalName: widget.metricName);
                Navigator.pop(context); // Close the dialog if you're using one
              } else {
                // Optionally show an error or ignore
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: verticalSpacing(screenHeight * .03)),

          // TOP ROW
          SliverAppBar(
            floating: false,
            pinned: false,
            snap: false,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF1C1C1C),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              title: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white)),
                    horizontalSpacing(20),
                    Text(
                      widget.metricName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenHeight * 0.045,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: verticalSpacing(screenHeight * .03)),


          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpacing(screenHeight * 0.01),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Your Progress Below...",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),

                  verticalSpacing(screenHeight * 0.005),

                  // Graph Container
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        // Time Filter Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: ['D', 'W', 'M', 'Y'].map((e) {
                            final isSelected = e == selectedFilter;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedFilter = e;
                                });
                              },
                              child: Text(
                                e,
                                style: TextStyle(
                                  color: isSelected
                                      ? Color(0xFFB7FF00)
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        verticalSpacing(screenHeight * 0.015),

                        // Graph Widget
                        FutureBuilder<List<StatPoint>>(
                          future: _statData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 40.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            } else if (snapshot.hasError ||
                                !snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: Text(
                                  'No data available',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              );
                            } else {
                              final dataPoints = snapshot.data!;

                              final filteredSpots =
                                  getSpotsForFilter(selectedFilter, dataPoints);

                              if (filteredSpots.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  child: Text(
                                    'No data for this period',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                );
                              }

                              final filteredYValues =
                                  filteredSpots.map((e) => e.y).toList();

                              final average = filteredYValues.isNotEmpty
                                  ? filteredYValues.reduce((a, b) => a + b) /
                                      filteredYValues.length
                                  : 0.0;

                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Avg. ${widget.metricName}: ",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                      Text(
                                        average.toStringAsFixed(1),
                                        // Show 1 decimal place
                                        style: const TextStyle(
                                          color: Color(0xFFB7FF00),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),

                                  verticalSpacing(10),

                                  // Graph
                                  LineChartWidget(
                                      spots: filteredSpots,
                                      selectedFilter: selectedFilter),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  // Input Section
                  verticalSpacing(screenHeight * 0.01),
                  Row(
                    children: [

                      // Date 
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(16),
                            topLeft: Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Date:",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: screenHeight * .025)),
                                DateTimePickerDropdown(
                                  selectedDate: selectedDate,
                                  onDatePicked: (date) {
                                    setState(() {
                                      selectedDate = date;
                                    });
                                  },
                                  labelText: "Select date",
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                  Row(
                    children: [
                      // Value 
                      Expanded(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            border: const Border(
                              right: BorderSide(
                                color: Color(0xFF3A3A3A),
                                width: 1.0,
                              ),
                              top: BorderSide(
                                color: Color(0xFF3A3A3A),
                                width: 1.0,
                              ),
                            ),
                            color: const Color(0xFF2A2A2A),
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(16)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          alignment: Alignment.centerLeft,
                          child: Text("Value:",
                              style:
                                  TextStyle(color: Colors.white, fontSize: screenHeight * .025)),
                        ),
                      ),

                      // Input textField
                      Expanded(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            border: const Border(
                              top: BorderSide(
                                color: Color(0xFF3A3A3A),
                                width: 1.0,
                              ),
                            ),
                            color: const Color(0xFF2A2A2A),
                          ),
                          alignment: Alignment.center,
                          child: TextField(
                            controller: valueController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "input here...",
                              hintStyle: TextStyle(color: Colors.white70),
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                      ),

                      // Add Icon
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          child: Container(
                            height: 60,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFFB7FF00),
                              border: Border.all(color: Color(0xFF3A3A3A)),
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(16)),
                            ),
                            child: const Icon(Icons.add,
                                size: 20, color: Colors.black),
                          ),
                          onTap: () {
                            if (valueController.text.isNotEmpty &&
                                selectedDate != null) {

                              ExerciseServices().addUserEntry(
                                  userID: myUser!.uid,
                                  exerciseName: widget.metricName,
                                  value: valueController.text,
                                  date: selectedDate!
                              );

                              setState(() {
                                _statData = FirestoreService()
                                    .fetchStatData(widget.metricName);
                                valueController.clear();
                                selectedDate = null;
                                loadGoalAndCurrentValue();
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Missing date or value"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  verticalSpacing(screenHeight * 0.01),
                  TextButton(
                    onPressed: () {
                        handleDeleteMetric(
                          context: context, 
                          userId: myUser!.uid, 
                          metricName: widget.metricName);
                    }, 
                    child: const Text("delete", style: TextStyle(color: Colors.red))),

                  verticalSpacing(screenHeight * 0.03),
                  //Goal Piece
                  isGoalLoaded
                      ? const CircularProgressIndicator() //if goal not loaded
                      : GoalProgressWidget(
                          currentGoal: currentValue,
                          goalValue: goalValue,
                          onEdit: _showEditGoalDialog,
                        ),
                  verticalSpacing(screenHeight * 0.2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
