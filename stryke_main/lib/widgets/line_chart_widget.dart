import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/stat_point.dart';


class LineChartWidget extends StatelessWidget {
  final List<StatPoint> data;
  final String selectedFilter;

  const LineChartWidget({super.key, required this.data, required this.selectedFilter});

  double getXValue(DateTime start, DateTime pointDate, String selectedFilter) {
    final diff = pointDate.difference(start);
    switch (selectedFilter) {
      case 'D':
        return diff.inMinutes.toDouble();  // Fine granularity
      case 'W':
      case 'M':
        return diff.inHours.toDouble();    // Medium granularity
      case '3M':
      case 'Y':
        return diff.inDays.toDouble();     // Coarser granularity
      default:
        return diff.inHours.toDouble();
    }
  }


  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const Text('No data to display');

    data.sort((a, b) => a.date.compareTo(b.date));
    final startDate = data.first.date;

    final spots = data.map((point) {
      final xValue = getXValue(startDate, point.date, selectedFilter);
      return FlSpot(xValue, point.value);
    }).toList();

    final xValues = spots.map((s) => s.x).toList();
    final minX = xValues.reduce((a, b) => a < b ? a : b);
    final maxX = xValues.reduce((a, b) => a > b ? a : b);

    final yValues = spots.map((s) => s.y).toList();
    final rawMinY = yValues.reduce((a, b) => a < b ? a : b);
    final rawMaxY = yValues.reduce((a, b) => a > b ? a : b);

    final minY = (rawMinY - 10).floorToDouble();
    final maxY = (rawMaxY + 10).ceilToDouble();

    for (var spot in spots) {
      print('Spot x: ${spot.x}, y: ${spot.y}');
    }

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          minX: minX,
          maxX: maxX == minX ? minX + 1 : maxX,
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            horizontalInterval: 5,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.white24,
              strokeWidth: 0.5,
            ),
          ),


        borderData: FlBorderData(
            show: false,
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                  getTitlesWidget: (value, _) {
                    final date = startDate.add(
                        selectedFilter == 'D'
                            ? Duration(minutes: value.floor())
                            : selectedFilter == 'W' || selectedFilter == 'M'
                            ? Duration(hours: value.floor())
                            : Duration(days: value.floor())
                    );

                    String formattedDate;
                    switch (selectedFilter) {
                      case 'D':
                        formattedDate = '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
                        break;
                      case 'W':
                      case 'M':
                        formattedDate = '${date.month}/${date.day}';
                        break;
                      case '3M':
                      case 'Y':
                        formattedDate = '${date.month}/${date.year}';
                        break;
                      default:
                        formattedDate = '${date.month}/${date.day}';
                    }

                    return Text(
                      formattedDate,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    );
                  }
              ),
            ),

            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),  // Round to nearest whole number, you can customize
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  );
                },
              ),
            ),

            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),

            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),

          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: false,
              gradient: LinearGradient(
                colors: [
                  Colors.limeAccent,
                  Colors.greenAccent,
                ],
              ),
              barWidth: 4,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.greenAccent.withOpacity(0.3),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
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
          lineTouchData: LineTouchData(
            enabled: false,
          ),
        ),
      ),
    );
  }
}





