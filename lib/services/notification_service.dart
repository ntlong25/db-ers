import 'package:flutter_foreground_task/flutter_foreground_task.dart';

/// NotificationService — quản lý notification channels và trạng thái
/// Tương đương NotificationManager trong BikeBackgroundService.java
///
/// Sử dụng: notification channel BLE foreground service đã có trong
/// foreground_service_handler.dart. File này bổ sung:
/// - Notification button cho "Tắt còi" (alarm mute)
/// - Badge notification khi cảnh báo cell
/// - Helper update notification text

class NotificationService {
  static const String _alarmButtonId = 'mute_alarm';

  /// Cập nhật nội dung notification khi đang kết nối xe
  static Future<void> updateConnected({
    required double speed,
    required double soc,
    required String bikeName,
    bool alarmSounding = false,
  }) async {
    final title = alarmSounding
        ? '🚨 CẢNH BÁO — ${bikeName.isNotEmpty ? bikeName : "DTC Bike"}'
        : '${bikeName.isNotEmpty ? bikeName : "DTC Bike"} — ${speed.toStringAsFixed(0)} km/h | 🔋 ${soc.toStringAsFixed(0)}%';

    final text = alarmSounding
        ? 'Còi báo động đang kêu! Nhấn để tắt.'
        : 'Đang giám sát qua Bluetooth';

    if (alarmSounding) {
      // Notification có nút "Tắt còi"
      await FlutterForegroundTask.updateService(
        notificationTitle: title,
        notificationText: text,
        notificationButtons: [
          const NotificationButton(
            id: _alarmButtonId,
            text: 'Tắt còi',
          ),
        ],
      );
    } else {
      await FlutterForegroundTask.updateService(
        notificationTitle: title,
        notificationText: text,
        notificationButtons: [],
      );
    }
  }

  /// Notification khi đang scanning / reconnecting
  static Future<void> updateSearching({String? mac}) async {
    await FlutterForegroundTask.updateService(
      notificationTitle: 'DTC Bike — Đang tìm xe',
      notificationText: mac != null ? 'Đang kết nối lại với $mac' : 'Đang quét Bluetooth...',
    );
  }

  /// Notification khi mất kết nối
  static Future<void> updateDisconnected() async {
    await FlutterForegroundTask.updateService(
      notificationTitle: 'DTC Bike — Chờ kết nối',
      notificationText: 'Sẽ tự động kết nối lại khi xe trong tầm',
    );
  }

  /// Notification cảnh báo cell lệch
  static Future<void> updateCellWarning({
    required double cellDiffMv,
    required String bikeName,
  }) async {
    await FlutterForegroundTask.updateService(
      notificationTitle: '⚠️ Cảnh báo Pin — ${bikeName.isNotEmpty ? bikeName : "DTC Bike"}',
      notificationText: 'Cell lệch ${cellDiffMv.toStringAsFixed(0)} mV — kiểm tra BMS',
    );
  }

  /// Notification cảnh báo tốc độ vượt ngưỡng
  static Future<void> showSpeedAlert({
    required double speed,
    required double threshold,
  }) async {
    await FlutterForegroundTask.updateService(
      notificationTitle:
          '⚠️ Cảnh báo tốc độ: ${speed.toStringAsFixed(0)} km/h',
      notificationText:
          'Vượt ngưỡng ${threshold.toStringAsFixed(0)} km/h — hãy giảm tốc!',
    );
  }
}
