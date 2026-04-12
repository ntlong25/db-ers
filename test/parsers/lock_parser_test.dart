import 'package:flutter_test/flutter_test.dart';
import 'package:dtc_bike/models/bike_data.dart';
import 'package:dtc_bike/parsers/lock_parser.dart';

/// Unit tests cho LockParser — 1-byte lock status
void main() {
  group('LockParser', () {
    const empty = BikeData();

    test('0x30 (48) → unlocked', () {
      final result = LockParser.parse([0x30], empty);
      expect(result.isLocked, isFalse);
      expect(result.isAlarmSounding, isFalse);
      expect(result.isArmed, isFalse);
    });

    test('0x31 (49) → locked', () {
      final result = LockParser.parse([0x31], empty);
      expect(result.isLocked, isTrue);
      expect(result.isAlarmSounding, isFalse);
      expect(result.isArmed, isFalse);
    });

    test('0x02 (2) → alarm sounding', () {
      final result = LockParser.parse([0x02], empty);
      expect(result.isAlarmSounding, isTrue);
      expect(result.isLocked, isFalse);
      expect(result.isArmed, isFalse);
    });

    test('0x07 (7) → armed (anti-theft)', () {
      final result = LockParser.parse([0x07], empty);
      expect(result.isArmed, isTrue);
      expect(result.isLocked, isFalse);
      expect(result.isAlarmSounding, isFalse);
    });

    test('empty bytes → return existing unchanged', () {
      final existing = empty.copyWith(isLocked: true, speed: 55.0);
      final result = LockParser.parse([], existing);
      expect(result.isLocked, isTrue);
      expect(result.speed, equals(55.0));
    });

    test('unknown byte → all flags false', () {
      // Byte không định nghĩa → tất cả false
      final result = LockParser.parse([0xFF], empty);
      expect(result.isLocked, isFalse);
      expect(result.isAlarmSounding, isFalse);
      expect(result.isArmed, isFalse);
    });

    test('only first byte used (multi-byte)', () {
      // Nếu packet dài hơn 1 byte, chỉ byte đầu tiên được dùng
      final result = LockParser.parse([0x31, 0x02, 0x07], empty);
      expect(result.isLocked, isTrue);
      expect(result.isAlarmSounding, isFalse);
    });

    test('non-dashboard fields preserved after lock parse', () {
      final existing = empty.copyWith(
        speed: 42.0,
        soc: 80.0,
        name: 'DatBike Pro',
      );
      final result = LockParser.parse([0x31], existing);
      expect(result.isLocked, isTrue);
      // Các field khác phải giữ nguyên
      expect(result.speed, equals(42.0));
      expect(result.soc, equals(80.0));
      expect(result.name, equals('DatBike Pro'));
    });
  });
}
