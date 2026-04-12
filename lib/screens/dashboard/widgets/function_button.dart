import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/bike_data.dart';
import '../../../ble/ble_state.dart';
import '../../../theme/app_colors.dart';
import '../../../providers/ble_connection_provider.dart';
import '../../tech_info/tech_info_screen.dart';
import '../../history/history_screen.dart';

/// DashboardButton — nút action đơn
class DashboardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const DashboardButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.accent;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: c.withAlpha(20),
                shape: BoxShape.circle,
                border: Border.all(color: c.withAlpha(80)),
              ),
              child: Icon(icon, color: c, size: 20),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: c.withAlpha(200),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// DashboardBottomBar — thanh điều hướng dưới cùng
class DashboardBottomBar extends ConsumerWidget {
  final BikeData data;
  final BleState bleState;

  const DashboardBottomBar({
    super.key,
    required this.data,
    required this.bleState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          DashboardButton(
            icon: Icons.location_searching,
            label: 'Tìm xe',
            onTap: () => ref.read(gattHandlerProvider)?.findBike(),
            color: AppColors.accent,
          ),
          DashboardButton(
            icon: Icons.analytics_outlined,
            label: 'Kỹ thuật',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TechInfoScreen()),
            ),
          ),
          DashboardButton(
            icon: Icons.show_chart,
            label: 'Lịch sử',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
          DashboardButton(
            icon: Icons.power_settings_new,
            label: 'Ngắt',
            onTap: () => ref.read(bleConnectionProvider.notifier).disconnect(),
            color: AppColors.danger,
          ),
        ],
      ),
    );
  }
}
