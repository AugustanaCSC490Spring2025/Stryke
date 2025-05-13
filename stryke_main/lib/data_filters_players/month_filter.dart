import 'package:fl_chart/fl_chart.dart';
import '../models/stat_point.dart';

List<FlSpot> getMonthSpots(List<StatPoint> data, DateTime now) {
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 1).subtract(const Duration(days: 1));
  final daysInMonth = endOfMonth.day;

  final days = List.generate(daysInMonth, (i) => startOfMonth.add(Duration(days: i)));

  List<FlSpot> spots = [];

  for (int index = 0; index < days.length; index++) {
    DateTime day = days[index];

    final List<StatPoint> matchingData = data.where((d) {
      final dateOnly = DateTime(d.date.year, d.date.month, d.date.day);
      return dateOnly.isAtSameMomentAs(day);
    }).toList();

    if (matchingData.isNotEmpty) {
      final avg = matchingData.map((statPoint) => statPoint.value).reduce((a, b) => a + b) / matchingData.length;

      spots.add(FlSpot(index.toDouble(), avg));
    }
  }

  return spots;
}

