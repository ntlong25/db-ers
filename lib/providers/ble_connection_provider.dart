import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ble/ble_state.dart';
import '../ble/bike_ble_constants.dart';
import '../ble/bike_ble_manager.dart';
import '../ble/bike_gatt_handler.dart';
import '../demo/demo_data_service.dart';
import 'bike_data_provider.dart';
import 'saved_mac_provider.dart';

/// Provider cho BLE connection state
final bleConnectionProvider =
    StateNotifierProvider<BleConnectionNotifier, BleState>((ref) {
  return BleConnectionNotifier(ref);
});

/// Provider truy cập GattHandler hiện tại (để gọi findBike, setAppForeground...)
final gattHandlerProvider = Provider<BikeGattHandler?>((ref) {
  final notifier = ref.watch(bleConnectionProvider.notifier);
  return notifier._gattHandler;
});

/// BleConnectionNotifier — trái tim của BLE layer.
/// Quản lý toàn bộ lifecycle: Scan → Connect → MTU → Discover → Poll → Reconnect
/// Tương đương BikeBleLib.java + BikeGattCallback.java
class BleConnectionNotifier extends StateNotifier<BleState> {
  final Ref _ref;
  final BikeBleManager _manager = BikeBleManager.instance;

  BikeGattHandler? _gattHandler;
  DemoDataService? _demoService;
  int _reconnectAttempt = 0;
  Timer? _reconnectTimer;

  BleConnectionNotifier(this._ref) : super(const BleIdle());

  // ═══════════════════════════════════════════════════════
  // PUBLIC API
  // ═══════════════════════════════════════════════════════

  /// Khởi động: nếu có MAC đã lưu → auto-reconnect, không thì idle
  Future<void> initialize() async {
    final savedMac = _ref.read(savedMacProvider);
    if (savedMac != null && savedMac.isNotEmpty) {
      await startReconnect(savedMac);
    }
    // else: BleIdle — user cần nhấn Scan
  }

  /// Bắt đầu scan toàn bộ (user nhấn nút Scan)
  Future<void> startScan() async {
    _cancelReconnectTimer();
    state = const BleScanning();

    await _manager.startScan(
      onFound: (device) => _onDeviceFound(device),
      onTimeout: () {
        if (state is BleScanning) state = const BleIdle();
      },
    );
  }

  /// Scan tìm đúng MAC đã lưu (auto-reconnect mode)
  Future<void> startReconnect(String mac) async {
    _cancelReconnectTimer();
    _reconnectAttempt++;

    if (_reconnectAttempt > kMaxReconnectAttempts) {
      state = const BleError('Không thể kết nối lại. Vui lòng scan thủ công.');
      _reconnectAttempt = 0;
      return;
    }

    state = BleReconnecting(mac, _reconnectAttempt);

    await _manager.startScan(
      targetMac: mac,
      onFound: (device) => _onDeviceFound(device),
      onTimeout: () {
        // Retry với backoff
        final delay = Duration(seconds: _reconnectAttempt * 5);
        _reconnectTimer = Timer(delay, () => startReconnect(mac));
      },
    );
  }

  /// Connect trực tiếp tới device đã chọn từ scan list
  Future<void> connectToDevice(BluetoothDevice device) async {
    await _manager.stopScan();
    await _doConnect(device);
  }

  /// Bật chế độ demo — không cần BLE thật (dùng cho máy ảo / test UI)
  void startDemoMode() {
    _cancelReconnectTimer();
    _gattHandler?.dispose();
    _gattHandler = null;
    _demoService?.stop();
    _demoService = DemoDataService(_ref);
    _demoService!.start();
    state = const BleDemoMode();
  }

  /// Ngắt kết nối thủ công
  Future<void> disconnect() async {
    _cancelReconnectTimer();
    _demoService?.stop();
    _demoService = null;
    _gattHandler?.dispose();
    _gattHandler = null;

    final currentState = state;
    if (currentState is BleConnected) {
      await _manager.disconnect(currentState.device);
    }

    _ref.read(bikeDataProvider.notifier).reset();
    state = const BleIdle();
    _reconnectAttempt = 0;
  }

  /// Xóa xe đã lưu và về trạng thái Idle
  Future<void> forgetDevice() async {
    await disconnect();
    await _ref.read(savedMacProvider.notifier).clear();
  }

  /// App vào foreground
  void onAppForeground() {
    _gattHandler?.setAppForeground(true);
  }

  /// App vào background
  void onAppBackground() {
    _gattHandler?.setAppForeground(false);
  }

  // ═══════════════════════════════════════════════════════
  // INTERNAL FLOW
  // ═══════════════════════════════════════════════════════

  Future<void> _onDeviceFound(BluetoothDevice device) async {
    // Lưu MAC
    final mac = device.remoteId.str;
    await _ref.read(savedMacProvider.notifier).save(mac, device.platformName);
    _ref.read(bikeDataProvider.notifier).applyConnectedMac(mac);

    await _doConnect(device);
  }

  Future<void> _doConnect(BluetoothDevice device) async {
    state = BleConnecting(device.remoteId.str);

    try {
      // Connect + MTU
      state = BleNegotiatingMtu(device);
      await _manager.connect(device);

      // Discover services
      state = BleDiscoveringServices(device);
      final services = await device.discoverServices();

      // Tất cả OK → Connected
      _reconnectAttempt = 0;
      state = BleConnected(device, services);

      // Khởi động GATT handler
      await _startGattHandler(device, services);
    } catch (e) {
      state = BleError(e.toString());
      // Auto-retry nếu có MAC đã lưu
      final savedMac = _ref.read(savedMacProvider);
      if (savedMac != null) {
        Future.delayed(const Duration(seconds: 3), () {
          startReconnect(savedMac);
        });
      }
    }
  }

  Future<void> _startGattHandler(
    BluetoothDevice device,
    List<BluetoothService> services,
  ) async {
    _gattHandler?.dispose();
    _gattHandler = BikeGattHandler(device: device, services: services);

    final dataNotifier = _ref.read(bikeDataProvider.notifier);

    // Wire callbacks → parsers → BikeData
    _gattHandler!.onDashboard = (bytes) {
      dataNotifier.applyDashboard(bytes);
      // Cập nhật polling interval nếu pcbState thay đổi
      _gattHandler?.updatePcbState(_ref.read(bikeDataProvider).pcbState);
    };
    _gattHandler!.onBatteryLog = dataNotifier.applyJson;
    _gattHandler!.onBikeLog = dataNotifier.applyJson;
    _gattHandler!.onLockStatus = dataNotifier.applyLock;
    _gattHandler!.onRssi = dataNotifier.applyRssi;

    _gattHandler!.onDisconnect = () {
      _gattHandler?.dispose();
      _gattHandler = null;
      dataNotifier.reset();

      final savedMac = _ref.read(savedMacProvider);
      if (savedMac != null) {
        state = BleReconnecting(savedMac, 0);
        startReconnect(savedMac);
      } else {
        state = const BleIdle();
      }
    };

    await _gattHandler!.start();
  }

  // ═══════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════

  void _cancelReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  @override
  void dispose() {
    _cancelReconnectTimer();
    _demoService?.stop();
    _gattHandler?.dispose();
    super.dispose();
  }
}
