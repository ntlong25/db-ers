import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bike_data.dart';
import '../parsers/dashboard_parser.dart';
import '../parsers/json_parser.dart';
import '../parsers/lock_parser.dart';

/// Provider cho BikeData — single source of truth toàn app.
/// Mọi màn hình watch provider này để nhận data real-time.
final bikeDataProvider =
    StateNotifierProvider<BikeDataNotifier, BikeData>((ref) {
  return BikeDataNotifier();
});

/// Notifier cập nhật BikeData immutable qua từng parser.
/// Không có side effects — chỉ nhận bytes → parse → emit state mới.
class BikeDataNotifier extends StateNotifier<BikeData> {
  BikeDataNotifier() : super(const BikeData());

  /// Dashboard packet: 41-byte binary (characteristic 6d2eb205)
  void applyDashboard(List<int> bytes) {
    state = DashboardParser.parse(bytes, state);
  }

  /// BMS / config JSON (characteristic 84c7be0b hoặc 018e6a6f)
  void applyJson(List<int> bytes) {
    state = JsonParser.parse(bytes, state);
  }

  /// Lock status: 1 byte (characteristic eec8fd7f)
  void applyLock(List<int> bytes) {
    state = LockParser.parse(bytes, state);
  }

  /// RSSI update (dBm)
  void applyRssi(int rssi) {
    state = state.copyWith(rssi: rssi);
  }

  /// MAC address khi kết nối thành công
  void applyConnectedMac(String mac) {
    state = state.copyWith(connectedMac: mac);
  }

  /// Demo mode: ghi đè toàn bộ state (bypass parsers)
  void applyDemo(BikeData data) {
    state = data;
  }

  /// Reset về trạng thái ban đầu khi disconnect
  void reset() {
    final mac = state.connectedMac;
    state = BikeData(connectedMac: mac); // giữ mac để auto-reconnect
  }
}
