import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/database_services/exerciseService.dart';
import 'package:test_app/utils/spacing.dart';
import 'package:test_app/widgets/date_picker_widget.dart';
import 'package:test_app/widgets/line_chart_widget.dart';
import 'package:test_app/database_services/firestore_service.dart';
import 'package:test_app/models/stat_point.dart';

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

  @override
  void initState() {
    super.initState();
    if(widget.metricName == 'Weight'){
      _statData = FirestoreService().fetchStatData(widget.metricName);
    }
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

          // GRAPH
          SliverToBoxAdapter(
            child: FutureBuilder<List<StatPoint>>(
              future: _statData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  print("Snapshot Error: ${snapshot.error}");
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Error loading data: ${snapshot.error}',
                      style: TextStyle(color: Colors.red.shade200),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'No data available yet.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LineChartWidget(data: snapshot.data!),
                  );
                }
              },
              
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpacing(screenHeight * 0.02),

                  // Time Filter Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ['D', 'W', 'M', '3M', 'Y'].map((e) {
                      final isSelected = e == 'W'; // Highlight W
                      return Text(
                        e,
                        style: TextStyle(
                          color: isSelected ? Colors.limeAccent : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04,
                        ),
                      );
                    }).toList(),
                  ),

                  verticalSpacing(screenHeight * 0.02),

                  // Avg Weight
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Avg. ${widget.metricName}: ",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      Text(
                        "165.0",
                        style: TextStyle(
                            color: Colors.limeAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  verticalSpacing(screenHeight * 0.025),

                  // Date & Value Inputs
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date dropdown
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Date:", style: TextStyle(color: Colors.white)),
                            DatePickerDropdown(
                              selectedDate: selectedDate, 
                              onDatePicked: (date){
                                setState(() {
                                  selectedDate = date;
                                });
                              },
                              labelText: "Select workout date",
                            ),
                          ],
                        ),
                        verticalSpacing(screenHeight * 0.015),

                        // Value input + add icon
                        Row(
                          children: [
                            const Text("Value:", style: TextStyle(color: Colors.white)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: valueController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "input here...",
                                  hintStyle:
                                      TextStyle(color: Colors.white.withOpacity(0.5)),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // handle add
                                if(valueController.text.isNotEmpty && selectedDate != null){
                                  if(widget.metricName == 'Weight'){
                                  ExerciseServices().addUserWeight(
                                    userID: myUser!.uid, 
                                    weight: valueController.text, 
                                    date: selectedDate!
                                  );
                                  }else{

                                  }
                                }else{

                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.limeAccent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.add, size: 20),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),

                  verticalSpacing(screenHeight * 0.01),

                  const Text("delete", style: TextStyle(color: Colors.red)),

                  verticalSpacing(screenHeight * 0.03),

                  // Goal Display
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: "Your Goal ",
                                style: TextStyle(color: Colors.limeAccent, fontSize: 16),
                              ),
                              TextSpan(
                                text: "170 ",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              TextSpan(
                                text: "lbs",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text("By: May 24, 2025",
                            style: TextStyle(color: Colors.white70)),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: 165 / 170,
                          backgroundColor: Colors.grey.shade800,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.limeAccent),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              // handle edit goal
                            },
                            child: const Text("edit goal",
                                style: TextStyle(color: Colors.limeAccent)),
                          ),
                        )
                      ],
                    ),
                  ),

                  verticalSpacing(screenHeight * 0.04),

                  verticalSpacing(screenHeight * 0.03),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
