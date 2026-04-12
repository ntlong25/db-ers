import 'package:drift/drift.dart';
import 'app_database.dart';
import 'bike_log_table.dart';
import 'converters.dart';
import '../models/bike_log_entry.dart';

part 'bike_log_dao.g.dart';

/// DAO cho bike_logs — tương đương BikeLogDao.java (Room @Dao)
@DriftAccessor(tables: [BikeLogTable])
class BikeLogDao extends DatabaseAccessor<AppDatabase>
    with _$BikeLogDaoMixin {
  BikeLogDao(super.db);

  // ═══════════════════════════════════════════════════════
  // INSERT
  // ═══════════════════════════════════════════════════════

  Future<int> insertLog(BikeLogEntry entry) {
    return into(bikeLogTable).insert(
      BikeLogTableCompanion.insert(
        timestamp: entry.timestamp,
        speed: Value(entry.speed),
        odo: Value(entry.odo),
        voltage: Value(entry.voltage),
        current: Value(entry.current),
        soc: Value(entry.soc),
        tempBalanceReg: Value(entry.tempBalanceReg),
        tempFet: Value(entry.tempFet),
        tempPin1: Value(entry.tempPin1),
        tempPin2: Value(entry.tempPin2),
        tempPin3: Value(entry.tempPin3),
        tempPin4: Value(entry.tempPin4),
        tempMotor: Value(entry.tempMotor),
        tempController: Value(entry.tempController),
        cellVoltagesJson: Value(
            BikeConverters.cellVoltagesToJson(entry.cellVoltages)),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  // QUERY
  // ═══════════════════════════════════════════════════════

  Future<List<BikeLogEntry>> getLogsByTimeRange(
      int startMs, int endMs) async {
    final rows = await (select(bikeLogTable)
          ..where((t) => t.timestamp.isBetweenValues(startMs, endMs))
          ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]))
        .get();
    return rows.map(_rowToEntry).toList();
  }

  Future<int> countByTimeRange(int startMs, int endMs) async {
    final count = bikeLogTable.id.count();
    final query = selectOnly(bikeLogTable)
      ..addColumns([count])
      ..where(bikeLogTable.timestamp.isBetweenValues(startMs, endMs));
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  Future<List<BikeLogEntry>> getLogsForDay(DateTime date) {
    final start =
        DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
    final end = DateTime(date.year, date.month, date.day, 23, 59, 59)
        .millisecondsSinceEpoch;
    return getLogsByTimeRange(start, end);
  }

  Future<int> deleteOlderThan(int days) {
    final cutoff = DateTime.now()
        .subtract(Duration(days: days))
        .millisecondsSinceEpoch;
    return (delete(bikeLogTable)
          ..where((t) => t.timestamp.isSmallerThanValue(cutoff)))
        .go();
  }

  BikeLogEntry _rowToEntry(BikeLogTableData row) {
    return BikeLogEntry(
      id: row.id,
      timestamp: row.timestamp,
      speed: row.speed,
      odo: row.odo,
      voltage: row.voltage,
      current: row.current,
      soc: row.soc,
      tempBalanceReg: row.tempBalanceReg,
      tempFet: row.tempFet,
      tempPin1: row.tempPin1,
      tempPin2: row.tempPin2,
      tempPin3: row.tempPin3,
      tempPin4: row.tempPin4,
      tempMotor: row.tempMotor,
      tempController: row.tempController,
      cellVoltages:
          BikeConverters.cellVoltagesFromJson(row.cellVoltagesJson),
    );
  }
}
