import 'package:flutter/material.dart';
import '../../../models/bike_data.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/temp_formatter.dart';

/// TempSummaryRow — hàng 4 chip nhiệt độ chính
class TempSummaryRow extends StatelessWidget {
  final BikeData data;

  const TempSummaryRow({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TempChip(label: 'Motor', temp: data.tempMotor),
        const SizedBox(width: 8),
        TempChip(label: 'ECU',   temp: data.tempController),
        const SizedBox(width: 8),
        TempChip(label: 'BMS',   temp: data.tempBms),
        const SizedBox(width: 8),
        TempChip(label: 'FET',   temp: data.tempFet),
      ],
    );
  }
}

/// TempChip — chip nhiệt độ đơn với icon thermometer
class TempChip extends StatelessWidget {
  final String label;
  final double temp;

  const TempChip({super.key, required this.label, required this.temp});

  @override
  Widget build(BuildContext context) {
    final color = _chipColor(temp);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Column(
          children: [
            Icon(Icons.thermostat, size: 14, color: color),
            const SizedBox(height: 3),
            Text(
              TempFormatter.format(temp),
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 9,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _chipColor(double t) {
    if (t >= 80) return AppColors.danger;
    if (t >= 65) return AppColors.warning;
    if (t >= 50) return AppColors.orange;
    return AppColors.textSecondary;
  }
}
