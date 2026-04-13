import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bike_data_provider.dart';
import 'database_provider.dart';

/// Kết quả dự báo range thông minh
class SmartRangeResult {
  /// km dự báo còn lại dựa trên SOC hiện tại × hiệu suất trung bình
  final double predictedKm;

  /// km/% hiệu suất trung bình từ lịch sử
  final double avgKmPerPercent;

  /// km dự báo nếu pin đầy 100%
  final double fullChargeRangeKm;

  /// Số phiên xả đã dùng để tính trung bình
  final int sessionCount;

  const SmartRangeResult({
    required this.predictedKm,
    required this.avgKmPerPercent,
    required this.fullChargeRangeKm,
    required this.sessionCount,
  });

  bool get hasData => sessionCount > 0;
}

/// Provider dự báo range thông minh dựa trên lịch sử các lần sạc.
/// Dùng ref.read để không re-trigger khi bikeData thay đổi.
final smartRangeProvider = FutureProvider.autoDispose<SmartRangeResult>((ref) async {
  final dao         = ref.read(chargeCycleDaoProvider);
  final currentSoc  = ref.read(bikeDataProvider).soc;

  // Lấy trung bình km/% từ 10 phiên gần nhất
  final recent = await dao.getRecent(10);

  if (recent.isEmpty) {
    return const SmartRangeResult(
      predictedKm:       0,
      avgKmPerPercent:   0,
      fullChargeRangeKm: 0,
      sessionCount:      0,
    );
  }

  // Loại bỏ outlier (top/bottom 10% nếu đủ 5+ phiên)
  final efficiencies = recent.map((e) => e.kmPerPercent).toList()..sort();
  final filtered = efficiencies.length >= 5
      ? efficiencies.sublist(1, efficiencies.length - 1) // bỏ min + max
      : efficiencies;

  final avgKmPerPercent   = filtered.reduce((a, b) => a + b) / filtered.length;
  final predictedKm       = (avgKmPerPercent * currentSoc).clamp(0.0, 999.0);
  final fullChargeRangeKm = (avgKmPerPercent * 100).clamp(0.0, 999.0);

  return SmartRangeResult(
    predictedKm:       predictedKm,
    avgKmPerPercent:   avgKmPerPercent,
    fullChargeRangeKm: fullChargeRangeKm,
    sessionCount:      recent.length,
  );
});
