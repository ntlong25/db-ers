import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider cho ngưỡng cảnh báo tốc độ.
/// 0 = tắt, > 0 = bật với ngưỡng tương ứng (km/h)
final speedAlertThresholdProvider =
    StateNotifierProvider<SpeedAlertNotifier, double>(
  (ref) => SpeedAlertNotifier(),
);

class SpeedAlertNotifier extends StateNotifier<double> {
  static const _key = 'speed_alert_threshold';

  SpeedAlertNotifier() : super(0) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getDouble(_key) ?? 0;
  }

  /// Đặt ngưỡng (km/h). Truyền 0 để tắt.
  Future<void> setThreshold(double kmh) async {
    state = kmh;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_key, kmh);
  }

  Future<void> disable() => setThreshold(0);

  bool get isEnabled => state > 0;
}
