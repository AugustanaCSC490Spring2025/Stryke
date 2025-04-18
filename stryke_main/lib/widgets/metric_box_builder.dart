import 'package:flutter/material.dart';
import 'package:test_app/screens/home/input_screen.dart';


Widget buildMetricBox(BuildContext context, String metricType, String value, String date) {
  return GestureDetector(
    onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => InputScreen(metricName: metricType,)
    ),
  );
},
    child: Container(
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
            Text(date, style: TextStyle(color: Colors.white70)),
          ], 
        ),
      ),
    ),
  );
}