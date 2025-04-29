import 'package:fl_chart/fl_chart.dart';
import '../models/stat_point.dart';
import '../utils/graph_spacer_helper.dart';

List<FlSpot> getDaySpots(List<StatPoint> data, DateTime now) {
  final startDate = DateTime(now.year, now.month, now.day);

  final rawSpots = data.where((point) =>
  point.date.year == now.year &&
      point.date.month == now.month &&
      point.date.day == now.day).map((point) {
    final xValue = point.date.difference(startDate).inMinutes.toDouble();
    return FlSpot(xValue, point.value);
  }).toList();

  return spaceClosePoints(rawSpots, minSpacing: 5.0);
}

