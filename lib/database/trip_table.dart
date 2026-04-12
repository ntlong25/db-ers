import 'package:drift/drift.dart';

/// TripTable — lưu từng chuyến đi
/// Auto-detected bởi BikeLogger khi pcbState=3 + speed > 3 km/h
class TripTable extends Table {
  @override
  String get tableName => 'trips';

  IntColumn get id => integer().autoIncrement()();

  // Thời gian
  IntColumn get startTime => integer()();        // Unix ms
  IntColumn get endTime   => integer()();        // Unix ms

  // Quãng đường
  RealColumn get startOdo    => real()();        // km
  RealColumn get endOdo      => real()();        // km
  RealColumn get distanceKm  => real()();        // km đi được

  // Thống kê
  IntColumn  get durationSeconds => integer()(); // giây
  RealColumn get avgSpeedKmh     => real()();
  RealColumn get maxSpeedKmh     => real()();

  // Năng lượng & pin
  RealColumn get energyWh  => real()();          // Wh tiêu thụ
  RealColumn get startSoc  => real()();          // % pin lúc bắt đầu
  RealColumn get endSoc    => real()();          // % pin lúc kết thúc

  // Nhiệt độ
  RealColumn get maxTempMotor => real()();       // °C max trong chuyến
}
