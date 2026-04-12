/// Model cho một row trong bảng bike_logs
/// Tương đương BikeLogEntity.java (Room @Entity)
class BikeLogEntry {
  final int? id;
  final int timestamp;
  final double speed;
  final double odo;
  final double voltage;
  final double current;
  final double soc;
  final double tempBalanceReg;
  final double tempFet;
  final double tempPin1;
  final double tempPin2;
  final double tempPin3;
  final double tempPin4;
  final double tempMotor;
  final double tempController;
  final List<double> cellVoltages;

  const BikeLogEntry({
    this.id,
    required this.timestamp,
    required this.speed,
    required this.odo,
    required this.voltage,
    required this.current,
    required this.soc,
    this.tempBalanceReg = 0.0,
    this.tempFet = 0.0,
    this.tempPin1 = 0.0,
    this.tempPin2 = 0.0,
    this.tempPin3 = 0.0,
    this.tempPin4 = 0.0,
    this.tempMotor = 0.0,
    this.tempController = 0.0,
    this.cellVoltages = const [],
  });

  /// Tạo từ BikeData hiện tại
  factory BikeLogEntry.fromBikeData({
    required double speed,
    required double odo,
    required double voltage,
    required double current,
    required double soc,
    required double tempBalanceReg,
    required double tempFet,
    required double tempPin1,
    required double tempPin2,
    required double tempPin3,
    required double tempPin4,
    required double tempMotor,
    required double tempController,
    required List<double> cellVoltages,
  }) {
    return BikeLogEntry(
      timestamp: DateTime.now().millisecondsSinceEpoch,
      speed: speed,
      odo: odo,
      voltage: voltage,
      current: current,
      soc: soc,
      tempBalanceReg: tempBalanceReg,
      tempFet: tempFet,
      tempPin1: tempPin1,
      tempPin2: tempPin2,
      tempPin3: tempPin3,
      tempPin4: tempPin4,
      tempMotor: tempMotor,
      tempController: tempController,
      cellVoltages: cellVoltages,
    );
  }
}
