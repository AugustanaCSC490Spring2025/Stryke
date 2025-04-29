import 'package:fl_chart/fl_chart.dart';
import '../models/stat_point.dart';

List<FlSpot> getWeekSpots(List<StatPoint> data, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final startOfWeek = today.subtract(Duration(days: today.weekday - 1));  // Monday
  final endOfWeek = startOfWeek.add(const Duration(days: 6));  // Sunday

  List<FlSpot> spots = [];

  for (int weekday = 1; weekday <= 7; weekday++) {
    final matchingData = data.where((d) {
      final dateOnly = DateTime(d.date.year, d.date.month, d.date.day);

      return dateOnly.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
          dateOnly.isBefore(endOfWeek.add(const Duration(days: 1))) &&
          d.date.weekday == weekday;
    }).toList();

    if (matchingData.isNotEmpty) {
      final avg = matchingData.map((d) => d.value).reduce((a, b) => a + b) / matchingData.length;
      spots.add(FlSpot((weekday - 1).toDouble(), avg));
    }
  }

  return spots;
}
