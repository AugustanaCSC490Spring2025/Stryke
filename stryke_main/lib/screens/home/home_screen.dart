import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../intro/views/splash_screen.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  final String userName = "Tommy"; // replace with actual name from database

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: true,
            snap: false,
            backgroundColor: const Color(0xFF1C1C1C),
            expandedHeight: 60.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Welcome, $userName!',
                style: const TextStyle(color: Color(0xFFB7FF00), fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Color(0xFFB7FF00)),
                onPressed: () {},
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SplashScreen())),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                    ),
                    const Text(
                      "For Today...",
                      style: TextStyle(color: Color(0xFFB7FF00), fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF303030),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Daily workout", style: TextStyle(color: Color(0xFFB7FF00))),
                          IconButton(
                            icon: const Icon(Icons.add, color: Color(0xFFB7FF00)),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    const Text(
                      "Performance Data",
                      style: TextStyle(color: Color(0xFFB7FF00), fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Container(
                      height: 200,
                      color: const Color(0xFF303030),
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                              belowBarData: BarAreaData(
                                show: true,
                                color: const Color(0x45B7FF00)
                              ),
                              color: const Color(0xFFB7FF00),
                              spots: const[ // insert data from firebase
                                FlSpot(0, 3),
                                FlSpot(1, 5),
                                FlSpot(2, 6),
                                FlSpot(3, 7),
                                FlSpot(4, 7),
                                FlSpot(5, 8),
                                FlSpot(6, 9),
                                FlSpot(7, 10),
                                FlSpot(8, 12),
                                FlSpot(9, 15),
                              ]
                            )
                          ]
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    const Text( // could maybe be bottom navigation bar?
                      "Quick Access",
                      style: TextStyle(color: Color(0xFFB7FF00), fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      leading: const Icon(Icons.flag, color: Color(0xFFB7FF00)),
                      title: const Text("Goals", style: TextStyle(color: Color(0xFFB7FF00))),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: const Icon(Icons.bar_chart, color: Color(0xFFB7FF00)),
                      title: const Text("View Progress", style: TextStyle(color: Color(0xFFB7FF00))),
                      onTap: () {},
                    ),
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
