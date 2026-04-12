import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// RssiIndicator — icon tín hiệu BLE
class RssiIndicator extends StatelessWidget {
  final int rssi;
  final bool connected;

  const RssiIndicator({super.key, required this.rssi, required this.connected});

  @override
  Widget build(BuildContext context) {
    if (!connected) {
      return const Icon(Icons.signal_cellular_off, size: 16, color: AppColors.textDim);
    }
    final bars = rssi >= -60 ? 4 : rssi >= -70 ? 3 : rssi >= -80 ? 2 : 1;
    final icon = bars >= 4
        ? Icons.signal_cellular_4_bar
        : bars == 3
            ? Icons.signal_cellular_alt_2_bar
            : Icons.signal_cellular_alt_1_bar;
    return Icon(icon, size: 16, color: AppColors.accent);
  }
}

/// RssiLabel — hiển thị RSSI dBm dạng text
class RssiLabel extends StatelessWidget {
  final int rssi;
  final bool connected;

  const RssiLabel({super.key, required this.rssi, required this.connected});

  @override
  Widget build(BuildContext context) {
    if (!connected) return const SizedBox.shrink();
    return Text(
      '$rssi dBm',
      style: const TextStyle(color: AppColors.textDim, fontSize: 9),
    );
  }
}

/// SignalDots — 4 dot bars hiển thị cường độ tín hiệu
class SignalDots extends StatelessWidget {
  final int rssi;
  final bool connected;

  const SignalDots({super.key, required this.rssi, required this.connected});

  @override
  Widget build(BuildContext context) {
    if (!connected) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(4, (i) => _Bar(height: (i + 1) * 4.0, active: false)),
      );
    }
    final bars = rssi >= -60 ? 4 : rssi >= -70 ? 3 : rssi >= -80 ? 2 : 1;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(
            4,
            (i) => _Bar(height: (i + 1) * 4.0, active: i < bars),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$rssi dBm',
          style: const TextStyle(color: AppColors.textDim, fontSize: 8),
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final bool active;
  const _Bar({required this.height, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: active ? AppColors.accent : AppColors.divider,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
