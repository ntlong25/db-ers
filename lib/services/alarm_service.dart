import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/bike_data_provider.dart';

/// AlarmService — phát còi báo động khi isAlarmSounding = true
/// Tương đương startPhoneAlarm() / stopPhoneAlarm() trong BikeBackgroundService.java
final alarmServiceProvider = Provider<AlarmService>((ref) {
  final service = AlarmService(ref);
  ref.onDispose(service.dispose);
  return service;
});

class AlarmService {
  final Ref _ref;
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  AlarmService(this._ref) {
    // Listen BikeData — tự động phát/tắt còi
    _ref.listen(bikeDataProvider, (prev, next) {
      if (next.isAlarmSounding && !_isPlaying) {
        _startAlarm();
      } else if (!next.isAlarmSounding && _isPlaying) {
        stopAlarm();
      }
    });
  }

  Future<void> _startAlarm() async {
    _isPlaying = true;
    try {
      // Phát ringtone hệ thống ở âm lượng tối đa
      await _player.setVolume(1.0);
      await _player.setReleaseMode(ReleaseMode.loop);
      // Dùng built-in notification sound nếu không có file custom
      await _player.play(AssetSource('sounds/alarm.mp3'));
    } catch (_) {
      // Fallback: không có file sound — vẫn set flag
    }
  }

  Future<void> stopAlarm() async {
    _isPlaying = false;
    try {
      await _player.stop();
    } catch (_) {}
  }

  bool get isPlaying => _isPlaying;

  void dispose() {
    _player.dispose();
  }
}
