import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../models/bike_log_entry.dart';

/// buildLine — tạo một LineChartBarData từ list logs + getter function
LineChartBarData buildChartLine(
  List<BikeLogEntry> logs,
  double Function(BikeLogEntry) getter,
  Color color,
) {
  final spots = logs
      .asMap()
      .entries
      .map((e) => FlSpot(e.key.toDouble(), getter(e.value)))
      .toList();
  return LineChartBarData(
    spots: spots,
    isCurved: true,
    color: color,
    barWidth: 1.5,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
  );
}

/// ChartCard — container wrapper cho biểu đồ với title + legend
class ChartCard extends StatelessWidget {
  final String title;
  final List<Widget> legend;
  final Widget chart;

  const ChartCard({
    super.key,
    required this.title,
    required this.legend,
    required this.chart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2233),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Color(0xFF4FC3F7),
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Wrap(spacing: 10, runSpacing: 4, children: legend),
          const SizedBox(height: 8),
          chart,
        ],
      ),
    );
  }
}

/// ChartLegendItem — item legend có thể toggle bật/tắt series
class ChartLegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final bool visible;
  final VoidCallback onTap;

  const ChartLegendItem({
    super.key,
    required this.label,
    required this.color,
    required this.visible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: visible ? color : const Color(0xFF444444),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              color: visible ? const Color(0xFFEBEBF5) : const Color(0xFF666666),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

/// BikeLineChart — LineChart chuẩn cho app với style dark theme
class BikeLineChart extends StatelessWidget {
  final List<LineChartBarData> lines;
  final List<BikeLogEntry> logs;

  const BikeLineChart({super.key, required this.lines, required this.logs});

  @override
  Widget build(BuildContext context) {
    if (lines.isEmpty || logs.isEmpty) {
      return const SizedBox(
        height: 160,
        child: Center(
          child: Text('Không có dữ liệu',
              style: TextStyle(color: Color(0xFFAAAAAA))),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          lineBarsData: lines,
          backgroundColor: const Color(0xFF1A1F2E),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                const FlLine(color: Color(0xFF2C2C2E), strokeWidth: 0.5),
          ),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (v, _) => Text(
                  v.toStringAsFixed(0),
                  style: const TextStyle(
                      color: Color(0xFF666666), fontSize: 9),
                ),
              ),
            ),
            topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 18,
                interval: (logs.length / 4)
                    .ceil()
                    .toDouble()
                    .clamp(1, double.infinity),
                getTitlesWidget: (v, _) {
                  final idx = v.toInt().clamp(0, logs.length - 1);
                  final ts = DateTime.fromMillisecondsSinceEpoch(
                      logs[idx].timestamp);
                  return Text(
                    '${ts.hour.toString().padLeft(2, '0')}:'
                    '${ts.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                        color: Color(0xFF666666), fontSize: 8),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => const Color(0xFF2C2C2E),
              getTooltipItems: (spots) => spots
                  .map((s) => LineTooltipItem(
                        s.y.toStringAsFixed(2),
                        TextStyle(color: s.bar.color, fontSize: 10),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
