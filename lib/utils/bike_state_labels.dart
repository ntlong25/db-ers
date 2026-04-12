/// Chuyển đổi pcbState sang label tiếng Việt
/// Tương đương các constant trong DatbikeConstants.java
class BikeStateLabels {
  BikeStateLabels._();

  static String fromPcbState(int state) {
    return switch (state) {
      0 => 'Tắt',
      1 => 'Chờ',
      2 => 'Đỗ (P)',
      3 => 'Chạy (D)',
      4 => 'Sạc',
      5 => 'Lỗi',
      _ => 'N/A',
    };
  }

  /// Drive mode badge text (D/S/P/OFF)
  static String driveBadge(int state) {
    return switch (state) {
      3 => 'D',
      2 => 'P',
      4 => 'C',  // Charging
      _ => '--',
    };
  }
}
