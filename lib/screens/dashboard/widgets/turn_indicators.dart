import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// TurnIndicatorIcon — icon xi nhan đơn (trái hoặc phải)
/// Hiển thị to, blink cam sáng + glow khi active
class TurnIndicatorIcon extends StatelessWidget {
  final bool active;
  final String label;

  const TurnIndicatorIcon({
    super.key,
    required this.active,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: active ? AppColors.green : AppColors.textDim,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

/// TurnIndicatorPair — cặp xi nhan nhỏ (dùng trong TopBar)
class TurnIndicatorPair extends StatelessWidget {
  final bool leftActive;
  final bool rightActive;
  final bool blinkOn;

  const TurnIndicatorPair({
    super.key,
    required this.leftActive,
    required this.rightActive,
    required this.blinkOn,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TurnIndicatorIcon(active: leftActive && blinkOn, label: '◄'),
        const SizedBox(width: 4),
        TurnIndicatorIcon(active: rightActive && blinkOn, label: '►'),
      ],
    );
  }
}

/// BigTurnArrow — mũi tên xi nhan lớn, đặt hai bên gauge
/// Double-chevron to, blink với glow cam khi active
class BigTurnArrow extends StatelessWidget {
  final bool isLeft;
  final bool active; // đã tính sẵn blinkOn bên ngoài

  const BigTurnArrow({
    super.key,
    required this.isLeft,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final icon = isLeft
        ? Icons.keyboard_double_arrow_left
        : Icons.keyboard_double_arrow_right;

    return SizedBox(
      width: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon với glow effect khi active
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow
              Icon(icon, size: 64, color: active
                  ? AppColors.green.withAlpha(40)
                  : Colors.transparent),
              // Mid glow
              Icon(icon, size: 52, color: active
                  ? AppColors.green.withAlpha(80)
                  : Colors.transparent),
              // Main icon
              Icon(icon, size: 44,
                color: active ? AppColors.green : AppColors.textDim,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
