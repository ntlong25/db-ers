import 'package:drift/drift.dart';
import 'app_database.dart';
import 'charge_cycle_table.dart';
import '../models/charge_cycle_entry.dart';

part 'charge_cycle_dao.g.dart';

@DriftAccessor(tables: [ChargeCycleTable])
class ChargeCycleDao extends DatabaseAccessor<AppDatabase>
    with _$ChargeCycleDaoMixin {
  ChargeCycleDao(super.db);

  // ── Write ─────────────────────────────────────────────────────────────────

  Future<void> insertCycle(ChargeCycleEntry e) => into(chargeCycleTable).insert(
        ChargeCycleTableCompanion.insert(
          startAt:            e.startAt,
          endAt:              e.endAt,
          startSoc:           e.startSoc,
          endSoc:             e.endSoc,
          socUsed:            e.socUsed,
          startOdo:           e.startOdo,
          endOdo:             e.endOdo,
          distanceKm:         e.distanceKm,
          kmPerPercent:       e.kmPerPercent,
          projectedFullRange: e.projectedFullRange,
        ),
      );

  // ── Read ──────────────────────────────────────────────────────────────────

  Future<List<ChargeCycleEntry>> getAll() async {
    final rows = await (select(chargeCycleTable)
          ..orderBy([(t) => OrderingTerm.desc(t.startAt)]))
        .get();
    return rows.map(_map).toList();
  }

  Future<List<ChargeCycleEntry>> getRecent(int limit) async {
    final rows = await (select(chargeCycleTable)
          ..orderBy([(t) => OrderingTerm.desc(t.startAt)])
          ..limit(limit))
        .get();
    return rows.map(_map).toList();
  }

  /// Tính km/% trung bình từ N phiên gần nhất (dùng cho smart range)
  Future<double> getAvgKmPerPercent({int lastN = 10}) async {
    final rows = await (select(chargeCycleTable)
          ..orderBy([(t) => OrderingTerm.desc(t.startAt)])
          ..limit(lastN))
        .get();
    if (rows.isEmpty) return 0;
    final avg = rows.map((r) => r.kmPerPercent).reduce((a, b) => a + b) / rows.length;
    return avg;
  }

  Future<int> count() =>
      chargeCycleTable.count().getSingle();

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<void> deleteById(int id) =>
      (delete(chargeCycleTable)..where((t) => t.id.equals(id))).go();

  Future<void> deleteAll() => delete(chargeCycleTable).go();

  // ── Mapper ────────────────────────────────────────────────────────────────

  ChargeCycleEntry _map(ChargeCycleTableData r) => ChargeCycleEntry(
        id:                 r.id,
        startAt:            r.startAt,
        endAt:              r.endAt,
        startSoc:           r.startSoc,
        endSoc:             r.endSoc,
        socUsed:            r.socUsed,
        startOdo:           r.startOdo,
        endOdo:             r.endOdo,
        distanceKm:         r.distanceKm,
        kmPerPercent:       r.kmPerPercent,
        projectedFullRange: r.projectedFullRange,
      );
}
