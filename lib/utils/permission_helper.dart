import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

/// Helper xin các quyền BLE + Notification cần thiết
/// Tương đương MainActivity.checkAndRequestPermissions()
class PermissionHelper {
  PermissionHelper._();

  /// Xin toàn bộ quyền cần thiết, trả về true nếu tất cả OK
  static Future<bool> requestAll() async {
    if (!Platform.isAndroid) return true;

    final permissions = [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.locationWhenInUse,
      Permission.notification,
    ];

    final statuses = await permissions.request();
    return statuses.values.every(
      (s) => s == PermissionStatus.granted || s == PermissionStatus.limited,
    );
  }

  /// Chỉ kiểm tra (không request) — dùng để biết trạng thái hiện tại
  static Future<bool> checkAll() async {
    if (!Platform.isAndroid) return true;

    final scan = await Permission.bluetoothScan.isGranted;
    final connect = await Permission.bluetoothConnect.isGranted;
    return scan && connect;
  }

  /// Mở Settings để user tự cấp quyền (khi bị denied permanently)
  static Future<void> openSettings() async {
    await openAppSettings();
  }
}
