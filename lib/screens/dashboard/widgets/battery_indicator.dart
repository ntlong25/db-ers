import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/bike_data.dart';
import '../../../providers/smart_range_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_strings.dart';

/// BatteryIndicator — card pin gradient với SOC%, range, voltage
class BatteryIndicator extends ConsumerWidget {
  final BikeData data;

  const BatteryIndicator({super.key, required this.data});

  Color get _barColor {
    final s = data.soc;
    if (s <= 15) return AppColors.danger;
    if (s <= 30) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soc        = data.soc.clamp(0.0, 100.0);
    final smartAsync = ref.watch(smartRangeProvider);

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
          // Row 1: SOC% ←→ Range (cùng kích cỡ, nổi bật)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── SOC % ──
              _BattIcon(soc: soc, color: _barColor),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${soc.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: _barColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                    ),
                  ),
                  Text(S.battery.remaining,
                      style: const TextStyle(
                          color: AppColors.textDim, fontSize: 9)),
                ],
              ),

              const SizedBox(width: 10),

              // ── Progress bar (giữa) ──
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Stack(
                    children: [
                      Container(height: 8, color: AppColors.divider),
                      FractionallySizedBox(
                        widthFactor: soc / 100,
                        child: Container(
                          height: 8,
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

              const SizedBox(width: 10),

              // ── Smart Range / Firmware Range ──
              smartAsync.when(
                data: (smart) => smart.hasData
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              const Icon(Icons.navigation,
                                  size: 13, color: AppColors.success),
                              const SizedBox(width: 3),
                              Text(
                                '~${smart.predictedKm.toStringAsFixed(0)} km',
                                style: const TextStyle(
                                  color: AppColors.success,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                          Text(S.battery.smartRange,
                              style: const TextStyle(
                                  color: AppColors.success,
                                  fontSize: 9)),
                        ],
                      )
                    : _FirmwareRange(kmLeft: data.kmLeft),
                loading: () => _FirmwareRange(kmLeft: data.kmLeft),
                error: (_, __) => _FirmwareRange(kmLeft: data.kmLeft),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ── Voltage + divider ──
          Row(
            children: [
              const Icon(Icons.electric_bolt,
                  size: 11, color: AppColors.textDim),
              const SizedBox(width: 3),
              Text(
                '${data.voltage.toStringAsFixed(1)} V',
                style: const TextStyle(
                    color: AppColors.textDim, fontSize: 11),
              ),
              // Smart range source hint
              smartAsync.maybeWhen(
                data: (smart) => smart.hasData
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          '(${smart.sessionCount} phiên sạc)',
                          style: const TextStyle(
                              color: AppColors.textDim, fontSize: 9),
                        ),
                      )
                    : const SizedBox.shrink(),
                orElse: () => const SizedBox.shrink(),
              ),
              const Spacer(),
              _TagChip(
                icon: data.isCharging ? Icons.bolt : Icons.battery_charging_full,
                label: data.isCharging ? S.battery.charging : S.battery.discharging,
                color: data.isCharging ? AppColors.success : AppColors.accent,
              ),
              const SizedBox(width: 8),
              _TagChip(
                icon: Icons.electric_bolt,
                label: '${data.current.abs().toStringAsFixed(1)} A',
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
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

class _FirmwareRange extends StatelessWidget {
  final double kmLeft;
  const _FirmwareRange({required this.kmLeft});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${kmLeft.toStringAsFixed(0)} km',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            height: 1.0,
          ),
        ),
        Text(S.battery.firmwareRange,
            style: const TextStyle(color: AppColors.textDim, fontSize: 9)),
      ],
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
