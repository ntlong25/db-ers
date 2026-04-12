import 'package:flutter/material.dart';

/// TempFormatter — color coding cho nhiệt độ
/// Tương đương logic màu trong TechInfoActivity.java
class TempFormatter {
  TempFormatter._();

  /// Màu text/icon dựa theo nhiệt độ
  static Color colorFor(double temp) {
    if (temp >= 60) return const Color(0xFFFF5252);   // Đỏ — nguy hiểm
    if (temp >= 45) return const Color(0xFFFFB74D);   // Cam — cảnh báo
    return const Color(0xFFEBEBF5);                    // Trắng — bình thường
  }

  /// Background color cho cell card khi có cảnh báo
  static Color? bgColorFor(double temp) {
    if (temp >= 60) return const Color(0x44FF5252);
    if (temp >= 45) return const Color(0x22FFB74D);
    return null;
  }

  /// Format chuỗi nhiệt độ, bao gồm ký hiệu °C
  static String format(double temp) {
    if (temp == 0.0) return '--';
    return '${temp.toStringAsFixed(1)}°C';
  }
}
