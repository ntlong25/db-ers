import 'package:drift/drift.dart';

/// ChargeCycleTable — lưu mỗi lần xả pin (1 lần sạc → đi → hết)
/// Một record = từ khi xe hết sạc (charging off) → đến khi cắm sạc lại (charging on)
class ChargeCycleTable extends Table {
  @override
  String get tableName => 'charge_cycles';

  IntColumn get id => integer().autoIncrement()();

  // Thời gian phiên xả
  IntColumn get startAt => integer()();   // Unix ms — khi charging kết thúc, bắt đầu xả
  IntColumn get endAt   => integer()();   // Unix ms — khi cắm sạc lại

  // Pin
  RealColumn get startSoc  => real()();   // % pin lúc bắt đầu xả (sau khi sạc xong)
  RealColumn get endSoc    => real()();   // % pin lúc cắm sạc lại
  RealColumn get socUsed   => real()();   // % pin đã dùng = startSoc - endSoc

  // Quãng đường
  RealColumn get startOdo   => real()();  // km odometer lúc bắt đầu
  RealColumn get endOdo     => real()();  // km odometer lúc cắm sạc
  RealColumn get distanceKm => real()();  // km đi được

  // Hiệu suất
  RealColumn get kmPerPercent       => real()(); // km / 1% pin
  RealColumn get projectedFullRange => real()(); // km ước tính 1 lần sạc đầy = distanceKm / socUsed * 100
}
