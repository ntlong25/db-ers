/// TripEntry — model một chuyến đi
class TripEntry {
  final int? id;
  final int startTime;       // Unix ms
  final int endTime;         // Unix ms
  final double startOdo;     // km
  final double endOdo;       // km
  final double distanceKm;
  final int durationSeconds;
  final double avgSpeedKmh;
  final double maxSpeedKmh;
  final double energyWh;
  final double startSoc;
  final double endSoc;
  final double maxTempMotor;

  const TripEntry({
    this.id,
    required this.startTime,
    required this.endTime,
    required this.startOdo,
    required this.endOdo,
    required this.distanceKm,
    required this.durationSeconds,
    required this.avgSpeedKmh,
    required this.maxSpeedKmh,
    required this.energyWh,
    required this.startSoc,
    required this.endSoc,
    required this.maxTempMotor,
  });

  /// SOC đã tiêu thụ (%)
  double get socUsed => (startSoc - endSoc).clamp(0.0, 100.0);

  /// Hiệu suất (Wh/km) — càng thấp càng tốt
  double get efficiency => distanceKm > 0 ? energyWh / distanceKm : 0;

  /// Thời gian định dạng "HH:mm"
  String get startTimeLabel {
    final dt = DateTime.fromMillisecondsSinceEpoch(startTime);
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  /// Ngày định dạng "dd/MM"
  String get dateLabel {
    final dt = DateTime.fromMillisecondsSinceEpoch(startTime);
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}';
  }

  /// Thời lượng định dạng "HH giờ mm phút" hoặc "mm phút"
  String get durationLabel {
    final h = durationSeconds ~/ 3600;
    final m = (durationSeconds % 3600) ~/ 60;
    if (h > 0) return '${h}g ${m}p';
    return '${m} phút';
  }
}
