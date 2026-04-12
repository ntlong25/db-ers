import 'package:flutter/material.dart';
import '../../../models/bike_log_entry.dart';
import 'chart_helpers.dart';

/// CellChart — biểu đồ Vmin / Vmax / Diff(mV) theo thời gian
class CellChart extends StatelessWidget {
  final List<BikeLogEntry> logs;

  const CellChart({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final lines = [
      buildChartLine(
        logs,
        (e) {
          final cells = e.cellVoltages;
          if (cells.isEmpty) return 0.0;
          return cells.reduce((a, b) => a < b ? a : b);
        },
        const Color(0xFFFFCA28), // vàng = Vmin
      ),
      buildChartLine(
        logs,
        (e) {
          final cells = e.cellVoltages;
          if (cells.isEmpty) return 0.0;
          return cells.reduce((a, b) => a > b ? a : b);
        },
        const Color(0xFF4FC3F7), // xanh = Vmax
      ),
      buildChartLine(
        logs,
        (e) {
          final cells = e.cellVoltages;
          if (cells.isEmpty) return 0.0;
          final vmin = cells.reduce((a, b) => a < b ? a : b);
          final vmax = cells.reduce((a, b) => a > b ? a : b);
          return (vmax - vmin) * 1000; // mV để dễ thấy
        },
        const Color(0xFFEF5350), // đỏ = Diff
      ),
    ];

    return ChartCard(
      title: 'Cell Voltage (V) | Diff (mV)',
      legend: const [
        ChartLegendItem(
            label: 'Vmin', color: Color(0xFFFFCA28), visible: true, onTap: _noop),
        ChartLegendItem(
            label: 'Vmax', color: Color(0xFF4FC3F7), visible: true, onTap: _noop),
        ChartLegendItem(
            label: 'Diff(mV)', color: Color(0xFFEF5350), visible: true, onTap: _noop),
      ],
      chart: BikeLineChart(lines: lines, logs: logs),
    );
  }

  static void _noop() {}
}
