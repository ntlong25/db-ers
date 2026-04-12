import 'package:flutter/material.dart';
import '../../../models/bike_log_entry.dart';
import 'chart_helpers.dart';

/// PowerChart — biểu đồ 4 series: Voltage, Current, Speed, SOC
class PowerChart extends StatelessWidget {
  final List<BikeLogEntry> logs;
  final Map<String, bool> visible;
  final void Function(String key) onToggle;

  const PowerChart({
    super.key,
    required this.logs,
    required this.visible,
    required this.onToggle,
  });

  static const Map<String, Color> _colors = {
    'Volt': Color(0xFF4FC3F7),
    'Current': Color(0xFFFF7043),
    'Speed': Color(0xFF66BB6A),
    'SOC': Color(0xFFFFCA28),
  };

  @override
  Widget build(BuildContext context) {
    return ChartCard(
      title: 'Điện (V/A) | Tốc độ (km/h) | SOC (%)',
      legend: _colors.entries
          .map((e) => ChartLegendItem(
                label: e.key,
                color: e.value,
                visible: visible[e.key] ?? true,
                onTap: () => onToggle(e.key),
              ))
          .toList(),
      chart: _buildChart(),
    );
  }

  Widget _buildChart() {
    final lines = [
      if (visible['Volt'] ?? true)
        buildChartLine(logs, (e) => e.voltage, _colors['Volt']!),
      if (visible['Current'] ?? true)
        buildChartLine(logs, (e) => e.current, _colors['Current']!),
      if (visible['Speed'] ?? true)
        buildChartLine(logs, (e) => e.speed, _colors['Speed']!),
      if (visible['SOC'] ?? true)
        buildChartLine(logs, (e) => e.soc, _colors['SOC']!),
    ];
    return BikeLineChart(lines: lines, logs: logs);
  }
}
