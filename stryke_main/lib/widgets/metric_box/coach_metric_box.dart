import 'package:flutter/material.dart';

Widget buildCoachMetricBox({
  required BuildContext context,
  required String athleteId,
  required String athleteName,
  required dynamic value,
  required String date,
  required String selectedMetric,
}) {
  final isAttendance = selectedMetric == 'Attendance';

  return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                athleteName,
                style: const TextStyle(
                  color: Color(0xFFB7FF00),
                  fontSize: 20,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isAttendance
                  ? Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: value == '✅' ? Colors.green : Colors.red,
                ),
              )
                  : RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: double.tryParse(value.toString())
                          ?.toStringAsFixed(1) ??
                          '–',
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
  );
}
