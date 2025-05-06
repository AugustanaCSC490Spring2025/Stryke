import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatDetailScreen extends StatefulWidget {
  final String statKey;
  final String statLabel;

  const StatDetailScreen({required this.statKey, required this.statLabel, Key? key}) : super(key: key);

  @override
  State<StatDetailScreen> createState() => _StatDetailScreenState();
}

class _StatDetailScreenState extends State<StatDetailScreen> {
  List<Map<String, dynamic>> _statHistory = [];

  @override
  void initState() {
    super.initState();
    _loadStatHistory();
  }

  Future<void> _loadStatHistory() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('stats')
        .doc(widget.statKey)
        .collection('history')
        .orderBy('timestamp')
        .get();

    setState(() {
      _statHistory = snapshot.docs
          .map((doc) => {
        'value': doc['value'],
        'timestamp': doc['timestamp'].toDate(),
      })
          .toList();
    });
  }

  void _showEditDialog() {
    final TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C1C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Edit ${widget.statLabel}", style: const TextStyle(color: Colors.white)),
          content: TextField(
            controller: textController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Enter new value",
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.white54)),
            ),
            TextButton(
              onPressed: () async {
                double? value = double.tryParse(textController.text);
                if (value != null) {
                  final uid = FirebaseAuth.instance.currentUser!.uid;
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('stats')
                      .doc(widget.statKey)
                      .collection('history')
                      .add({
                    'value': value,
                    'timestamp': Timestamp.now(),
                  });
                  Navigator.pop(context);
                  _loadStatHistory();
                }
              },
              child: const Text("Save", style: TextStyle(color: Color(0xFFB7FF00))),
            ),
          ],
        );
      },
    );
  }

  List<FlSpot> _generateChartData() {
    return List.generate(_statHistory.length, (index) {
      return FlSpot(index.toDouble(), _statHistory[index]['value']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1C),
        title: Text(widget.statLabel),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFFB7FF00)),
            onPressed: _showEditDialog,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _statHistory.isEmpty
            ? const Center(child: Text("No data yet", style: TextStyle(color: Colors.white54)))
            : LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: _generateChartData(),
                isCurved: true,
                color: const Color(0xFFB7FF00),
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
