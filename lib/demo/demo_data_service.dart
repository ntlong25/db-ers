import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bike_data.dart';
import '../providers/bike_data_provider.dart';

/// DemoDataService — giả lập dữ liệu xe cho chế độ demo (máy ảo / test UI).
/// Mỗi 500ms sinh ra BikeData mới với giá trị thay đổi theo thời gian.
class DemoDataService {
  final Ref _ref;
  Timer? _timer;
  int _tick = 0;
  final _rng = Random();

  DemoDataService(this._ref);

  void start() {
    _timer?.cancel();
    _tick = 0;

    // Seed data tĩnh ngay lập tức
    _ref.read(bikeDataProvider.notifier).applyDemo(_buildFrame(0));

    // Cập nhật mỗi 500ms
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      _tick++;
      _ref.read(bikeDataProvider.notifier).applyDemo(_buildFrame(_tick));
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  BikeData _buildFrame(int tick) {
    final t = tick * 0.5; // giây thực

    // Tốc độ: sóng sine 0–80 km/h, chu kỳ 60s
    final speed = (40 + 40 * sin(t * 2 * pi / 60)).clamp(0.0, 80.0);

    // SOC: giảm dần từ 87%
    final soc = (87.0 - t * 0.05).clamp(0.0, 100.0);

    // Điện áp: tương quan với SOC (67–84 V)
    final voltage = 67.0 + (soc / 100.0) * 17.0;

    // Dòng điện: tương quan với tốc độ
    final current = speed > 3 ? (3 + speed * 0.35 + _noise(1.0)) : 0.0;

    // ODO tăng dần
    final odo = 1234.5 + t * speed / 3600.0;

    // Quãng đường còn lại
    final kmLeft = soc * 1.6;

    // Nhiệt độ tăng theo tốc độ
    final sf = speed / 80.0;
    final tempMotor = 30 + sf * 35 + _noise(1.5);
    final tempFet = 35 + sf * 28 + _noise(1.0);
    final tempController = 32 + sf * 22 + _noise(1.0);
    final tempPin1 = 26 + sf * 12 + _noise(0.5);
    final tempPin2 = 27 + sf * 13 + _noise(0.5);
    final tempPin3 = 28 + sf * 14 + _noise(0.5);
    final tempPin4 = 29 + sf * 15 + _noise(0.5);
    final tempBalReg = 30 + sf * 10 + _noise(0.5);

    // 23 cell voltages quanh giá trị cơ sở
    final baseCell = 3.50 + (soc / 100.0) * 0.18;
    final cells = List.generate(23, (i) => baseCell + _noise(0.012));
    final vMin = cells.reduce(min);
    final vMax = cells.reduce(max);

    // Trạng thái xe
    final pcbState = speed > 3 ? 3 : 2; // 3=driving, 2=parked

    // RSSI dao động quanh -65 dBm
    final rssi = -65 + _rng.nextInt(12) - 6;

    // Xi nhan: bật phải ở giây 15–20, bật trái ở giây 40–45 của mỗi chu kỳ
    final cycleSec = t % 60;
    final turnRight = cycleSec >= 15 && cycleSec < 20;
    final turnLeft = cycleSec >= 40 && cycleSec < 45;

    return BikeData(
      name: 'QUANTUM S1',
      frame: 'S1',
      fw: '2.3.1',
      fwHash: 'a1b2c3d4',
      vin: 'DTC2024DEMO001',
      speed: speed,
      odo: odo,
      kmLeft: kmLeft,
      throttle: speed / 80.0 * 100.0,
      turnLeft: turnLeft,
      turnRight: turnRight,
      headlight: true,
      isParking: pcbState == 2,
      pcbState: pcbState,
      voltage: voltage,
      current: current,
      soc: soc,
      isDischarging: speed > 3,
      tempBalanceReg: tempBalReg,
      tempFet: tempFet,
      tempPin1: tempPin1,
      tempPin2: tempPin2,
      tempPin3: tempPin3,
      tempPin4: tempPin4,
      tempMotor: tempMotor,
      tempController: tempController,
      cellVoltages: cells,
      vMin: vMin,
      vMax: vMax,
      cellDiff: vMax - vMin,
      cycles: 45,
      currentAh: 48.5,
      absAh: 2180.0 + t * current / 3600.0,
      rssi: rssi,
      connectedMac: 'AA:BB:CC:DD:EE:FF',
    );
  }

  double _noise(double amp) => (_rng.nextDouble() - 0.5) * 2 * amp;
}
