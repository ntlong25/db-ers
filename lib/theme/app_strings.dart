/// AppStrings — tập trung toàn bộ chuỗi hiển thị trên UI.
///
/// Cách dùng:
///   Text(S.cancel)          // static const — dùng được trong const Text()
///   Text(S.ble.scanTitle)   // instance getter — KHÔNG dùng const Text()
///
/// Alias ngắn:
///   import '../../theme/app_strings.dart';
///   // dùng S thay cho AppStrings
typedef S = AppStrings;

abstract class AppStrings {
  AppStrings._();

  // ── Nút & hành động chung (static const — dùng được với const Text) ───────
  static const String cancel      = 'Hủy';
  static const String delete      = 'Xóa';
  static const String settings    = 'Cài đặt';
  static const String confirm     = 'Xác nhận';
  static const String close       = 'Đóng';
  static const String retry       = 'Thử lại';
  static const String loading     = 'Đang tải...';
  static const String errorPrefix = 'Lỗi: ';
  static const String noData      = 'Không có dữ liệu trong khoảng thời gian này';

  // ── Nhóm (truy cập qua getter — KHÔNG dùng const Text) ───────────────────
  static const screen     = _Screen();
  static const ble        = _Ble();
  static const bike       = _Bike();
  static const battery    = _Battery();
  static const metrics    = _Metrics();
  static const history    = _History();
  static const charge     = _Charge();
  static const trip       = _Trip();
  static const health     = _Health();
  static const speedAlert = _SpeedAlert();
}

// ─────────────────────────────────────────────────────────────────────────────

class _Screen {
  const _Screen();
  String get dashboard     => 'Dashboard';
  String get history       => 'Lịch sử';
  String get techInfo      => 'Thông tin kỹ thuật';
  String get battHealth    => 'Sức khỏe Pin';
  String get trips         => 'Chuyến đi';
  String get chargeHistory => 'Lần sạc';
  String get tabCharts     => 'Biểu đồ';
  String get tabTrips      => 'Chuyến đi';
  String get tabCharges    => 'Lần sạc';
}

class _Ble {
  const _Ble();
  String get scanTitle        => 'Tìm xe Datbike';
  String get scanButton       => 'Quét & kết nối xe';
  String get scanning         => 'Đang tìm kiếm...';
  String get notFound         => 'Không tìm thấy xe';
  String get demoMode         => 'Chế độ Demo (máy ảo)';
  String get permissionNeeded => 'Cần cấp quyền Bluetooth để kết nối xe';
  String get forgetTitle      => 'Quên xe?';
  String get forgetButton     => 'Quên xe đã lưu';
  String get forgetConfirm    => 'Xóa xe đã lưu';
  String get disconnectButton => 'Ngắt kết nối';
  String get findBike         => 'Tìm xe';
  String get rescan           => 'Scan lại';
}

class _Bike {
  const _Bike();
  String get running    => 'ĐANG CHẠY';
  String get parked     => 'ĐỖ XE';
  String get off        => 'TẮT MÁY';
  String get light      => 'Đèn';
  String get locked     => 'Khóa';
  String get unlocked   => 'Mở';
  String get horn       => 'Còi';
  String get protection => 'BV';
  String get idle       => 'Idle';
}

class _Battery {
  const _Battery();
  String get remaining         => 'pin còn lại';
  String get smartRange        => 'dự báo range';
  String get firmwareRange     => 'ước tính';
  String get charging          => 'Đang sạc';
  String get discharging       => 'Đang xả';
  String get chargingSuffix    => 'Sạc';
  String get dischargingSuffix => 'Xả';
  String get sessionCount      => 'phiên sạc';
  String get cycles            => 'chu kỳ';
}

class _Metrics {
  const _Metrics();
  String get odo         => 'ODO';
  String get current     => 'Dòng điện';
  String get temperature => 'Nhiệt độ';
  String get voltage     => 'Điện áp';
  String get cycleCount  => 'Chu kỳ';
  String get status      => 'Trạng thái';
  String get motorTemp   => 'Motor';
  String get ecuTemp     => 'ECU';
  String get bmsTemp     => 'BMS';
  String get fetTemp     => 'FET';
  String get unitKmh     => 'km/h';
  String get unitKm      => 'km';
  String get unitV       => 'V';
  String get unitA       => 'A';
  String get unitWh      => 'Wh';
  String get unitDegree  => '°C';
}

class _History {
  const _History();
  String get recordSuffix => 'bản ghi';
  String get noData       => 'Không có dữ liệu trong khoảng thời gian này';
  String get exportingLog => 'Đang xuất log...';
  String get exportError  => 'Lỗi xuất log: ';
}

class _Charge {
  const _Charge();
  String get statsTitle      => 'Thống kê lịch sử sạc';
  String get sessions        => 'phiên';
  String get avgKmPerCharge  => 'TB km/lần sạc';
  String get avgSocUsed      => 'TB % tiêu thụ';
  String get avgFullRange    => 'Range đầy pin TB';
  String get noData          => 'Chưa có dữ liệu lịch sử sạc';
  String get autoRecord      => 'Dữ liệu được ghi tự động khi cắm/rút sạc';
  String get deleteSession   => 'Xóa phiên này?';
  String get distance        => 'Quãng đường';
  String get battConsumed    => 'Pin tiêu thụ';
  String get socUsed         => '% đã dùng';
  String get fullRange       => 'Range đầy pin';
  String get smartRangeTitle => 'Dự báo range thông minh';
  String get kmPerPercent    => 'km/%';
  String get recentSessions  => 'phiên gần nhất';
}

class _Trip {
  const _Trip();
  String get noTrips    => 'Chưa có chuyến đi nào';
  String get autoRecord => 'App tự động ghi khi bạn chạy xe';
  String get total      => 'Tổng cộng';
  String get distance   => 'Quãng đường';
  String get trips      => 'Chuyến đi';
  String get duration   => 'Thời gian';
  String get energy     => 'Năng lượng';
  String get avgSpeed   => 'TB tốc độ';
  String get maxSpeed   => 'Tốc độ max';
  String get battUsed   => 'Pin dùng';
  String get deleteTrip => 'Xóa chuyến đi này?';
}

class _Health {
  const _Health();
  String get cellBalance     => 'Cân bằng Cell';
  String get avgDiffPrefix   => 'Chênh lệch TB: ';
  String get capacity        => 'Dung lượng';
  String get estimatedCycles => 'Ước tính từ chu kỳ';
  String get thermalOps      => 'Nhiệt độ vận hành';
  String get samplesPrefix   => 'Phân tích ';
  String get samplesSuffix   => ' mẫu (30 ngày)';
  String get noDataYet       => 'Chưa đủ dữ liệu';
  String get cycleLife       => 'Vòng đời còn lại';
  String get chargeCycles    => 'Chu kỳ sạc';
  String get remainingCycles => 'Còn lại ~';
  String get weakCellTitle   => 'Cell yếu phát hiện';
  String get weakCellBody    => 'thấp hơn trung bình đáng kể';
  String get recommendations => 'Khuyến nghị';
}

class _SpeedAlert {
  const _SpeedAlert();
  String get title          => 'Cảnh báo tốc độ';
  String get thresholdLabel => 'Ngưỡng: ';
}
