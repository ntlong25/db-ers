import 'package:drift/drift.dart';
import 'app_database.dart';
import 'trip_table.dart';
import '../models/trip_entry.dart';

part 'trip_dao.g.dart';

/// DAO cho trips table
@DriftAccessor(tables: [TripTable])
class TripDao extends DatabaseAccessor<AppDatabase> with _$TripDaoMixin {
  TripDao(super.db);

  // ── INSERT ───────────────────────────────────────────────────────────────

  Future<int> insertTrip(TripEntry entry) {
    return into(tripTable).insert(
      TripTableCompanion.insert(
        startTime:       entry.startTime,
        endTime:         entry.endTime,
        startOdo:        entry.startOdo,
        endOdo:          entry.endOdo,
        distanceKm:      entry.distanceKm,
        durationSeconds: entry.durationSeconds,
        avgSpeedKmh:     entry.avgSpeedKmh,
        maxSpeedKmh:     entry.maxSpeedKmh,
        energyWh:        entry.energyWh,
        startSoc:        entry.startSoc,
        endSoc:          entry.endSoc,
        maxTempMotor:    entry.maxTempMotor,
      ),
    );
  }

  // ── QUERY ────────────────────────────────────────────────────────────────

  /// Lấy tất cả chuyến đi, mới nhất trước
  Future<List<TripEntry>> getAll() async {
    final rows = await (select(tripTable)
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
        .get();
    return rows.map(_rowToEntry).toList();
  }

  /// Lấy chuyến đi trong khoảng thời gian
  Future<List<TripEntry>> getByDateRange(int startMs, int endMs) async {
    final rows = await (select(tripTable)
          ..where((t) => t.startTime.isBetweenValues(startMs, endMs))
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)]))
        .get();
    return rows.map(_rowToEntry).toList();
  }

  /// Lấy N chuyến gần nhất
  Future<List<TripEntry>> getRecent(int limit) async {
    final rows = await (select(tripTable)
          ..orderBy([(t) => OrderingTerm.desc(t.startTime)])
          ..limit(limit))
        .get();
    return rows.map(_rowToEntry).toList();
  }

  /// Tổng số chuyến đi
  Future<int> count() async {
    final expr = tripTable.id.count();
    final query = selectOnly(tripTable)..addColumns([expr]);
    final result = await query.getSingle();
    return result.read(expr) ?? 0;
  }

  // ── DELETE ───────────────────────────────────────────────────────────────

  Future<int> deleteById(int id) =>
      (delete(tripTable)..where((t) => t.id.equals(id))).go();

  Future<int> deleteAll() => delete(tripTable).go();

  // ── MAPPER ───────────────────────────────────────────────────────────────

  TripEntry _rowToEntry(TripTableData r) => TripEntry(
        id:              r.id,
        startTime:       r.startTime,
        endTime:         r.endTime,
        startOdo:        r.startOdo,
        endOdo:          r.endOdo,
        distanceKm:      r.distanceKm,
        durationSeconds: r.durationSeconds,
        avgSpeedKmh:     r.avgSpeedKmh,
        maxSpeedKmh:     r.maxSpeedKmh,
        energyWh:        r.energyWh,
        startSoc:        r.startSoc,
        endSoc:          r.endSoc,
        maxTempMotor:    r.maxTempMotor,
      );
}
