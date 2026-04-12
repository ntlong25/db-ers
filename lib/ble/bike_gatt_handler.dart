import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'bike_ble_constants.dart';
import 'bike_ble_freq.dart';

/// BikeGattHandler — quản lý GATT sau khi đã connect + discover services.
/// Tương đương phần service discovery + polling trong BikeBleLib.java
/// và BikeGattCallback.java.
///
/// Nhiệm vụ:
/// 1. Enable notifications cho dashboard + lock characteristics
/// 2. Gọi polling timer để đọc batteryLog + bikeLog định kỳ
/// 3. Route raw bytes đến đúng callback theo UUID
/// 4. Đọc RSSI định kỳ
/// 5. Sync thời gian với xe lúc khởi động
class BikeGattHandler {
  final BluetoothDevice device;
  final List<BluetoothService> services;

  /// Callbacks — được set bởi BleConnectionNotifier
  void Function(List<int> bytes)? onDashboard;
  void Function(List<int> bytes)? onBatteryLog;
  void Function(List<int> bytes)? onBikeLog;
  void Function(List<int> bytes)? onLockStatus;
  void Function(int rssi)? onRssi;
  void Function()? onDisconnect;

  Timer? _pollingTimer;
  Timer? _rssiTimer;
  final List<StreamSubscription> _notifySubs = [];

  bool _isAppForeground = true;
  int _currentPcbState = 0;

  BikeGattHandler({
    required this.device,
    required this.services,
  });

  // ═══════════════════════════════════════════════════════
  // START — gọi sau khi discover services xong
  // ═══════════════════════════════════════════════════════

  Future<void> start() async {
    // 1. Listen connection state — detect disconnect
    device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected) {
        _stopTimers();
        onDisconnect?.call();
      }
    });

    // 2. Enable notifications cho dashboard char
    await _enableNotify(kCharDashboard, onDashboard);

    // 3. Enable notifications cho lock status (dùng prefix match)
    await _enableNotifyByPrefix(kCharLockStatusPrefix, onLockStatus);

    // 4. Sync thời gian với xe
    await _syncTime();

    // 5. Đọc lần đầu ngay lập tức
    await _pollOnce();

    // 6. Bắt đầu polling timer + RSSI timer
    _startTimers();
  }

  // ═══════════════════════════════════════════════════════
  // NOTIFICATIONS
  // ═══════════════════════════════════════════════════════

  Future<void> _enableNotify(
    String uuid,
    void Function(List<int>)? callback,
  ) async {
    final char = _findChar(uuid);
    if (char == null) return;
    if (!char.properties.notify && !char.properties.indicate) return;

    try {
      await char.setNotifyValue(true);
      final sub = char.onValueReceived.listen((bytes) {
        if (bytes.isNotEmpty) callback?.call(bytes);
      });
      _notifySubs.add(sub);
    } catch (_) {}
  }

  Future<void> _enableNotifyByPrefix(
    String uuidPrefix,
    void Function(List<int>)? callback,
  ) async {
    final char = _findCharByPrefix(uuidPrefix);
    if (char == null) return;
    if (!char.properties.notify && !char.properties.indicate) return;

    try {
      await char.setNotifyValue(true);
      final sub = char.onValueReceived.listen((bytes) {
        if (bytes.isNotEmpty) callback?.call(bytes);
      });
      _notifySubs.add(sub);
    } catch (_) {}
  }

  // ═══════════════════════════════════════════════════════
  // POLLING TIMER
  // ═══════════════════════════════════════════════════════

  void _startTimers() {
    _schedulePolling();
    _rssiTimer = Timer.periodic(BikeBleFreq.rssiInterval, (_) => _readRssi());
  }

  void _schedulePolling() {
    _pollingTimer?.cancel();
    final interval = BikeBleFreq.getPollingInterval(
      isAppForeground: _isAppForeground,
      pcbState: _currentPcbState,
    );
    _pollingTimer = Timer.periodic(interval, (_) async {
      await _pollOnce();
      // Re-schedule nếu interval có thể thay đổi (pcbState mới)
      _rescheduleIfNeeded();
    });
  }

  void _rescheduleIfNeeded() {
    // Interval được tính lại mỗi khi pcbState / foreground thay đổi
    // thông qua updatePcbState() và setAppForeground() → _schedulePolling()
  }

  Future<void> _pollOnce() async {
    await _readChar(kCharBatteryLog, onBatteryLog);
    await Future.delayed(const Duration(milliseconds: 100));
    await _readChar(kCharBikeLog, onBikeLog);
    await Future.delayed(const Duration(milliseconds: 100));
    await _readChar(kCharError, null); // đọc nhưng chưa xử lý error char
  }

  Future<void> _readChar(
    String uuid,
    void Function(List<int>)? callback,
  ) async {
    final char = _findChar(uuid);
    if (char == null) return;
    if (!char.properties.read) return;

    try {
      final bytes = await char.read().timeout(const Duration(seconds: 3));
      if (bytes.isNotEmpty) callback?.call(bytes);
    } catch (_) {}
  }

  Future<void> _readRssi() async {
    try {
      final rssi = await device.readRssi().timeout(const Duration(seconds: 2));
      onRssi?.call(rssi);
    } catch (_) {}
  }

  // ═══════════════════════════════════════════════════════
  // COMMANDS
  // ═══════════════════════════════════════════════════════

  /// Find bike — gửi "1" đến beep characteristic
  Future<void> findBike() async {
    final char = _findChar(kCharBeepActive);
    if (char == null) return;
    try {
      await char.write([0x31]); // ASCII '1'
    } catch (_) {}
  }

  /// Sync thời gian: ghi 4-byte Unix timestamp (little-endian)
  Future<void> _syncTime() async {
    final char = _findChar(kCharTimeSync);
    if (char == null) return;
    final ts = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final bytes = [
      ts & 0xFF,
      (ts >> 8) & 0xFF,
      (ts >> 16) & 0xFF,
      (ts >> 24) & 0xFF,
    ];
    try {
      await char.write(bytes, withoutResponse: false);
    } catch (_) {}
  }

  // ═══════════════════════════════════════════════════════
  // APP STATE CHANGE
  // ═══════════════════════════════════════════════════════

  /// Gọi khi app vào foreground/background
  void setAppForeground(bool isForeground) {
    if (_isAppForeground == isForeground) return;
    _isAppForeground = isForeground;
    _schedulePolling(); // reschedule với interval mới
  }

  /// Cập nhật pcbState để điều chỉnh polling interval
  void updatePcbState(int pcbState) {
    if (_currentPcbState == pcbState) return;
    _currentPcbState = pcbState;
    _schedulePolling();
  }

  // ═══════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════

  BluetoothCharacteristic? _findChar(String uuid) {
    final lowerUuid = uuid.toLowerCase();
    for (final service in services) {
      for (final char in service.characteristics) {
        if (char.uuid.str128.toLowerCase() == lowerUuid) return char;
      }
    }
    return null;
  }

  BluetoothCharacteristic? _findCharByPrefix(String prefix) {
    final lowerPrefix = prefix.toLowerCase();
    for (final service in services) {
      for (final char in service.characteristics) {
        if (char.uuid.str128.toLowerCase().startsWith(lowerPrefix)) return char;
      }
    }
    return null;
  }

  void _stopTimers() {
    _pollingTimer?.cancel();
    _rssiTimer?.cancel();
    _pollingTimer = null;
    _rssiTimer = null;
  }

  void dispose() {
    _stopTimers();
    for (final sub in _notifySubs) {
      sub.cancel();
    }
    _notifySubs.clear();
  }
}
