import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// BLE State Machine — trạng thái kết nối BLE
/// Sealed class để dart compiler đảm bảo exhaustive switch.
sealed class BleState {
  const BleState();
}

/// Chưa có MAC nào được lưu, chờ user scan
class BleIdle extends BleState {
  const BleIdle();
}

/// Đang quét tìm xe (scan mode)
class BleScanning extends BleState {
  final String? targetMac; // null = scan tất cả, có mac = tìm xe cụ thể
  const BleScanning({this.targetMac});
}

/// Đang kết nối
class BleConnecting extends BleState {
  final String mac;
  const BleConnecting(this.mac);
}

/// Đang negotiate MTU (517 bytes)
class BleNegotiatingMtu extends BleState {
  final BluetoothDevice device;
  const BleNegotiatingMtu(this.device);
}

/// Đang discover services
class BleDiscoveringServices extends BleState {
  final BluetoothDevice device;
  const BleDiscoveringServices(this.device);
}

/// Đã kết nối thành công, đang nhận data
class BleConnected extends BleState {
  final BluetoothDevice device;
  final List<BluetoothService> services;
  const BleConnected(this.device, this.services);
}

/// Đang tự động reconnect (sau khi mất kết nối)
class BleReconnecting extends BleState {
  final String mac;
  final int attempt; // lần thử (1..kMaxReconnectAttempts)
  const BleReconnecting(this.mac, this.attempt);
}

/// Lỗi không thể phục hồi, cần user action
class BleError extends BleState {
  final String message;
  const BleError(this.message);
}

/// Chế độ demo — không có BLE thật, dữ liệu được giả lập
class BleDemoMode extends BleState {
  const BleDemoMode();
}

extension BleStateX on BleState {
  bool get isConnected => this is BleConnected || this is BleDemoMode;
  bool get isDemoMode => this is BleDemoMode;
  bool get isScanning => this is BleScanning;
  bool get isConnecting =>
      this is BleConnecting ||
      this is BleNegotiatingMtu ||
      this is BleDiscoveringServices;
  bool get isReconnecting => this is BleReconnecting;
  bool get isIdle => this is BleIdle;
  bool get isError => this is BleError;

  /// Label hiển thị trên UI
  String get statusLabel => switch (this) {
        BleIdle() => 'Chưa kết nối',
        BleScanning() => 'Đang tìm kiếm...',
        BleConnecting() => 'Đang kết nối...',
        BleNegotiatingMtu() => 'Đang cấu hình...',
        BleDiscoveringServices() => 'Đang khởi động...',
        BleConnected() => 'Đã kết nối',
        BleReconnecting(attempt: final a) => 'Đang kết nối lại ($a)...',
        BleError(message: final m) => 'Lỗi: $m',
        BleDemoMode() => 'Demo Mode',
      };
}
