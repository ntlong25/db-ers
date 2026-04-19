import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'bike_ble_constants.dart';

/// BikeBleManager — wrapper cho flutter_blue_plus
/// Tương đương BikeBleLib.java (phần scan + connect + MTU)
///
/// Chỉ xử lý low-level BLE:
/// - Scan với filter MAC / name
/// - Connect + MTU negotiation
/// - Disconnect
///
/// Không giữ state — state được quản lý bởi BleConnectionNotifier.
class BikeBleManager {
  BikeBleManager._();

  static final BikeBleManager instance = BikeBleManager._();

  StreamSubscription<List<ScanResult>>? _scanSub;
  StreamSubscription<BluetoothConnectionState>? _connectionSub;

  // ═══════════════════════════════════════════════════════
  // SCAN
  // ═══════════════════════════════════════════════════════

  /// Scan tìm Datbike.
  /// [targetMac] nếu có, chỉ callback khi tìm thấy đúng MAC.
  /// [onFound] callback khi tìm thấy device phù hợp.
  /// [onTimeout] callback khi hết timeout mà không tìm thấy.
  Future<void> startScan({
    String? targetMac,
    required void Function(BluetoothDevice device) onFound,
    void Function()? onTimeout,
  }) async {
    await stopScan();

    // iOS: CoreBluetooth khởi tạo bất đồng bộ — đợi state ổn định (tối đa 5s)
    // Android: .first thường trả về ngay, nhưng cũng an toàn khi dùng cách này
    final adapterState = await FlutterBluePlus.adapterState
        .where((s) =>
            s != BluetoothAdapterState.unknown &&
            s != BluetoothAdapterState.turningOn)
        .first
        .timeout(
          const Duration(seconds: 5),
          onTimeout: () => BluetoothAdapterState.off,
        );

    if (adapterState != BluetoothAdapterState.on) {
      return;
    }

    _scanSub = FlutterBluePlus.scanResults.listen((results) {
      for (final result in results) {
        if (_isDatBike(result, targetMac)) {
          onFound(result.device);
          stopScan();
          return;
        }
      }
    });

    await FlutterBluePlus.startScan(
      timeout: const Duration(milliseconds: kScanTimeoutMs),
      androidScanMode: AndroidScanMode.balanced,
    );

    // Timeout callback
    Future.delayed(const Duration(milliseconds: kScanTimeoutMs), () {
      if (FlutterBluePlus.isScanningNow) {
        stopScan();
        onTimeout?.call();
      }
    });
  }

  Future<void> stopScan() async {
    await _scanSub?.cancel();
    _scanSub = null;
    if (FlutterBluePlus.isScanningNow) {
      await FlutterBluePlus.stopScan();
    }
  }

  // ═══════════════════════════════════════════════════════
  // CONNECT
  // ═══════════════════════════════════════════════════════

  /// Connect tới device và negotiate MTU 517.
  /// Trả về device khi connect thành công.
  /// Throw exception nếu thất bại.
  Future<BluetoothDevice> connect(
    BluetoothDevice device, {
    void Function(BluetoothConnectionState)? onStateChange,
  }) async {
    // Listen connection state changes
    _connectionSub?.cancel();
    _connectionSub = device.connectionState.listen((state) {
      onStateChange?.call(state);
    });

    // Delay nhỏ trước khi connect (khớp Android connectDelayMs = 300)
    await Future.delayed(const Duration(milliseconds: kConnectDelayMs));

    await device.connect(
      autoConnect: false,
      timeout: const Duration(seconds: 15),
    );

    // Negotiate MTU
    try {
      await device.requestMtu(kMtuSize);
    } catch (_) {
      // MTU failure không phải fatal — tiếp tục với MTU mặc định
    }

    return device;
  }

  /// Disconnect và dọn subscriptions
  Future<void> disconnect(BluetoothDevice device) async {
    await _connectionSub?.cancel();
    _connectionSub = null;
    try {
      await device.disconnect();
    } catch (_) {}
  }

  // ═══════════════════════════════════════════════════════
  // BLUETOOTH STATE
  // ═══════════════════════════════════════════════════════

  /// Stream trạng thái Bluetooth adapter
  Stream<BluetoothAdapterState> get adapterStateStream =>
      FlutterBluePlus.adapterState;

  /// Stream scanning state
  Stream<bool> get isScanningStream => FlutterBluePlus.isScanning;

  // ═══════════════════════════════════════════════════════
  // DEVICE FILTER — isDatBike()
  // ═══════════════════════════════════════════════════════

  /// Kiểm tra device có phải Datbike không
  /// Logic tương đương BikeBleLib.isDatBike()
  bool _isDatBike(ScanResult result, String? targetMac) {
    final device = result.device;
    final name = (device.platformName).toLowerCase();
    final mac = device.remoteId.str.toUpperCase();

    // Fast-pass: khớp MAC đã lưu
    if (targetMac != null && mac == targetMac.toUpperCase()) return true;

    // Kiểm tra tên device
    for (final prefix in kBikeNamePrefixes) {
      if (name.startsWith(prefix)) return true;
    }

    // Kiểm tra service UUID trong advertisement data
    final serviceUuids = result.advertisementData.serviceUuids
        .map((u) => u.str128.toLowerCase())
        .toList();
    if (serviceUuids.contains(kServiceDashboard.toLowerCase())) return true;
    if (serviceUuids.contains(kServiceInfo.toLowerCase())) return true;

    return false;
  }

  void dispose() {
    _scanSub?.cancel();
    _connectionSub?.cancel();
  }
}
