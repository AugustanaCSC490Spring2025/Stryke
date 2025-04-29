import 'package:flutter/material.dart';

class GoalProgressWidget extends StatelessWidget {
  final double currentGoal;
  final double goalValue;
  final VoidCallback onEdit;

  const GoalProgressWidget({
    Key? key,
    required this.currentGoal,
    required this.goalValue,
    required this.onEdit,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // Determine if it's a weight gain or loss goal
    bool isGainGoal = goalValue >= currentGoal;
    // Check if goal is achieved based on direction
    bool goalAchieved = isGainGoal
        ? currentGoal >= goalValue
        : currentGoal <= goalValue;

    // Calculate progress fraction (0.0 to 1.0) for the bar
    double progressFraction;
    if (isGainGoal) {
      progressFraction = currentGoal / goalValue;
    } else {
      progressFraction = goalValue / currentGoal;
    }
    // Clamp the progress to a maximum of 1.0
    if (progressFraction > 1.0) {
      progressFraction = 1.0;
    }

    // Determine the color of the progress bar based on the 10% rule
    late Color progressColor;
    if (goalAchieved) {
      // Goal reached or surpassed
      progressColor = Colors.yellow;
    } else {
      if (isGainGoal) {
        // Gain goal: check how far below goal
        if (currentGoal < 0.85 * goalValue) {
          progressColor = Colors.red;
        } else {
          progressColor = Colors.orange;
        }
      } else {
        // Loss goal: check how far above goal
        if (currentGoal > 1.15 * goalValue) {
          progressColor = Colors.red;
        } else {
          progressColor = Colors.orange;
        }
      }
    }

    // Format the weight values for display (no trailing .0 if not needed)
    String currentStr = currentGoal % 1 == 0
        ? currentGoal.toInt().toString()
        : currentGoal.toStringAsFixed(1);
    String goalStr = goalValue % 1 == 0
        ? goalValue.toInt().toString()
        : goalValue.toStringAsFixed(1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),                     // dark background
        borderRadius: BorderRadius.circular(12.0),   // rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and optional goal date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Your Goal",
                style: TextStyle(
                  color:  Color(0xFFB7FF00),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          // Current/Goal progress label
          Center(
            child: Text(
              "$currentStr / $goalStr lbs",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 4.0),
          // Progress bar with dynamic color
          ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: LinearProgressIndicator(
              value: progressFraction,
              minHeight: 8.0,
              backgroundColor: Colors.grey.shade700,      // track color behind bar
              valueColor: AlwaysStoppedAnimation<Color>(  // static color for the filled portion
                progressColor,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onEdit,
              child: const Text(
                "edit goal",
                style: TextStyle(
                  color:  Color(0xFFB7FF00),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Optionally, one could place an "edit goal" button or other footer here.
        ],
      ),
    );
  }
}

