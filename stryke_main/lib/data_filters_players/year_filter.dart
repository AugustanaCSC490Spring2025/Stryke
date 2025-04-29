import 'package:fl_chart/fl_chart.dart';
import '../models/stat_point.dart';

List<FlSpot> getYearSpots(List<StatPoint> data, DateTime now) {
  final startOfYear = DateTime(now.year, 1, 1);
  final endOfYear = DateTime(now.year, 12, 31);

  List<FlSpot> spots = [];

  for (int month = 1; month <= 12; month++) {
    final matchingData = data.where((d) {
      final dateOnly = DateTime(d.date.year, d.date.month, d.date.day);
      return dateOnly.isAfter(startOfYear.subtract(const Duration(seconds: 1))) &&
          dateOnly.isBefore(endOfYear.add(const Duration(days: 1))) &&
          d.date.month == month &&
          d.date.year == now.year;
    }).toList();

    if (matchingData.isNotEmpty) {
      final avg = matchingData.map((d) => d.value).reduce((a, b) => a + b) / matchingData.length;
      spots.add(FlSpot((month - 1).toDouble(), avg));
    }
  }

  return spots;
}

