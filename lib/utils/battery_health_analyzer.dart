import '../models/bike_data.dart';
import '../models/bike_log_entry.dart';

/// BatteryHealthReport — kết quả phân tích sức khỏe pin
class BatteryHealthReport {
  final int overallScore;       // 0-100
  final int cellBalanceScore;   // 0-100
  final int capacityScore;      // 0-100 (dựa trên cycles)
  final int thermalScore;       // 0-100
  final int cycleLifeScore;     // 0-100 (vòng đời còn lại)
  final int cycles;
  final double currentAh;
  final double avgCellDiffMv;   // mV trung bình trong 30 ngày
  final List<int> weakCellIndices; // index các cell yếu nhất
  final List<String> recommendations;
  final int logCount;           // số điểm dữ liệu phân tích

  const BatteryHealthReport({
    required this.overallScore,
    required this.cellBalanceScore,
    required this.capacityScore,
    required this.thermalScore,
    required this.cycleLifeScore,
    required this.cycles,
    required this.currentAh,
    required this.avgCellDiffMv,
    required this.weakCellIndices,
    required this.recommendations,
    required this.logCount,
  });

  /// Nhãn mô tả trạng thái tổng thể
  String get statusLabel {
    if (overallScore >= 85) return 'RẤT TỐT';
    if (overallScore >= 70) return 'TỐT';
    if (overallScore >= 50) return 'TRUNG BÌNH';
    return 'CẦN CHÚ Ý';
  }

  /// Màu theo trạng thái (hex string để dùng ở widget)
  int get statusColorValue {
    if (overallScore >= 85) return 0xFF00E676;  // success green
    if (overallScore >= 70) return 0xFF00E5FF;  // accent blue
    if (overallScore >= 50) return 0xFFFFAB00;  // warning amber
    return 0xFFFF1744;                           // danger red
  }
}

/// BatteryHealthAnalyzer — phân tích sức khỏe pin từ log + BikeData hiện tại
class BatteryHealthAnalyzer {
  static const double _nominalCapacityAh = 48.5; // Datbike S1/S3
  static const int _maxCycles = 500;
  static const double _overTempThreshold = 70.0; // °C

  static BatteryHealthReport analyze({
    required List<BikeLogEntry> recentLogs,
    required BikeData current,
  }) {
    // ── 1. Cell Balance Score ─────────────────────────────────────────────
    // Dựa trên cellDiff lịch sử — lấy từ logs nếu có, không thì dùng current
    final cellDiffs = <double>[];

    for (final log in recentLogs) {
      if (log.cellVoltages.length >= 2) {
        final vMin = log.cellVoltages.reduce((a, b) => a < b ? a : b);
        final vMax = log.cellVoltages.reduce((a, b) => a > b ? a : b);
        cellDiffs.add((vMax - vMin) * 1000); // → mV
      }
    }

    if (cellDiffs.isEmpty && current.cellVoltages.length >= 2) {
      cellDiffs.add(current.cellDiff * 1000);
    }

    final avgCellDiffMv = cellDiffs.isEmpty
        ? 0.0
        : cellDiffs.reduce((a, b) => a + b) / cellDiffs.length;

    // 0mV → 100%, 20mV → 80%, 60mV → 40%, 100mV → 0%
    final cellBalanceScore = (100 - avgCellDiffMv).clamp(0.0, 100.0).toInt();

    // ── 2. Capacity Score ────────────────────────────────────────────────
    // Ước tính từ currentAh nếu > 0, fallback về cycles
    int capacityScore;
    if (current.currentAh > 1.0) {
      capacityScore =
          ((current.currentAh / _nominalCapacityAh) * 100).clamp(0.0, 100.0).toInt();
    } else {
      // Dùng cycles: mỗi 100 cycles giảm ~4% dung lượng (LiFePO4)
      final degradation = (current.cycles / _maxCycles) * 20.0;
      capacityScore = (100.0 - degradation).clamp(0.0, 100.0).toInt();
    }

    // ── 3. Thermal Score ─────────────────────────────────────────────────
    // Tỷ lệ số lần nhiệt độ motor vượt ngưỡng
    int thermalScore = 100;
    if (recentLogs.isNotEmpty) {
      final hotCount = recentLogs
          .where((l) => l.tempMotor > _overTempThreshold)
          .length;
      final hotRatio = hotCount / recentLogs.length;
      thermalScore = (100 - hotRatio * 100).clamp(0.0, 100.0).toInt();
    }

    // ── 4. Cycle Life Score ───────────────────────────────────────────────
    final cycleLifeScore =
        (100 - (current.cycles / _maxCycles) * 100).clamp(0.0, 100.0).toInt();

    // ── 5. Overall Score (weighted) ───────────────────────────────────────
    final overallScore = (cellBalanceScore * 0.30 +
            capacityScore * 0.30 +
            thermalScore * 0.20 +
            cycleLifeScore * 0.20)
        .round()
        .clamp(0, 100);

    // ── 6. Weak cells ─────────────────────────────────────────────────────
    final weakCells = <int>[];
    if (current.cellVoltages.isNotEmpty) {
      final indexed = current.cellVoltages.asMap().entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));
      // Lấy 3 cell thấp nhất nếu thấp hơn trung bình > 20mV
      final avg = current.cellVoltages.reduce((a, b) => a + b) /
          current.cellVoltages.length;
      for (final e in indexed.take(3)) {
        if ((avg - e.value) * 1000 > 20) weakCells.add(e.key);
      }
    }

    // ── 7. Recommendations ───────────────────────────────────────────────
    final recs = <String>[];

    if (avgCellDiffMv > 80) {
      recs.add('⚡ Cân bằng pin gấp — cell lệch ${avgCellDiffMv.toStringAsFixed(0)} mV');
    } else if (avgCellDiffMv > 40) {
      recs.add('🔋 Nên thực hiện cân bằng pin (${avgCellDiffMv.toStringAsFixed(0)} mV)');
    }

    if (capacityScore < 75) {
      recs.add('⚠️ Dung lượng pin giảm còn ~$capacityScore% — cân nhắc kiểm tra BMS');
    }

    if (thermalScore < 70) {
      recs.add('🌡️ Xe thường xuyên quá nhiệt (>$_overTempThreshold°C) — kiểm tra làm mát');
    }

    if (current.cycles > 400) {
      recs.add('🔁 Pin đã ${current.cycles} chu kỳ — gần đến giới hạn khuyến nghị ($_maxCycles)');
    } else if (current.cycles > 300) {
      recs.add('🔁 ${current.cycles} chu kỳ — theo dõi sức khỏe pin định kỳ');
    }

    if (weakCells.isNotEmpty) {
      recs.add('🔍 Cell ${weakCells.map((i) => i + 1).join(', ')} thấp hơn trung bình');
    }

    if (recs.isEmpty) {
      recs.add('✅ Pin trong trạng thái tốt — tiếp tục theo dõi định kỳ');
    }

    return BatteryHealthReport(
      overallScore:      overallScore,
      cellBalanceScore:  cellBalanceScore,
      capacityScore:     capacityScore,
      thermalScore:      thermalScore,
      cycleLifeScore:    cycleLifeScore,
      cycles:            current.cycles,
      currentAh:         current.currentAh,
      avgCellDiffMv:     avgCellDiffMv,
      weakCellIndices:   weakCells,
      recommendations:   recs,
      logCount:          recentLogs.length,
    );
  }
}
