import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/utils/spacing.dart';
import 'package:test_app/widgets/date_picker_widget.dart';
import 'package:test_app/widgets/line_chart_widget.dart';
import 'package:test_app/database_services/firestore_service.dart';
import 'package:test_app/models/stat_point.dart';

import '../../widgets/goal_card.dart';

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
  TextEditingController? valueController;

  @override
  void initState() {
    super.initState();
    _statData = FirestoreService().fetchStatData(widget.metricName);
  }

  double goalValue = 170;

  void _showEditGoalDialog() {
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
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white)),
                    Text(
                      widget.metricName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                      ),
                      iconSize: 26,
                      onPressed: () {
                        // Notifications
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),


          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
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
                      Text(
                        "edit",
                        style: TextStyle(
                          color: Colors.limeAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  verticalSpacing(screenHeight * 0.015),

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
                          children: ['D', 'W', 'M', '3M', 'Y'].map((e) {
                            final isSelected = e == 'W';
                            return Text(
                              e,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.limeAccent
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.04,
                              ),
                            );
                          }).toList(),
                        ),
                        verticalSpacing(screenHeight * 0.015),

                        // Avg. Label
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Avg. ${widget.metricName}: ",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                            const Text(
                              "165.0",
                              style: TextStyle(
                                  color: Colors.limeAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        verticalSpacing(screenHeight * 0.01),

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
                              return LineChartWidget(data: snapshot.data!);
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
                      // Date Column
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF3A3A3A)),
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
                                const Text("Date:",
                                    style: TextStyle(color: Colors.white)),
                                DatePickerDropdown(
                                  selectedDate: selectedDate,
                                  onDatePicked: (date) {
                                    setState(() {
                                      selectedDate = date;
                                    });
                                  },
                                  LabelText: "Select workout date",
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
                      // Value Column
                      Expanded(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF3A3A3A)),
                            color: const Color(0xFF2A2A2A),
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(16)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.centerLeft,
                          child: const Text("Value:",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),

                      // Input
                      Expanded(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF3A3A3A)),
                            color: const Color(0xFF2A2A2A),
                          ),
                          alignment: Alignment.center,
                          child: TextField(
                            controller: valueController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "input here...",
                              hintStyle: TextStyle(color: Colors.white70),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                      ),



                      // Add Icon
                      Container(
                        height: 60,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.limeAccent,
                          border: Border.all(color: Color(0xFF3A3A3A)),
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(16)),
                        ),
                        child: const Icon(Icons.add,
                            size: 20, color: Colors.black),
                      ),
                    ],
                  ),

                  verticalSpacing(screenHeight * 0.01),
                  const Text("delete", style: TextStyle(color: Colors.red)),

                  verticalSpacing(screenHeight * 0.03),

                  GoalProgressWidget(
                    currentWeight: 120,
                    goalWeight: goalValue,
                    onEdit: _showEditGoalDialog,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
