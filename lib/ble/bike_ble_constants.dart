/// BLE UUIDs cho Datbike — đã giải mã từ bike_secrets.c (XOR key 0x5A)
/// Không cần JNI/Platform Channel, dùng trực tiếp trong Dart.
library bike_ble_constants;

// ═══════════════════════════════════════════════════════════
// GATT SERVICES
// ═══════════════════════════════════════════════════════════

/// Service chứa dashboard + battery + bike log characteristics
const String kServiceDashboard = 'cf6900a7-4520-4a4c-977c-82979e8baccf';

/// Service chứa thông tin xe (info/config)
const String kServiceInfo = 'd4905f67-8931-4faa-8c61-86ec7490f3c5';

/// Service auth (chưa implement đầy đủ)
const String kServiceAuth = '10cb0217-ff02-4474-a1ef-6fd88b5bdaea';

// ═══════════════════════════════════════════════════════════
// GATT CHARACTERISTICS
// ═══════════════════════════════════════════════════════════

/// Dashboard telemetry — 41-byte binary
/// Chứa: speed, ODO, current, voltage, battery%, temps, pcbState, errorCode, range
const String kCharDashboard = '6d2eb205-6f9b-4ecf-bb1b-a5fad127c66c';

/// Battery log — JSON
/// Chứa: voltage, current, SOC, cellVoltages (23), NTC temps, BMS config
const String kCharBatteryLog = '84c7be0b-7619-45c1-a503-95f4ff8736ed';

/// Bike log — JSON
/// Chứa: firmware, VIN, PCB name, ODO, throttle ADC, pcbState, idleOff
const String kCharBikeLog = '018e6a6f-4bda-7b07-8586-1298248a8d5c';

/// Error characteristic — JSON
const String kCharError = '460a5bc5-a5f5-4968-b548-dc218935245e';

/// Find bike (beeper) — write "1" để kích hoạt còi
const String kCharBeepActive = '350d9a82-b3f3-4213-bdda-6403be495f53';

/// Beep scan
const String kCharBeepScan = '87efab0d-9e32-4ab8-8916-ed7cb72d819a';

/// Sync thời gian — write 4-byte Unix timestamp (little-endian)
const String kCharTimeSync = '44e2bde6-9cd5-4159-9d43-a3e3f4e9c737';

/// Lock status — notify, 1 byte
/// 0x30 (48) = unlocked, 0x31 (49) = locked, 0x02 = alarm, 0x07 = armed
/// ⚠️ Chỉ có prefix 8 ký tự — cần verify full UUID với device thực
const String kCharLockStatusPrefix = 'eec8fd7f';

/// Auth challenge — ⚠️ Chỉ có prefix 8 ký tự
const String kCharAuthChallengePrefix = 'c8eaf27b';

/// NFC card event — ⚠️ Chỉ có prefix 8 ký tự
const String kCharNfcPrefix = 'c75ebe03';

// ═══════════════════════════════════════════════════════════
// CCCD (Client Characteristic Configuration Descriptor)
// ═══════════════════════════════════════════════════════════
const String kDescriptorCccd = '00002902-0000-1000-8000-00805f9b34fb';

// ═══════════════════════════════════════════════════════════
// DEVICE IDENTIFICATION
// ═══════════════════════════════════════════════════════════

/// Tên prefix của Datbike trong quá trình scan
const List<String> kBikeNamePrefixes = [
  'datbike',
  'quantum',
  'weaver',
  'dat',
];

// ═══════════════════════════════════════════════════════════
// BLE CONFIG
// ═══════════════════════════════════════════════════════════

/// MTU request size (khớp với DatbikeConstants.ANDROID_MTU = 517)
const int kMtuSize = 517;

/// Thời gian scan tối đa (ms)
const int kScanTimeoutMs = 15000;

/// Delay trước khi connect sau khi scan thấy (ms)
const int kConnectDelayMs = 300;

/// Số lần auto-reconnect tối đa
const int kMaxReconnectAttempts = 5;

// ═══════════════════════════════════════════════════════════
// LOCK STATUS BYTES
// ═══════════════════════════════════════════════════════════
const int kLockByteLocked = 49;    // 0x31 = '1'
const int kLockByteUnlocked = 48;  // 0x30 = '0'
const int kLockByteAlarm = 2;      // 0x02
const int kLockByteArmed = 7;      // 0x07

// ═══════════════════════════════════════════════════════════
// SharedPreferences keys
// ═══════════════════════════════════════════════════════════
const String kPrefSavedMac = 'saved_bike_mac';
const String kPrefSavedName = 'saved_bike_name';
