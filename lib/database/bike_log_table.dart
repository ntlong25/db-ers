import 'package:drift/drift.dart';

/// Định nghĩa bảng bike_logs trong Drift
/// Tương đương BikeLogEntity.java (Room)
///
/// NOTE: Drift có 2 cách dùng — với code-gen hoặc không.
/// Ở đây dùng cách KHÔNG code-gen (manual table definition)
/// để tránh phức tạp với build_runner trên Dart 3.3.x.
class BikeLogTable extends Table {
  @override
  String get tableName => 'bike_logs';

  // Primary key auto-increment
  IntColumn get id => integer().autoIncrement()();

  // Thời điểm ghi log (Unix timestamp ms)
  IntColumn get timestamp => integer()();

  // Thông số vận hành
  RealColumn get speed => real().withDefault(const Constant(0.0))();
  RealColumn get odo => real().withDefault(const Constant(0.0))();
  RealColumn get voltage => real().withDefault(const Constant(0.0))();
  RealColumn get current => real().withDefault(const Constant(0.0))();
  RealColumn get soc => real().withDefault(const Constant(0.0))();

  // Nhiệt độ (8 sensors)
  RealColumn get tempBalanceReg => real().withDefault(const Constant(0.0))();
  RealColumn get tempFet => real().withDefault(const Constant(0.0))();
  RealColumn get tempPin1 => real().withDefault(const Constant(0.0))();
  RealColumn get tempPin2 => real().withDefault(const Constant(0.0))();
  RealColumn get tempPin3 => real().withDefault(const Constant(0.0))();
  RealColumn get tempPin4 => real().withDefault(const Constant(0.0))();
  RealColumn get tempMotor => real().withDefault(const Constant(0.0))();
  RealColumn get tempController => real().withDefault(const Constant(0.0))();

  // Cell voltages — lưu dưới dạng JSON string (vd: "[3.7,3.71,...]")
  // TypeConverter xử lý việc decode/encode
  TextColumn get cellVoltagesJson =>
      text().withDefault(const Constant('[]'))();
}
