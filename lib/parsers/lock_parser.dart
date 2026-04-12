import '../ble/bike_ble_constants.dart';
import '../models/bike_data.dart';

/// Parser cho 1-byte lock status packet (kCharLockStatus)
/// Tương đương DataParser.parseLockStatus() trong Android.
///
/// Byte values:
///   0x30 (48) = unlocked
///   0x31 (49) = locked
///   0x02 (2)  = alarm sounding
///   0x07 (7)  = armed / anti-theft active
class LockParser {
  LockParser._();

  static BikeData parse(List<int> bytes, BikeData existing) {
    if (bytes.isEmpty) return existing;

    final byte = bytes[0];

    return existing.copyWith(
      isLocked: byte == kLockByteLocked,
      isAlarmSounding: byte == kLockByteAlarm,
      isArmed: byte == kLockByteArmed,
    );
  }
}
