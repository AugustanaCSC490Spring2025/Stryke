import 'package:fl_chart/fl_chart.dart';

List<FlSpot> spaceClosePoints(List<FlSpot> spots, {double minSpacing = 2.0}) {
  if (spots.isEmpty) return [];

  List<FlSpot> adjusted = [];
  double lastX = -double.infinity;

  for (var spot in spots) {
    double newX = spot.x;
    if ((newX - lastX) < minSpacing) {
      newX = lastX + minSpacing;
    }
    adjusted.add(FlSpot(newX, spot.y));
    lastX = newX;
  }

  return adjusted;
}
