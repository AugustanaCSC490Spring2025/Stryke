import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:test_app/utils/date_getter.dart';

class LineChartWidget extends StatelessWidget {
  final List<FlSpot> spots;
  final String selectedFilter;

  const LineChartWidget({super.key, required this.spots, required this.selectedFilter});

  @override
  Widget build(BuildContext context) {
    if (spots.isEmpty) return const Text('No data to display');

    final xValues = spots.map((s) => s.x).toList();
    final minX = xValues.reduce((a, b) => a < b ? a : b);
    final maxX = xValues.reduce((a, b) => a > b ? a : b);

    int daysInMonth(DateTime date) => DateUtils.getDaysInMonth(date.year, date.month);


    double minXOverride = minX;
    double maxXOverride = maxX;

    if (selectedFilter == 'W') {
      minXOverride = 0;
      maxXOverride = 6;
    } else if (selectedFilter == 'Y') {
      minXOverride = 0;
      maxXOverride = 11;
    } else if (selectedFilter == 'M') {
      minXOverride = 0;
      maxXOverride = daysInMonth(DateTime.now()).toDouble() - 1;
    } else if (selectedFilter == 'D') {
      final earliest = spots.map((s) => s.x).reduce((a, b) => a < b ? a : b);
      final latest = spots.map((s) => s.x).reduce((a, b) => a > b ? a : b);

      minXOverride = (earliest - 5).clamp(0, 1440);
      maxXOverride = (latest + 5).clamp(0, 1440);
    }

    final yValues = spots.map((s) => s.y).toList();
    final rawMinY = yValues.reduce((a, b) => a < b ? a : b);
    final rawMaxY = yValues.reduce((a, b) => a > b ? a : b);

    final minY = (rawMinY - 10).floorToDouble();
    final maxY = (rawMaxY + 10).ceilToDouble();

    final dynamicInterval = (selectedFilter == 'D' || selectedFilter == 'M') && spots.length <= 5
        ? 1.0
        : selectedFilter == 'D' ? 10.0
        : selectedFilter == 'M' ? 5.0
        : selectedFilter == 'W' ? 1.0
        : selectedFilter == 'Y' ? 1.0
        : null;

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          clipData: FlClipData.all(),
          minX: minXOverride,
          maxX: maxXOverride == minXOverride ? minXOverride + 1 : maxXOverride,
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: true,
            horizontalInterval: 5,
            verticalInterval: dynamicInterval,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.white24,
              strokeWidth: 0.5,
            ),
            getDrawingVerticalLine: (value) {
              if (selectedFilter == 'D') {
                final int x = value.toInt();
                final hasTick = spots.any((spot) => spot.x.toInt() == x);
                return hasTick
                    ? FlLine(color: Colors.white30, strokeWidth: 1, dashArray: [2, 12])
                    : FlLine(color: Colors.transparent, strokeWidth: 0);
              }

              return FlLine(color: Colors.white30, strokeWidth: 1, dashArray: [2, 12]);
            },

          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: dynamicInterval,
                getTitlesWidget: (value, _) {
                  String label;

                  switch (selectedFilter) {
                    case 'D':
                      int minutes = value.toInt();
                      int hours24 = minutes ~/ 60;
                      int mins = minutes % 60;
                      int hours12 = hours24 % 12 == 0 ? 12 : hours24 % 12;
                      String period = hours24 >= 12 ? 'PM' : 'AM';

                      bool hasDataAtThisMinute = spots.any((spot) => spot.x.toInt() == minutes);

                      if (!hasDataAtThisMinute) {
                        return const SizedBox.shrink();
                      }

                      label = '$hours12:${mins.toString().padLeft(2, '0')} $period';
                      break;

                    case 'W':
                      label = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][value.toInt().clamp(0, 6)];
                      break;

                    case 'M':
                      int dayOfMonth = value.toInt() + 1;
                      if (value.toInt() % dynamicInterval! != 0) {
                        return const SizedBox.shrink();
                      }
                      String monthName = [
                        '1', '2', '3', '4', '5', '6',
                        '7', '8', '9', '10', '11', '12'
                      ][DateTime.now().month - 1];
                      label = '$monthName/$dayOfMonth';
                      break;

                    case 'Y':
                      label = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][value.toInt().clamp(0, 11)];
                      break;

                    default:
                      label = value.toString();
                  }

                  return Transform.rotate(
                    angle: -0.8,
                    child: Text(
                      label,
                      style: const TextStyle(color: Colors.white, fontSize: 8),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: false,
              color: Colors.limeAccent,
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                show: false,
              ),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 4,
                  color: Colors.limeAccent,
                  strokeWidth: 1,
                  strokeColor: Colors.black,
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(enabled: false),
        ),
      ),
    );
  }
}
