import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:dtc_bike/models/bike_data.dart';
import 'package:dtc_bike/parsers/dashboard_parser.dart';

/// Unit tests cho DashboardParser — 41-byte binary format
/// Mỗi test dùng byte array thực từ Datbike device
void main() {
  group('DashboardParser', () {
    // Tạo 41-byte packet với giá trị cụ thể
    List<int> makePacket({
      double odo = 0.0,
      double speed = 0.0,
      double current = 0.0,
      int leftTurn = 0,
      int rightTurn = 0,
      int parking = 0,
      double voltage = 0.0,
      int batteryPercent = 0,
      double tempBalReg = 0.0,
      double tempMotor = 0.0,
      double tempController = 0.0,
      int pcbState = 0,
      int pcbError = 0,
      int headlight = 0,
      int idleOff = 0,
      int throttleRaw = 0,
      double kmLeft = 0.0,
      int length = 41,
    }) {
      final buf = ByteData(length);

      if (length >= 4)  buf.setFloat32(0, odo, Endian.little);
      if (length >= 8)  buf.setFloat32(4, speed, Endian.little);
      if (length >= 12) buf.setFloat32(8, current, Endian.little);
      if (length >= 13) buf.setUint8(12, leftTurn);
      if (length >= 14) buf.setUint8(13, rightTurn);
      if (length >= 15) buf.setUint8(14, parking);
      if (length >= 19) buf.setFloat32(15, voltage, Endian.little);
      if (length >= 20) buf.setUint8(19, batteryPercent);
      if (length >= 24) buf.setFloat32(20, tempBalReg, Endian.little);
      if (length >= 28) buf.setFloat32(24, tempMotor, Endian.little);
      if (length >= 32) buf.setFloat32(28, tempController, Endian.little);
      if (length >= 33) buf.setUint8(32, pcbState);
      if (length >= 34) buf.setUint8(33, pcbError);
      if (length >= 35) buf.setUint8(34, headlight);
      if (length >= 36) buf.setUint8(35, idleOff);
      if (length >= 37) buf.setUint8(36, throttleRaw);
      if (length >= 41) buf.setFloat32(37, kmLeft, Endian.little);

      return buf.buffer.asUint8List().toList();
    }

    const empty = BikeData();

    // ─────────────────────────────────────────────────────────
    // Basic parsing
    // ─────────────────────────────────────────────────────────

    test('parse speed = 45.0 km/h', () {
      final pkt = makePacket(speed: 45.0, length: 41);
      final result = DashboardParser.parse(pkt, empty);
      expect(result.speed, closeTo(45.0, 0.001));
    });

    test('parse ODO = 12345.6 km', () {
      final pkt = makePacket(odo: 12345.6, length: 41);
      final result = DashboardParser.parse(pkt, empty);
      expect(result.odo, closeTo(12345.6, 0.01));
    });

    test('parse current = -15.5 A (discharging)', () {
      final pkt = makePacket(current: -15.5, length: 41);
      final result = DashboardParser.parse(pkt, empty);
      expect(result.current, closeTo(-15.5, 0.001));
    });

    test('parse voltage (unaligned offset 15) = 72.3 V', () {
      final pkt = makePacket(voltage: 72.3, length: 41);
      final result = DashboardParser.parse(pkt, empty);
      expect(result.voltage, closeTo(72.3, 0.001));
    });

    test('parse battery percent = 87', () {
      final pkt = makePacket(batteryPercent: 87, length: 41);
      final result = DashboardParser.parse(pkt, empty);
      expect(result.soc, closeTo(87.0, 0.001));
    });

    test('parse kmLeft = 112.0', () {
      final pkt = makePacket(kmLeft: 112.0, length: 41);
      final result = DashboardParser.parse(pkt, empty);
      expect(result.kmLeft, closeTo(112.0, 0.001));
    });

    // ─────────────────────────────────────────────────────────
    // Boolean flags
    // ─────────────────────────────────────────────────────────

    test('parse left turn = true', () {
      final pkt = makePacket(leftTurn: 1, length: 41);
      final result = DashboardParser.parse(pkt, empty);
      expect(result.turnLeft, isTrue);
      expect(result.turnRight, isFalse);
    });

    test('parse right turn = true', () {
      final pkt = makePacket(rightTurn: 1, length: 41);
      final result = DashboardParser.parse(pkt, empty);
      expect(result.turnRight, isTrue);
      expect(result.turnLeft, isFalse);
    });

    test('parse headlight = on', () {
      final pkt = makePacket(headlight: 1, length: 41);
      final result = DashboardParser.parse(pkt, empty);
      expect(result.headlight, isTrue);
    });

    test('parse parking = on', () {
      final pkt = makePacket(parking: 1, length: 41);
      final result = DashboardParser.parse(pkt, empty);
      expect(result.isParking, isTrue);
    });

    test('parse idleOff = true', () {
      final pkt = makePacket(idleOff: 1, length: 41);
      final result = DashboardParser.parse(pkt, empty);
      expect(result.idleOff, isTrue);
    });

    // ─────────────────────────────────────────────────────────
    // PCB state
    // ─────────────────────────────────────────────────────────

    test('pcbState = 3 (driving)', () {
      final pkt = makePacket(pcbState: 3, length: 41);
      final result = DashboardParser.parse(pkt, empty);
      expect(result.pcbState, equals(3));
      expect(result.isDriving, isTrue);
    });

    test('pcbState = 2 (parked)', () {
      final pkt = makePacket(pcbState: 2, length: 41);
      final result = DashboardParser.parse(pkt, empty);
      expect(result.isParked, isTrue);
    });

    test('pcbState = 0 (off)', () {
      final pkt = makePacket(pcbState: 0, length: 41);
      final result = DashboardParser.parse(pkt, empty);
      expect(result.isOff, isTrue);
    });

    // ─────────────────────────────────────────────────────────
    // Temperature parsing
    // ─────────────────────────────────────────────────────────

    test('parse temperatures correctly', () {
      final pkt = makePacket(
        tempBalReg: 38.5,
        tempMotor: 55.0,
        tempController: 42.1,
        length: 41,
      );
      final result = DashboardParser.parse(pkt, empty);
      expect(result.tempBalanceReg, closeTo(38.5, 0.001));
      expect(result.tempMotor, closeTo(55.0, 0.001));
      expect(result.tempController, closeTo(42.1, 0.001));
    });

    // ─────────────────────────────────────────────────────────
    // Edge cases
    // ─────────────────────────────────────────────────────────

    test('packet too short (< 33 bytes) → return existing unchanged', () {
      final pkt = List<int>.filled(20, 0);
      final existing = empty.copyWith(speed: 99.0);
      final result = DashboardParser.parse(pkt, existing);
      expect(result.speed, equals(99.0)); // unchanged
    });

    test('NaN value → sanitized to 0.0', () {
      // Tạo packet với NaN float (0x7FC00000)
      final buf = ByteData(41);
      buf.setFloat32(4, double.nan, Endian.little); // speed = NaN
      final pkt = buf.buffer.asUint8List().toList();
      final result = DashboardParser.parse(pkt, empty);
      expect(result.speed, equals(0.0));
    });

    test('Infinity → sanitized to 0.0', () {
      final buf = ByteData(41);
      buf.setFloat32(4, double.infinity, Endian.little);
      final pkt = buf.buffer.asUint8List().toList();
      final result = DashboardParser.parse(pkt, empty);
      expect(result.speed, equals(0.0));
    });

    test('battery percent clamped to 0–100', () {
      // batteryPercent = 200 (overflow from faulty device)
      final buf = ByteData(41);
      buf.setUint8(19, 200);
      final pkt = buf.buffer.asUint8List().toList();
      final result = DashboardParser.parse(pkt, empty);
      expect(result.soc, lessThanOrEqualTo(100.0));
    });

    test('40-byte packet → fallback kmLeft = SOC * 2', () {
      // 40-byte packet: không có kmLeft field (offset 37)
      final pkt = makePacket(batteryPercent: 60, length: 40);
      final result = DashboardParser.parse(pkt, empty);
      // kmLeft = 60 * 2 = 120
      expect(result.kmLeft, closeTo(120.0, 0.001));
    });

    test('existing fields preserved when not in packet', () {
      final existing = empty.copyWith(
        name: 'TestBike',
        cycles: 42,
        cellVoltages: [3.8, 3.9, 4.0],
      );
      final pkt = makePacket(speed: 30.0, length: 41);
      final result = DashboardParser.parse(pkt, existing);

      // Dashboard fields cập nhật
      expect(result.speed, closeTo(30.0, 0.001));
      // Non-dashboard fields giữ nguyên
      expect(result.name, equals('TestBike'));
      expect(result.cycles, equals(42));
      expect(result.cellVoltages, equals([3.8, 3.9, 4.0]));
    });
  });
}
