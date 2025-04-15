import 'package:flutter/material.dart';

void handleAddMetric({required BuildContext context, required String selectedMetric, required Set<String> addedMetrics,
  required Map<String, String> fieldValues,}) {
  if (addedMetrics.contains(selectedMetric)) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("You already have a $selectedMetric metric displayed."),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }
  final allFieldsFilled = fieldValues.values.every((value) => value.isNotEmpty);
  if (!allFieldsFilled) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You have not filled out $selectedMetric'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }
}
