import 'package:flutter_foreground_task/flutter_foreground_task.dart';

/// ForegroundServiceHandler — giữ app sống khi background
/// Tương đương BikeBackgroundService.java + BootReceiver.java
///
/// Kiến trúc quan trọng:
/// - BLE (flutter_blue_plus) PHẢI chạy trong main isolate (MethodChannel constraint)
/// - TaskHandler chạy trong isolate riêng → chỉ dùng để:
///   1. Giữ foreground notification alive
///   2. Gửi heartbeat để biết service còn sống
///
/// Communication: main isolate ↔ task isolate qua sendDataToMain/sendDataToTask

/// Khởi tạo cấu hình ForegroundTask (gọi một lần trong main())
void initForegroundTask() {
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'bike_ble_channel',
      channelName: 'DTC Bike - Kết nối BLE',
      channelDescription: 'Duy trì kết nối BLE với xe Datbike',
      channelImportance: NotificationChannelImportance.LOW,
      priority: NotificationPriority.LOW,
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: true,
      playSound: false,
    ),
    foregroundTaskOptions: ForegroundTaskOptions(
      eventAction: ForegroundTaskEventAction.repeat(5000),
      autoRunOnBoot: true,           // Tương đương BootReceiver.java
      autoRunOnMyPackageReplaced: true,
      allowWakeLock: true,
      allowWifiLock: true,
    ),
  );
}

/// Bắt đầu foreground service (gọi khi connect BLE thành công)
Future<ServiceRequestResult> startForegroundService() {
  return FlutterForegroundTask.startService(
    serviceId: 256,
    notificationTitle: 'DTC Bike đang kết nối',
    notificationText: 'Đang giám sát xe Datbike...',
    callback: _startCallback,
  );
}

/// Cập nhật notification text (gọi khi có data mới)
Future<ServiceRequestResult> updateForegroundNotification({
  required String speed,
  required String soc,
  required String status,
}) {
  return FlutterForegroundTask.updateService(
    notificationTitle: 'DTC Bike — $speed km/h | Pin $soc%',
    notificationText: status,
  );
}

/// Dừng foreground service (gọi khi disconnect)
Future<ServiceRequestResult> stopForegroundService() {
  return FlutterForegroundTask.stopService();
}

/// Gửi command từ main isolate đến task isolate
void sendToService(String command) {
  FlutterForegroundTask.sendDataToTask(command);
}

// ═══════════════════════════════════════════════════════════
// TASK HANDLER (chạy trong background isolate)
// ═══════════════════════════════════════════════════════════

@pragma('vm:entry-point')
void _startCallback() {
  FlutterForegroundTask.setTaskHandler(_BikeTaskHandler());
}

class _BikeTaskHandler extends TaskHandler {
  int _tickCount = 0;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // Task isolate khởi động
    // BLE KHÔNG khởi động ở đây — MethodChannel không available trong isolate
    // Chỉ giữ notification alive và relay commands
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    _tickCount++;
    // Heartbeat → main isolate biết service còn sống
    FlutterForegroundTask.sendDataToMain('heartbeat:$_tickCount');
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    // Service bị kill — main isolate tự detect qua stream
  }

  @override
  void onReceiveData(Object data) {
    final cmd = data.toString();
    if (cmd == 'MUTE_ALARM') {
      FlutterForegroundTask.sendDataToMain('alarm_muted');
    }
  }

  @override
  void onNotificationButtonPressed(String id) {
    if (id == 'mute_alarm') {
      FlutterForegroundTask.sendDataToMain('alarm_muted');
    }
  }
}
