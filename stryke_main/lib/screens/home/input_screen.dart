import 'package:flutter/material.dart';
import 'package:test_app/utils/spacing.dart';
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

  @override
  void initState() {
    super.initState();
    _statData = FirestoreService().fetchStatData(widget.metricName);
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
        ],
      ),
    );
  }
}
