import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:dtc_bike/models/bike_data.dart';
import 'package:dtc_bike/parsers/json_parser.dart';

/// Unit tests cho JsonParser — BMS + Config JSON packets
///
/// JsonParser.parse() nhận raw bytes (utf8 encoded JSON),
/// nên test cần encode map → bytes trước.
void main() {
  /// Helper: encode Map thành List<int> bytes như BLE gửi
  List<int> toBytes(Map<String, dynamic> map) => utf8.encode(jsonEncode(map));

  group('JsonParser — BMS packet', () {
    const empty = BikeData();

    Map<String, dynamic> bmsMap({
      double voltage = 72.3,
      double current = -12.5,
      double soc = 85.0,
      List<double>? cellVols,
      List<double>? ntcs,
      List<double>? bmsTemps,
      int cycles = 42,
      bool isCharging = false,
      int bmsError = 0,
      double currentAh = 30.0,
      double absAh = 1200.0,
    }) {
      return {
        'voltage': voltage,
        'current': current,
        'soc': soc,
        'cellVols': cellVols ?? List.generate(23, (i) => 3.8 + i * 0.001),
        'NTCs': ntcs ?? [35.0, 36.0, 37.0, 38.0],
        'bms': bmsTemps ?? [40.0, 41.0],
        'cycles': cycles,
        'isCharging': isCharging,
        'bmsError': bmsError,
        'currentAh': currentAh,
        'absAh': absAh,
      };
    }

    test('parse voltage from BMS packet', () {
      final result = JsonParser.parse(toBytes(bmsMap(voltage: 73.5)), empty);
      expect(result.voltage, closeTo(73.5, 0.001));
    });

    test('parse current (negative = discharging)', () {
      final result = JsonParser.parse(toBytes(bmsMap(current: -18.2)), empty);
      expect(result.current, closeTo(-18.2, 0.001));
    });

    test('parse SOC', () {
      final result = JsonParser.parse(toBytes(bmsMap(soc: 76.0)), empty);
      expect(result.soc, closeTo(76.0, 0.001));
    });

    test('parse 23 cell voltages', () {
      final cells = List.generate(23, (i) => 3.700 + i * 0.005);
      final result = JsonParser.parse(toBytes(bmsMap(cellVols: cells)), empty);
      expect(result.cellVoltages.length, equals(23));
      expect(result.cellVoltages[0], closeTo(3.700, 0.001));
      expect(result.cellVoltages[22], closeTo(3.700 + 22 * 0.005, 0.001));
    });

    test('parse 4 NTC temperatures', () {
      final result = JsonParser.parse(
        toBytes(bmsMap(ntcs: [28.5, 31.0, 33.5, 29.0])),
        empty,
      );
      expect(result.tempPin1, closeTo(28.5, 0.001));
      expect(result.tempPin2, closeTo(31.0, 0.001));
      expect(result.tempPin3, closeTo(33.5, 0.001));
      expect(result.tempPin4, closeTo(29.0, 0.001));
    });

    test('parse charging status = true', () {
      final result = JsonParser.parse(toBytes(bmsMap(isCharging: true)), empty);
      expect(result.isCharging, isTrue);
    });

    test('parse charge cycles', () {
      final result = JsonParser.parse(toBytes(bmsMap(cycles: 156)), empty);
      expect(result.cycles, equals(156));
    });

    test('parse bmsError', () {
      final result = JsonParser.parse(toBytes(bmsMap(bmsError: 4)), empty);
      expect(result.bmsError, equals(4));
    });

    test('parse capacity fields', () {
      final result = JsonParser.parse(
        toBytes(bmsMap(currentAh: 28.5, absAh: 1150.0)),
        empty,
      );
      expect(result.currentAh, closeTo(28.5, 0.001));
      expect(result.absAh, closeTo(1150.0, 0.01));
    });

    test('vMin và vMax computed correctly', () {
      final cells = [3.800, 3.850, 3.750, 3.900] +
          List.generate(19, (_) => 3.820);
      final result = JsonParser.parse(toBytes(bmsMap(cellVols: cells)), empty);
      expect(result.vMin, closeTo(3.750, 0.001));
      expect(result.vMax, closeTo(3.900, 0.001));
      expect(result.cellDiff, closeTo(0.150, 0.001));
    });

    test('cellDiffDanger khi diff > 100mV', () {
      final cells = [3.700] + List.generate(22, (_) => 4.000);
      final result = JsonParser.parse(toBytes(bmsMap(cellVols: cells)), empty);
      expect(result.isCellDiffDanger, isTrue);
    });

    test('cellDiffWarning khi diff 40–100mV', () {
      final cells = [3.800] + List.generate(22, (_) => 3.850);
      final result = JsonParser.parse(toBytes(bmsMap(cellVols: cells)), empty);
      expect(result.isCellDiffWarning, isTrue);
      expect(result.isCellDiffDanger, isFalse);
    });
  });

  group('JsonParser — Config packet', () {
    const empty = BikeData();

    // Cấu trúc nested thực tế từ firmware
    Map<String, dynamic> configMap({
      String name = 'DatBike Pro',
      String fw = '3.2.1',
      String fwHash = 'ab12cd',
      String vin = 'VIN123456',
      String frame = 'FRAME001',
      double odo = 5432.1,
      int pcbState = 3,
      bool idleOff = false,
      double adc1 = 1.230,
      double adc2 = 1.228,
      double tempMotor = 45.0,
      double tempController = 40.0,
      double throttle = 0.0,
    }) {
      return {
        'firmware': {'version': fw, 'hash': fwHash},
        'mainPcb': {
          'name': name,
          'frame': frame,
          'vin': vin,
          'odo': odo,
          'state': pcbState,
          'idleOff': idleOff,
        },
        'controller': {
          'adc1': adc1,
          'adc2': adc2,
          'throttle': throttle,
          'temp': tempController,
        },
        'tempMotor': tempMotor,
      };
    }

    test('parse bike name', () {
      final result = JsonParser.parse(toBytes(configMap(name: 'Quantum X')), empty);
      expect(result.name, equals('Quantum X'));
    });

    test('parse firmware version', () {
      final result = JsonParser.parse(toBytes(configMap(fw: '4.1.0')), empty);
      expect(result.fw, equals('4.1.0'));
    });

    test('parse VIN', () {
      final result = JsonParser.parse(toBytes(configMap(vin: 'VIN987654321')), empty);
      expect(result.vin, equals('VIN987654321'));
    });

    test('parse ODO from config', () {
      final result = JsonParser.parse(toBytes(configMap(odo: 8765.4)), empty);
      expect(result.odo, closeTo(8765.4, 0.01));
    });

    test('parse PCB state from config', () {
      final result = JsonParser.parse(toBytes(configMap(pcbState: 3)), empty);
      expect(result.pcbState, equals(3));
    });

    test('parse idleOff = true', () {
      final result = JsonParser.parse(toBytes(configMap(idleOff: true)), empty);
      expect(result.idleOff, isTrue);
    });

    test('parse ADC throttle values', () {
      final result = JsonParser.parse(
        toBytes(configMap(adc1: 1.245, adc2: 1.240)),
        empty,
      );
      expect(result.adc1, closeTo(1.245, 0.001));
      expect(result.adc2, closeTo(1.240, 0.001));
    });
  });

  group('JsonParser — robustness', () {
    const empty = BikeData();

    test('empty JSON bytes → return existing unchanged', () {
      final existing = empty.copyWith(speed: 50.0, name: 'TestBike');
      // JSON {} không có key 'voltage' hay 'firmware' → không parse được → unchanged
      final result = JsonParser.parse(toBytes({}), existing);
      expect(result.speed, equals(50.0));
      expect(result.name, equals('TestBike'));
    });

    test('invalid bytes → return existing unchanged', () {
      final existing = empty.copyWith(speed: 50.0);
      // Bytes không phải JSON hợp lệ → catch exception → trả về existing
      final result = JsonParser.parse([0xFF, 0xFE, 0xAB], existing);
      expect(result.speed, equals(50.0));
    });

    test('non-dashboard fields preserved after BMS parse', () {
      const existing = BikeData(name: 'TestBike', speed: 42.0, soc: 80.0);
      final bms = {
        'voltage': 72.0,
        'current': -10.0,
        'soc': 85.0,
        'cellVols': List.generate(23, (_) => 3.8),
        'NTCs': [35.0, 36.0, 37.0, 38.0],
        'bms': [40.0],
        'cycles': 50,
        'isCharging': false,
        'bmsError': 0,
        'currentAh': 30.0,
        'absAh': 1200.0,
      };
      final result = JsonParser.parse(toBytes(bms), existing);
      // BMS fields cập nhật
      expect(result.voltage, closeTo(72.0, 0.001));
      // Non-BMS fields giữ nguyên
      expect(result.name, equals('TestBike'));
      expect(result.speed, equals(42.0));
    });
  });
}
