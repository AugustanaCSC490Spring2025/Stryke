import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/stat_point.dart';


class LineChartWidget extends StatelessWidget {
  final List<StatPoint> data;

  const LineChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    data.sort((a, b) => a.date.compareTo(b.date));
    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  int index = value.toInt();
                  if (index < 0 || index >= data.length) return const SizedBox();
                  final d = data[index].date;
                  return Text('${d.month}/${d.day}',
                      style: const TextStyle(color: Colors.white, fontSize: 10));
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(data.length,
                      (i) => FlSpot(i.toDouble(), data[i].value)),
              isCurved: true,
              color: Colors.greenAccent,
              barWidth: 3,
              belowBarData: BarAreaData(show: false),
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
