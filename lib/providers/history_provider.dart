import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bike_log_entry.dart';
import 'database_provider.dart';

/// Provider lấy logs theo khoảng thời gian — dùng cho History charts
/// FutureProvider.family nhận (startMs, endMs) làm key
final historyLogsProvider = FutureProvider.autoDispose
    .family<List<BikeLogEntry>, ({int startMs, int endMs})>(
  (ref, range) async {
    final dao = ref.watch(bikeLogDaoProvider);
    return dao.getLogsByTimeRange(range.startMs, range.endMs);
  },
);

/// Provider đếm tổng số log theo range
final historyCountProvider = FutureProvider.autoDispose
    .family<int, ({int startMs, int endMs})>(
  (ref, range) async {
    final dao = ref.watch(bikeLogDaoProvider);
    return dao.countByTimeRange(range.startMs, range.endMs);
  },
);

/// Provider lấy logs theo ngày
final logsForDayProvider = FutureProvider.autoDispose
    .family<List<BikeLogEntry>, DateTime>(
  (ref, date) async {
    final dao = ref.watch(bikeLogDaoProvider);
    return dao.getLogsForDay(date);
  },
);
