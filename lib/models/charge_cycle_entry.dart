import 'package:intl/intl.dart';

/// Model cho một phiên xả pin (giữa 2 lần sạc)
class ChargeCycleEntry {
  final int    id;
  final int    startAt;
  final int    endAt;
  final double startSoc;
  final double endSoc;
  final double socUsed;
  final double startOdo;
  final double endOdo;
  final double distanceKm;
  final double kmPerPercent;
  final double projectedFullRange;

  const ChargeCycleEntry({
    required this.id,
    required this.startAt,
    required this.endAt,
    required this.startSoc,
    required this.endSoc,
    required this.socUsed,
    required this.startOdo,
    required this.endOdo,
    required this.distanceKm,
    required this.kmPerPercent,
    required this.projectedFullRange,
  });

  // ── Computed ──────────────────────────────────────────────────────────────

  /// Thời lượng phiên (milliseconds)
  int get durationMs => endAt - startAt;

  /// Nhãn ngày
  String get dateLabel {
    final dt = DateTime.fromMillisecondsSinceEpoch(startAt);
    return DateFormat('dd/MM/yyyy').format(dt);
  }

  /// Nhãn giờ bắt đầu
  String get startTimeLabel {
    final dt = DateTime.fromMillisecondsSinceEpoch(startAt);
    return DateFormat('HH:mm').format(dt);
  }

  /// Nhãn giờ kết thúc
  String get endTimeLabel {
    final dt = DateTime.fromMillisecondsSinceEpoch(endAt);
    return DateFormat('HH:mm').format(dt);
  }
}
