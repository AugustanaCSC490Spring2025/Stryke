import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/stat_point.dart';
import '../../widgets/line_chart_widget.dart';
import '../../data_filters_players/filter_manager.dart';
import '../../utils/spacing.dart';
import '../../widgets/metric_box/coach_metric_delete.dart';

class AthleteMetricDetailPage extends StatefulWidget {
  final String athleteId;
  final String athleteName;
  final String metric;


  const AthleteMetricDetailPage({
    super.key,
    required this.athleteId,
    required this.athleteName,
    required this.metric,
  });

  @override
  State<AthleteMetricDetailPage> createState() => _AthleteMetricDetailPageState();
}

class _AthleteMetricDetailPageState extends State<AthleteMetricDetailPage> {
  String selectedFilter = 'W';
  List<StatPoint> statPoints = [];
  String? teamId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.athleteId)
        .get();

    if (userDoc.exists) {
      final userData = userDoc.data()!;
      final List<dynamic> teamIds = userData['team_IDs'] ?? [];

      if (teamIds.isNotEmpty) {
        teamId = teamIds.first; // use the first team ID, or apply custom logic
      }
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.athleteId)
        .collection(widget.metric)
        .orderBy('timestamp', descending: false)
        .get();

    final points = snapshot.docs.map((doc) {
      final data = doc.data();
      final timestamp = (data['timestamp'] as Timestamp).toDate();
      final rawValue = data['value'];
      final value = rawValue is num
          ? rawValue.toDouble()
          : double.tryParse(rawValue.toString()) ?? 0.0;

      return StatPoint(timestamp, value);
    }).toList();

    setState(() {
      statPoints = points;
    });
  }


  @override
  Widget build(BuildContext context) {
    final filteredSpots = getSpotsForFilter(selectedFilter, statPoints);
    final average = filteredSpots.isNotEmpty
        ? filteredSpots.map((e) => e.y).reduce((a, b) => a + b) / filteredSpots.length
        : 0.0;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: verticalSpacing(screenHeight * 0.03)),
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: false,
            backgroundColor: const Color(0xFF1C1C1C),
            flexibleSpace: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  ),
                  horizontalSpacing(25),
                  Text(
                    '${widget.athleteName} - ${widget.metric}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenHeight * 0.03,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpacing(screenHeight * 0.01),
                  const Text(
                    "Progress Over Time...",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  verticalSpacing(screenHeight * 0.005),

                  // Graph container
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
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
                                  color: isSelected ? const Color(0xFFB7FF00) : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        verticalSpacing(screenHeight * 0.015),
                        if (filteredSpots.isEmpty)
                          const Text(
                            "No data for this period",
                            style: TextStyle(color: Colors.white54),
                          )
                        else
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Avg. ${widget.metric}: ",
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                  Text(
                                    average.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Color(0xFFB7FF00),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              verticalSpacing(10),
                              LineChartWidget(spots: filteredSpots, selectedFilter: selectedFilter),
                            ],
                          ),
                      ],
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      handleRemoveAthleteFromTeam(
                        context: context,
                        teamId: teamId,
                        athleteId: widget.athleteId,
                      );
                    },
                    child: const Text('Remove Athlete', style: TextStyle(color: Colors.red)),
                  ),
                  verticalSpacing(screenHeight * 0.01),


                  const Divider(color: Colors.white24),
                  const Text(
                    "Stat History",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  verticalSpacing(screenHeight * 0.01),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: statPoints.length,
                    itemBuilder: (context, index) {
                      final p = statPoints[index];
                      return ListTile(
                        title: Text('${p.value.toStringAsFixed(1)} lbs',
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text(DateFormat.yMMMMd().format(p.date),
                            style: const TextStyle(color: Colors.white54)),
                      );
                    },
                  ),

                  verticalSpacing(screenHeight * 0.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
