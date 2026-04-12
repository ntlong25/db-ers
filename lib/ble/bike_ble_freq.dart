/// Adaptive polling frequency — tương đương BikeBleFreq.java
///
/// Điều chỉnh tần suất polling BLE dựa trên:
/// - Trạng thái app (foreground / background)
/// - Trạng thái xe (pcbState)
class BikeBleFreq {
  BikeBleFreq._();

  // ═══════════════════════════════════════════════════════
  // PCB STATE VALUES (khớp với DatbikeConstants.java)
  // ═══════════════════════════════════════════════════════
  static const int pcbOff = 0;
  static const int pcbIdle = 1;
  static const int pcbPark = 2;
  static const int pcbDrive = 3;
  static const int pcbCharging = 4;

  // ═══════════════════════════════════════════════════════
  // POLLING INTERVALS
  // ═══════════════════════════════════════════════════════

  /// Foreground — bất kỳ trạng thái xe (1 giây)
  static const Duration foregroundInterval = Duration(seconds: 1);

  /// Background + đang chạy (5 giây)
  static const Duration backgroundDrivingInterval = Duration(seconds: 5);

  /// Background + đỗ xe (60 giây)
  static const Duration backgroundParkInterval = Duration(seconds: 60);

  /// Background + đang sạc (5 phút)
  static const Duration backgroundChargingInterval = Duration(minutes: 5);

  /// Background + tắt máy (1 giờ)
  static const Duration backgroundOffInterval = Duration(hours: 1);

  // ═══════════════════════════════════════════════════════
  // DATABASE LOG INTERVALS
  // ═══════════════════════════════════════════════════════

  /// Ghi DB khi đang chạy (30 giây)
  static const Duration logDrivingInterval = Duration(seconds: 30);

  /// Ghi DB khi đỗ xe (5 phút)
  static const Duration logParkInterval = Duration(minutes: 5);

  /// Ghi DB khi tắt máy (1 giờ)
  static const Duration logOffInterval = Duration(hours: 1);

  // ═══════════════════════════════════════════════════════
  // RSSI READ INTERVAL
  // ═══════════════════════════════════════════════════════
  static const Duration rssiInterval = Duration(milliseconds: 300);

  // ═══════════════════════════════════════════════════════
  // LOGIC
  // ═══════════════════════════════════════════════════════

  /// Tính polling interval dựa vào trạng thái hiện tại
  static Duration getPollingInterval({
    required bool isAppForeground,
    required int pcbState,
  }) {
    if (isAppForeground) return foregroundInterval;

    return switch (pcbState) {
      pcbDrive => backgroundDrivingInterval,
      pcbPark => backgroundParkInterval,
      pcbCharging => backgroundChargingInterval,
      _ => backgroundOffInterval, // pcbOff, pcbIdle, unknown
    };
  }

  /// Tính database log interval
  static Duration getLogInterval({required int pcbState}) {
    return switch (pcbState) {
      pcbDrive => logDrivingInterval,
      pcbPark => logParkInterval,
      _ => logOffInterval,
    };
  }

  /// Xe đang chạy (cần log thường xuyên hơn)
  static bool isDriving(int pcbState) => pcbState == pcbDrive;

  /// Xe đang đỗ
  static bool isParked(int pcbState) => pcbState == pcbPark;

  /// Xe tắt máy
  static bool isOff(int pcbState) => pcbState <= pcbIdle;
}
