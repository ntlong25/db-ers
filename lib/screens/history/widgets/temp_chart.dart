import 'package:flutter/material.dart';
import '../../../models/bike_log_entry.dart';
import 'chart_helpers.dart';

/// TempChart — biểu đồ 8 series nhiệt độ với toggle visibility
class TempChart extends StatelessWidget {
  final List<BikeLogEntry> logs;
  final Map<String, bool> visible;
  final void Function(String key) onToggle;

  const TempChart({
    super.key,
    required this.logs,
    required this.visible,
    required this.onToggle,
  });

  static const Map<String, Color> _colors = {
    'BalReg': Color(0xFF4FC3F7),
    'FET': Color(0xFFFF7043),
    'NTC1': Color(0xFF66BB6A),
    'NTC2': Color(0xFFAB47BC),
    'NTC3': Color(0xFFFFCA28),
    'NTC4': Color(0xFFEF5350),
    'Motor': Color(0xFFFF8A65),
    'ECU': Color(0xFF26C6DA),
  };

  @override
  Widget build(BuildContext context) {
    return ChartCard(
      title: 'Nhiệt độ (°C)',
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
    final keys = ['BalReg', 'FET', 'NTC1', 'NTC2', 'NTC3', 'NTC4', 'Motor', 'ECU'];
    final getters = [
      (BikeLogEntry e) => e.tempBalanceReg,
      (BikeLogEntry e) => e.tempFet,
      (BikeLogEntry e) => e.tempPin1,
      (BikeLogEntry e) => e.tempPin2,
      (BikeLogEntry e) => e.tempPin3,
      (BikeLogEntry e) => e.tempPin4,
      (BikeLogEntry e) => e.tempMotor,
      (BikeLogEntry e) => e.tempController,
    ];

    final lineBars = [
      for (var i = 0; i < keys.length; i++)
        if (visible[keys[i]] ?? true)
          buildChartLine(logs, getters[i], _colors[keys[i]]!),
    ];

    return BikeLineChart(lines: lineBars, logs: logs);
  }
}
