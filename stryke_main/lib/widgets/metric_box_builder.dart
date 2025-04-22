import 'package:flutter/material.dart';
import 'package:test_app/screens/home/input_screen.dart';

Widget buildMetricBox(BuildContext context, String? metricType, String value, String date) {
  return GestureDetector(
    onTap: () {
      final safeMetric = metricType ?? 'Unknown';
      WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InputScreen(metricName: safeMetric),
        ),
      );
      });
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF303030),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: Metric name + Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  metricType ?? 'Unknown',
                  style: const TextStyle(
                    color: Color(0xFFB7FF00),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Bottom row: Value + Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: value.replaceAll(RegExp(r'[^\d]'), ''),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const TextSpan(
                        text: ' lbs',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
