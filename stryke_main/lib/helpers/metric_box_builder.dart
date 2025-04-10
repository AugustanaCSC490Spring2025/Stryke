import 'package:flutter/material.dart';

Widget buildMetricBox(String metricType, String value) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16.0),
    height: 150,
    decoration: BoxDecoration(
      color: const Color(0xFF303030),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(metricType, style: TextStyle(color: Colors.white)),
              SizedBox(height: 8),
              Text(value,
                  style: TextStyle(color: Colors.white, fontSize: 28)),
            ],
          ),
          Text("Date", style: TextStyle(color: Colors.white70)),
        ],
      ),
    ),
  );
}