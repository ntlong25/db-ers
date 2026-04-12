import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// TimeFilterBar — thanh chọn ngày + giờ bắt đầu/kết thúc
class TimeFilterBar extends StatelessWidget {
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final VoidCallback onDateTap;
  final VoidCallback onStartTap;
  final VoidCallback onEndTap;

  const TimeFilterBar({
    super.key,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.onDateTap,
    required this.onStartTap,
    required this.onEndTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd/MM/yyyy');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: const Color(0xFF12161F),
      child: Row(
        children: [
          FilterChipButton(
            icon: Icons.calendar_today,
            label: dateFmt.format(date),
            onTap: onDateTap,
          ),
          const SizedBox(width: 6),
          FilterChipButton(
            icon: Icons.access_time,
            label: startTime.format(context),
            onTap: onStartTap,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text('→', style: TextStyle(color: Color(0xFFAAAAAA))),
          ),
          FilterChipButton(
            icon: Icons.access_time,
            label: endTime.format(context),
            onTap: onEndTap,
          ),
        ],
      ),
    );
  }
}

/// FilterChipButton — chip button với icon + label
class FilterChipButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const FilterChipButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, size: 12, color: const Color(0xFF4FC3F7)),
            const SizedBox(width: 4),
            Text(label,
                style: const TextStyle(color: Color(0xFFEBEBF5), fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
