import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// InfoCard — glass-style card dùng chung trong TechInfo
class InfoCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Color? titleColor;
  final IconData? icon;

  const InfoCard({
    super.key,
    required this.title,
    required this.child,
    this.titleColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final tColor = titleColor ?? AppColors.accent;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: tColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Icon(icon, color: tColor, size: 14),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: TextStyle(
                    color: tColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: tColor.withAlpha(30)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: child,
          ),
        ],
      ),
    );
  }
}
