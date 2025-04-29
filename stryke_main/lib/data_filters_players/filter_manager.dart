import 'package:fl_chart/fl_chart.dart';
import '../models/stat_point.dart';
import 'day_filter.dart';
import 'week_filter.dart';
import 'month_filter.dart';
import 'year_filter.dart';

List<FlSpot> getSpotsForFilter(String selectedFilter, List<StatPoint> data) {
  final now = DateTime.now();

  switch (selectedFilter) {
    case 'D':
      return getDaySpots(data, now);
    case 'W':
      return getWeekSpots(data, now);
    case 'M':
      return getMonthSpots(data, now);
    case 'Y':
      return getYearSpots(data, now);
    default:
      return getWeekSpots(data, now);
  }
}
