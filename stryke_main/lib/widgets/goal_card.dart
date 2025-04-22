import 'package:flutter/material.dart';

class GoalProgressWidget extends StatelessWidget {
  final double currentWeight;
  final double goalWeight;
  final VoidCallback onEdit;

  const GoalProgressWidget({
    Key? key,
    required this.currentWeight,
    required this.goalWeight,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine if it's a weight gain or loss goal
    bool isGainGoal = goalWeight >= currentWeight;
    // Check if goal is achieved based on direction
    bool goalAchieved = isGainGoal
        ? currentWeight >= goalWeight
        : currentWeight <= goalWeight;

    // Calculate progress fraction (0.0 to 1.0) for the bar
    double progressFraction;
    if (isGainGoal) {
      progressFraction = currentWeight / goalWeight;
    } else {
      progressFraction = goalWeight / currentWeight;
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
        if (currentWeight < 0.85 * goalWeight) {
          progressColor = Colors.red;
        } else {
          progressColor = Colors.orange;
        }
      } else {
        // Loss goal: check how far above goal
        if (currentWeight > 1.15 * goalWeight) {
          progressColor = Colors.red;
        } else {
          progressColor = Colors.orange;
        }
      }
    }

    // Format the weight values for display (no trailing .0 if not needed)
    String currentStr = currentWeight % 1 == 0
        ? currentWeight.toInt().toString()
        : currentWeight.toStringAsFixed(1);
    String goalStr = goalWeight % 1 == 0
        ? goalWeight.toInt().toString()
        : goalWeight.toStringAsFixed(1);

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
                  color: Colors.limeAccent,
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
                  color: Colors.limeAccent,
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

