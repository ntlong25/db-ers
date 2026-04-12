# CLAUDE.md — DTC Bike Flutter

## Tổng quan

Flutter rewrite của Android app DTC Bike — giám sát xe điện Datbike qua BLE.
Source Android gốc: `D:\WORKING\outside\dubike\`

---

## Tech Stack

| Thành phần | Công nghệ |
|---|---|
| Ngôn ngữ | Dart / Flutter 3.19.6 |
| BLE | flutter_blue_plus ^1.32 |
| State | flutter_riverpod ^2.5 |
| Database | drift ^2.18 (SQLite, tương đương Room) |
| Charts | fl_chart ^0.68 |
| Background | flutter_foreground_task ^8.0 |
| Audio | audioplayers ^6.1 |
| Build | Android minSdk 24 / targetSdk 35 |

---

## Cấu trúc thư mục

```
lib/
├── main.dart                    # Entry point — init ForegroundTask + ProviderScope
├── app.dart                     # MaterialApp + dark theme (#1A1F2E)
├── ble/
│   ├── bike_ble_constants.dart  # ⭐ UUID đã decoded từ JNI (XOR 0x5A) — KHÔNG cần native
│   ├── bike_ble_manager.dart    # Scan, connect, MTU 517, disconnect
│   ├── bike_gatt_handler.dart   # Notify, polling timer, routing bytes → parsers
│   ├── bike_ble_freq.dart       # Adaptive polling (1s/5s/60s/1h)
│   └── ble_state.dart           # Sealed class: Idle|Scanning|Connecting|Connected|...
├── parsers/
│   ├── dashboard_parser.dart    # 41-byte binary (ByteData little-endian)
│   ├── json_parser.dart         # BMS + config JSON
│   └── lock_parser.dart         # 1-byte lock status
├── models/
│   ├── bike_data.dart           # 78 fields immutable + copyWith
│   └── bike_log_entry.dart      # DB row model
├── database/
│   ├── app_database.dart        # Drift singleton — bike_database.sqlite
│   ├── bike_log_dao.dart        # insert, getByTimeRange, deleteOlderThan
│   ├── bike_log_table.dart      # Schema (15 columns + cellVoltagesJson)
│   └── converters.dart          # List<double> ↔ JSON string
├── providers/
│   ├── ble_connection_provider.dart  # BLE lifecycle + auto-reconnect
│   ├── bike_data_provider.dart       # BikeData StateNotifier
│   ├── saved_mac_provider.dart       # MAC → SharedPreferences
│   ├── database_provider.dart        # Drift instance
│   ├── history_provider.dart         # FutureProvider.family(startMs, endMs)
│   └── logger_notifier.dart          # Throttled DB writes
├── services/
│   ├── foreground_service_handler.dart  # flutter_foreground_task
│   └── alarm_service.dart               # audioplayers — alarm khi isAlarmSounding
├── screens/
│   ├── dashboard/
│   │   ├── dashboard_screen.dart   # Màn hình chính: speed 96sp, battery bar, temps
│   │   └── scan_dialog.dart        # Bottom sheet scan BLE
│   ├── tech_info/
│   │   └── tech_info_screen.dart   # BMS, temps (8), cell grid (23), PCB info
│   └── history/
│       └── history_screen.dart     # Date/time filter + 3 fl_chart LineCharts
└── utils/
    ├── temp_formatter.dart          # Color coding nhiệt độ (>45°C cam, >60°C đỏ)
    ├── bike_state_labels.dart       # pcbState → tiếng Việt
    └── permission_helper.dart       # BLE + notification permissions
```

---

## UUID BLE (đã giải mã — KHÔNG cần JNI)

| Tên | UUID | Mô tả |
|---|---|---|
| Dashboard | `6d2eb205-6f9b-4ecf-bb1b-a5fad127c66c` | 41-byte binary |
| BatteryLog | `84c7be0b-7619-45c1-a503-95f4ff8736ed` | JSON BMS |
| BikeLog | `018e6a6f-4bda-7b07-8586-1298248a8d5c` | JSON config |
| BeepActive | `350d9a82-b3f3-4213-bdda-6403be495f53` | Find bike |
| TimeSync | `44e2bde6-9cd5-4159-9d43-a3e3f4e9c737` | Sync thời gian |
| LockStatus | prefix `eec8fd7f` | ⚠️ Cần verify full UUID với device |

---

## 41-Byte Dashboard Packet

```
offset  0: float32 LE → odo (km)
offset  4: float32 LE → speed (km/h)
offset  8: float32 LE → current (A)
offset 12: uint8      → isLeftTurn
offset 13: uint8      → isRightTurn
offset 14: uint8      → isParking
offset 15: float32 LE → voltage (V) [UNALIGNED — safe với ByteData]
offset 19: uint8      → batteryPercent (0–100)
offset 20: float32 LE → tempBalanceReg (°C)
offset 24: float32 LE → tempMotor (°C)
offset 28: float32 LE → tempController (°C)
offset 32: uint8      → pcbState
offset 33: uint8      → pcbError
offset 37: float32 LE → kmLeft (nếu len >= 41)
```

---

## Luồng dữ liệu

```
Datbike BLE
    │ GATT Notifications + Reads
    ▼
BikeGattHandler
    ├── [6d2eb205] → DashboardParser → BikeDataNotifier.applyDashboard()
    ├── [84c7be0b] → JsonParser.parseBms() → applyJson()
    ├── [018e6a6f] → JsonParser.parseConfig() → applyJson()
    ├── [eec8fd7f] → LockParser → applyLock()
    └── [rssi]     → applyRssi()
                         │
                    BikeData (immutable, 78 fields)
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
    DashboardScreen  TechInfoScreen  HistoryScreen
          │
    LoggerNotifier → Drift DB → historyProvider → Charts
          │
    ForegroundService (notification alive)
    AlarmService (audio khi isAlarmSounding)
```

---

## BLE State Machine

```
BleIdle → BleScanning → BleConnecting
       → BleNegotiatingMtu → BleDiscoveringServices
       → BleConnected ← (disconnect) → BleReconnecting → BleScanning...
       → BleError
```

---

## Polling thích ứng

| App | Xe | Interval |
|---|---|---|
| Foreground | Bất kỳ | 1s |
| Background | Drive (state=3) | 5s |
| Background | Park (state=2) | 60s |
| Background | Off (state=0/1) | 1h |

DB log: Drive=30s, Park=5min, Off=1h

---

## Commands Build

```bash
# Lấy dependencies
flutter pub get

# Regenerate Drift + Riverpod code (sau khi sửa database schema)
dart run build_runner build --delete-conflicting-outputs

# Debug APK
flutter run
flutter build apk --debug

# Release APK (obfuscated)
flutter build apk --release --obfuscate --split-debug-info=build/debug-info

# Release AAB (Play Store)
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info

# Analyze
flutter analyze
```

---

## Điểm quan trọng

1. **`bike_ble_constants.dart`** — UUID decoded từ JNI C (XOR 0x5A). Đây là file quan trọng nhất, thay thế hoàn toàn `bike_secrets.c`.

2. **BLE chạy ở main isolate** — `flutter_blue_plus` dùng MethodChannel, không thể chạy trong background isolate. `ForegroundTaskHandler` chỉ giữ notification alive.

3. **`BikeData` immutable** — mọi update tạo instance mới qua `copyWith()`. Không mutate trực tiếp.

4. **Drift `.g.dart` files** — được generate bởi `build_runner`. Nếu sửa schema phải chạy lại `build_runner build`.

5. **Lock/Auth UUID chưa đầy đủ** — `eec8fd7f`, `c8eaf27b`, `c75ebe03` chỉ có prefix 8 ký tự. Cần kết nối device thực để verify full UUID 128-bit.

6. **Database migration** — `MigrationStrategy` xóa toàn bộ data khi schema thay đổi (tương đương `fallbackToDestructiveMigration`).

7. **Alarm sound file** — cần thêm `assets/sounds/alarm.mp3` vào `pubspec.yaml` assets section nếu muốn custom sound.
