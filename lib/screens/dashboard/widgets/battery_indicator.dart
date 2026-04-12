import 'package:flutter/material.dart';
import '../../../models/bike_data.dart';
import '../../../theme/app_colors.dart';

/// BatteryIndicator — card pin gradient với SOC%, range, voltage
class BatteryIndicator extends StatelessWidget {
  final BikeData data;

  const BatteryIndicator({super.key, required this.data});

  Color get _barColor {
    final s = data.soc;
    if (s <= 15) return AppColors.danger;
    if (s <= 30) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final soc = data.soc.clamp(0.0, 100.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: SOC% — bar — km còn lại
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SOC %
              _BattIcon(soc: soc, color: _barColor),
              const SizedBox(width: 8),
              Text(
                '${soc.toStringAsFixed(0)}%',
                style: TextStyle(
                  color: _barColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 12),
              // Bar
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Stack(
                    children: [
                      Container(height: 10, color: AppColors.divider),
                      FractionallySizedBox(
                        widthFactor: soc / 100,
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [_barColor.withAlpha(200), _barColor],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Range + voltage
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${data.kmLeft.toStringAsFixed(0)} km',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${data.voltage.toStringAsFixed(1)} V',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Row 2: trạng thái sạc + dòng điện
          Row(
            children: [
              _TagChip(
                icon: data.isCharging ? Icons.bolt : Icons.battery_charging_full,
                label: data.isCharging ? 'Đang sạc' : 'Đang xả',
                color: data.isCharging ? AppColors.success : AppColors.accent,
              ),
              const SizedBox(width: 8),
              _TagChip(
                icon: Icons.electric_bolt,
                label: '${data.current.abs().toStringAsFixed(1)} A',
                color: AppColors.textSecondary,
              ),
              const Spacer(),
              _TagChip(
                icon: Icons.loop,
                label: '${data.cycles} chu kỳ',
                color: AppColors.textDim,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BattIcon extends StatelessWidget {
  final double soc;
  final Color color;
  const _BattIcon({required this.soc, required this.color});

  @override
  Widget build(BuildContext context) {
    final icon = soc > 80
        ? Icons.battery_full
        : soc > 50
            ? Icons.battery_5_bar
            : soc > 20
                ? Icons.battery_3_bar
                : Icons.battery_1_bar;
    return Icon(icon, color: color, size: 22);
  }
}

class _TagChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _TagChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 3),
        Text(label, style: TextStyle(color: color, fontSize: 11)),
      ],
    );
  }
}
