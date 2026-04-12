/// BikeData — Model toàn cục chứa toàn bộ trạng thái xe Datbike.
/// Immutable: mọi update tạo instance mới qua copyWith().
/// Tương đương BikeData.java (78 fields).
library bike_data;

class BikeData {
  // ═══════════════════════════════════════════════════════
  // THÔNG TIN CƠ BẢN
  // ═══════════════════════════════════════════════════════

  /// Tên xe (vd: "QUANTUM S1")
  final String name;

  /// Model khung (vd: "S1", "S3")
  final String frame;

  /// Phiên bản firmware (vd: "1.2.3")
  final String fw;

  /// Hash firmware
  final String fwHash;

  /// Vehicle Identification Number
  final String vin;

  // ═══════════════════════════════════════════════════════
  // THÔNG TIN VẬN HÀNH
  // ═══════════════════════════════════════════════════════

  /// Tốc độ hiện tại (km/h)
  final double speed;

  /// Tổng quãng đường (km)
  final double odo;

  /// Quãng đường ước tính còn lại (km)
  final double kmLeft;

  /// Giá trị throttle (%)
  final double throttle;

  /// Đèn xi nhan trái
  final bool turnLeft;

  /// Đèn xi nhan phải
  final bool turnRight;

  /// Đèn đầu
  final bool headlight;

  /// Đang đỗ (parking brake)
  final bool isParking;

  /// Trạng thái PCB (0=off, 1=idle, 2=park, 3=drive, ...)
  final int pcbState;

  /// Mã lỗi PCB
  final int pcbError;

  /// Idle-off auto shutoff
  final bool idleOff;

  // ═══════════════════════════════════════════════════════
  // PIN (BMS)
  // ═══════════════════════════════════════════════════════

  /// Điện áp pack (V)
  final double voltage;

  /// Dòng điện (A), dương = xả, âm = sạc
  final double current;

  /// State of Charge (%)
  final double soc;

  /// Đang sạc
  final bool isCharging;

  /// Đang xả
  final bool isDischarging;

  /// Nhiệt độ balance resistor (°C)
  final double tempBalanceReg;

  /// Lỗi BMS
  final int bmsError;

  /// Nhiệt độ BMS trung bình (°C)
  final double tempBms;

  // ═══════════════════════════════════════════════════════
  // NHIỆT ĐỘ
  // ═══════════════════════════════════════════════════════

  /// Nhiệt độ FET (°C)
  final double tempFet;

  /// Nhiệt độ NTC sensor 1 (°C)
  final double tempPin1;

  /// Nhiệt độ NTC sensor 2 (°C)
  final double tempPin2;

  /// Nhiệt độ NTC sensor 3 (°C)
  final double tempPin3;

  /// Nhiệt độ NTC sensor 4 (°C)
  final double tempPin4;

  /// Nhiệt độ động cơ (°C)
  final double tempMotor;

  /// Nhiệt độ controller ECU (°C)
  final double tempController;

  // ═══════════════════════════════════════════════════════
  // CELL VOLTAGES (23 cells)
  // ═══════════════════════════════════════════════════════

  /// Danh sách điện áp từng cell (V)
  final List<double> cellVoltages;

  /// Cell voltage thấp nhất (V)
  final double vMin;

  /// Cell voltage cao nhất (V)
  final double vMax;

  /// Độ chênh lệch giữa vMax và vMin (V)
  final double cellDiff;

  // ═══════════════════════════════════════════════════════
  // THÔNG SỐ SỨC KHỎE PIN
  // ═══════════════════════════════════════════════════════

  /// Số chu kỳ sạc
  final int cycles;

  /// Dung lượng thực tế (Ah)
  final double currentAh;

  /// Tổng dung lượng tích lũy (Ah)
  final double absAh;

  // ═══════════════════════════════════════════════════════
  // TRẠNG THÁI KHÓA / BẢO MẬT
  // ═══════════════════════════════════════════════════════

  /// Xe đang bị khóa
  final bool isLocked;

  /// Còi báo động đang kêu
  final bool isAlarmSounding;

  /// Đã kích hoạt chế độ bảo vệ
  final bool isArmed;

  // ═══════════════════════════════════════════════════════
  // THÔNG SỐ ADC / PHỤ
  // ═══════════════════════════════════════════════════════

  /// ADC sensor 1 (throttle)
  final double adc1;

  /// ADC sensor 2 (phụ)
  final double adc2;

  // ═══════════════════════════════════════════════════════
  // KẾT NỐI
  // ═══════════════════════════════════════════════════════

  /// Cường độ tín hiệu BLE (dBm)
  final int rssi;

  /// MAC address của xe đang kết nối
  final String? connectedMac;

  // ═══════════════════════════════════════════════════════
  // CONSTRUCTOR
  // ═══════════════════════════════════════════════════════

  const BikeData({
    this.name = '',
    this.frame = '',
    this.fw = '',
    this.fwHash = '',
    this.vin = '',
    this.speed = 0.0,
    this.odo = 0.0,
    this.kmLeft = 0.0,
    this.throttle = 0.0,
    this.turnLeft = false,
    this.turnRight = false,
    this.headlight = false,
    this.isParking = false,
    this.pcbState = 0,
    this.pcbError = 0,
    this.idleOff = false,
    this.voltage = 0.0,
    this.current = 0.0,
    this.soc = 0.0,
    this.isCharging = false,
    this.isDischarging = false,
    this.tempBalanceReg = 0.0,
    this.bmsError = 0,
    this.tempBms = 0.0,
    this.tempFet = 0.0,
    this.tempPin1 = 0.0,
    this.tempPin2 = 0.0,
    this.tempPin3 = 0.0,
    this.tempPin4 = 0.0,
    this.tempMotor = 0.0,
    this.tempController = 0.0,
    this.cellVoltages = const [],
    this.vMin = 0.0,
    this.vMax = 0.0,
    this.cellDiff = 0.0,
    this.cycles = 0,
    this.currentAh = 0.0,
    this.absAh = 0.0,
    this.isLocked = false,
    this.isAlarmSounding = false,
    this.isArmed = false,
    this.adc1 = 0.0,
    this.adc2 = 0.0,
    this.rssi = 0,
    this.connectedMac,
  });

  // ═══════════════════════════════════════════════════════
  // COPY WITH
  // ═══════════════════════════════════════════════════════

  BikeData copyWith({
    String? name,
    String? frame,
    String? fw,
    String? fwHash,
    String? vin,
    double? speed,
    double? odo,
    double? kmLeft,
    double? throttle,
    bool? turnLeft,
    bool? turnRight,
    bool? headlight,
    bool? isParking,
    int? pcbState,
    int? pcbError,
    bool? idleOff,
    double? voltage,
    double? current,
    double? soc,
    bool? isCharging,
    bool? isDischarging,
    double? tempBalanceReg,
    int? bmsError,
    double? tempBms,
    double? tempFet,
    double? tempPin1,
    double? tempPin2,
    double? tempPin3,
    double? tempPin4,
    double? tempMotor,
    double? tempController,
    List<double>? cellVoltages,
    double? vMin,
    double? vMax,
    double? cellDiff,
    int? cycles,
    double? currentAh,
    double? absAh,
    bool? isLocked,
    bool? isAlarmSounding,
    bool? isArmed,
    double? adc1,
    double? adc2,
    int? rssi,
    String? connectedMac,
  }) {
    return BikeData(
      name: name ?? this.name,
      frame: frame ?? this.frame,
      fw: fw ?? this.fw,
      fwHash: fwHash ?? this.fwHash,
      vin: vin ?? this.vin,
      speed: speed ?? this.speed,
      odo: odo ?? this.odo,
      kmLeft: kmLeft ?? this.kmLeft,
      throttle: throttle ?? this.throttle,
      turnLeft: turnLeft ?? this.turnLeft,
      turnRight: turnRight ?? this.turnRight,
      headlight: headlight ?? this.headlight,
      isParking: isParking ?? this.isParking,
      pcbState: pcbState ?? this.pcbState,
      pcbError: pcbError ?? this.pcbError,
      idleOff: idleOff ?? this.idleOff,
      voltage: voltage ?? this.voltage,
      current: current ?? this.current,
      soc: soc ?? this.soc,
      isCharging: isCharging ?? this.isCharging,
      isDischarging: isDischarging ?? this.isDischarging,
      tempBalanceReg: tempBalanceReg ?? this.tempBalanceReg,
      bmsError: bmsError ?? this.bmsError,
      tempBms: tempBms ?? this.tempBms,
      tempFet: tempFet ?? this.tempFet,
      tempPin1: tempPin1 ?? this.tempPin1,
      tempPin2: tempPin2 ?? this.tempPin2,
      tempPin3: tempPin3 ?? this.tempPin3,
      tempPin4: tempPin4 ?? this.tempPin4,
      tempMotor: tempMotor ?? this.tempMotor,
      tempController: tempController ?? this.tempController,
      cellVoltages: cellVoltages ?? this.cellVoltages,
      vMin: vMin ?? this.vMin,
      vMax: vMax ?? this.vMax,
      cellDiff: cellDiff ?? this.cellDiff,
      cycles: cycles ?? this.cycles,
      currentAh: currentAh ?? this.currentAh,
      absAh: absAh ?? this.absAh,
      isLocked: isLocked ?? this.isLocked,
      isAlarmSounding: isAlarmSounding ?? this.isAlarmSounding,
      isArmed: isArmed ?? this.isArmed,
      adc1: adc1 ?? this.adc1,
      adc2: adc2 ?? this.adc2,
      rssi: rssi ?? this.rssi,
      connectedMac: connectedMac ?? this.connectedMac,
    );
  }

  // ═══════════════════════════════════════════════════════
  // COMPUTED PROPERTIES
  // ═══════════════════════════════════════════════════════

  /// Công suất tức thời (W)
  double get power => voltage * current;

  /// Cell voltage có cảnh báo chênh lệch nguy hiểm (> 0.1V)
  bool get isCellDiffDanger => cellDiff > 0.1;

  /// Cell voltage có cảnh báo chênh lệch nhẹ (> 0.04V)
  bool get isCellDiffWarning => cellDiff > 0.04;

  /// Số bars tín hiệu BLE (0–4)
  int get signalBars {
    if (rssi >= -60) return 4;
    if (rssi >= -70) return 3;
    if (rssi >= -80) return 2;
    if (rssi >= -90) return 1;
    return 0;
  }

  /// Xe đang chạy (pcbState == 3)
  bool get isDriving => pcbState == 3;

  /// Xe đang đỗ (pcbState == 2)
  bool get isParked => pcbState == 2;

  /// Xe tắt máy (pcbState == 0 hoặc 1)
  bool get isOff => pcbState <= 1;

  @override
  String toString() =>
      'BikeData(name=$name, speed=$speed, soc=$soc%, pcbState=$pcbState)';
}
