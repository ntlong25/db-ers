import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'bike_log_table.dart';
import 'bike_log_dao.dart';
import 'trip_table.dart';
import 'trip_dao.dart';

part 'app_database.g.dart';

/// AppDatabase — Drift database singleton
@DriftDatabase(tables: [BikeLogTable, TripTable], daos: [BikeLogDao, TripDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());

  static final AppDatabase _instance = AppDatabase._internal();
  static AppDatabase get instance => _instance;

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v1 → v2: chỉ tạo thêm bảng trips, giữ nguyên bike_logs
            await m.createTable(tripTable);
          }
          // Các upgrade tương lai: thêm if (from < 3) { ... }
        },
      );

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'bike_database.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
