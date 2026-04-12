import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../database/bike_log_dao.dart';
import '../database/trip_dao.dart';

/// Provider cho AppDatabase singleton
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase.instance;
  ref.onDispose(db.close);
  return db;
});

/// Provider cho BikeLogDao
final bikeLogDaoProvider = Provider<BikeLogDao>((ref) {
  final db = ref.watch(databaseProvider);
  return db.bikeLogDao;
});

/// Provider cho TripDao
final tripDaoProvider = Provider<TripDao>((ref) {
  final db = ref.watch(databaseProvider);
  return db.tripDao;
});
