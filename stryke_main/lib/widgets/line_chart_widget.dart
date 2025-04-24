import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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

    double minXOverride = minX;
    double maxXOverride = maxX;

    if (selectedFilter == 'W') {
      minXOverride = 0;
      maxXOverride = 6;
    } else if (selectedFilter == 'Y') {
      minXOverride = 0;
      maxXOverride = 11;
    }

    final yValues = spots.map((s) => s.y).toList();
    final rawMinY = yValues.reduce((a, b) => a < b ? a : b);
    final rawMaxY = yValues.reduce((a, b) => a > b ? a : b);

    final minY = (rawMinY - 10).floorToDouble();
    final maxY = (rawMaxY + 10).ceilToDouble();

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
            verticalInterval: selectedFilter == 'D' ? 10.0 : selectedFilter == 'W' ? 1.0 : selectedFilter == 'M' ? 5.0 : selectedFilter == 'Y' ? 1.0 : null,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.white24,
              strokeWidth: 0.5,
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.white30,
              strokeWidth: 1,
              dashArray: [2, 12],
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: selectedFilter == 'Y' ? 1.0 : selectedFilter == 'M' ? 5.0 : selectedFilter == 'W' ? 1.0 : selectedFilter == 'D' ? 10.0 : null,
                getTitlesWidget: (value, _) {
                  String label;
                  switch (selectedFilter) {
                    case 'D':
                      int totalMinutes = value.toInt();
                      int hours24 = totalMinutes ~/ 60;
                      int minutes = totalMinutes % 60;
                      int hours12 = hours24 % 12 == 0 ? 12 : hours24 % 12;
                      String period = hours24 >= 12 ? 'PM' : 'AM';

                      if (minutes % 10 == 0) {
                        label = '$hours12:${minutes.toString().padLeft(2, '0')} $period';
                      } else {
                        return const SizedBox.shrink();
                      }
                      break;
                    case 'W':
                      label = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][value.toInt().clamp(0, 6)];
                      break;
                    case 'M':
                      int dayOfMonth = value.toInt() + 1;
                      DateTime now = DateTime.now();
                      String monthName = [
                        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                      ][now.month - 1];
                      label = '$monthName $dayOfMonth';
                      break;
                    case 'Y':
                      label = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][value.toInt().clamp(0, 11)];
                      break;

                    default:
                      label = value.toString();
                  }
                  return Text(
                    label,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
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
                show: false,  // Clean look like Apple Health
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
