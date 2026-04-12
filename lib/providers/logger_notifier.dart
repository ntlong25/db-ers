import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ble/bike_ble_freq.dart';
import '../models/bike_data.dart';
import '../models/bike_log_entry.dart';
import '../models/trip_entry.dart';
import '../services/notification_service.dart';
import 'bike_data_provider.dart';
import 'ble_connection_provider.dart';
import 'database_provider.dart';
import 'speed_alert_provider.dart';
import '../ble/ble_state.dart';

final loggerProvider = Provider<BikeLogger>((ref) {
  final logger = BikeLogger(ref);
  ref.onDispose(logger.dispose);
  return logger;
});

enum _TripState { idle, active, ending }

class BikeLogger {
  final Ref _ref;
  Timer? _logTimer;
  int _lastPcbState = -1;

  _TripState _tripState    = _TripState.idle;
  double?  _tripStartOdo;
  int?     _tripStartTime;
  double   _tripStartSoc   = 0;
  double   _tripMaxSpeed   = 0;
  double   _tripMaxTemp    = 0;
  double   _tripTotalWh    = 0;
  double   _tripLastVoltage = 0;
  double   _tripLastCurrent = 0;
  int      _tripLastTickMs  = 0;
  Timer?   _tripEndTimer;
  int      _lastSpeedAlertMs = 0;

  BikeLogger(this._ref) {
    _ref.listen(bleConnectionProvider, (prev, next) {
      if (next.isConnected) {
        _startLogging();
      } else {
        _stopLogging();
        _cancelTripEnd();
        _tripState = _TripState.idle;
      }
    });
  }

  void _startLogging() {
    _stopLogging();
    _scheduleLog(BikeBleFreq.logDrivingInterval);
  }

  void _stopLogging() {
    _logTimer?.cancel();
    _logTimer = null;
  }

  void _scheduleLog(Duration interval) {
    _logTimer?.cancel();
    _logTimer = Timer.periodic(interval, (_) async {
      final data     = _ref.read(bikeDataProvider);
      final bleState = _ref.read(bleConnectionProvider);
      if (!bleState.isConnected) { _stopLogging(); return; }

      if (data.pcbState != _lastPcbState) {
        _lastPcbState = data.pcbState;
        _scheduleLog(BikeBleFreq.getLogInterval(pcbState: data.pcbState));
        return;
      }

      await _writeLog(data);
      _processTripDetection(data);
      _checkSpeedAlert(data);
    });
  }

  Future<void> _writeLog(BikeData data) async {
    if (data.voltage == 0 && data.speed == 0) return;
    final entry = BikeLogEntry.fromBikeData(
      speed: data.speed, odo: data.odo,
      voltage: data.voltage, current: data.current, soc: data.soc,
      tempBalanceReg: data.tempBalanceReg, tempFet: data.tempFet,
      tempPin1: data.tempPin1, tempPin2: data.tempPin2,
      tempPin3: data.tempPin3, tempPin4: data.tempPin4,
      tempMotor: data.tempMotor, tempController: data.tempController,
      cellVoltages: List.from(data.cellVoltages),
    );
    try { await _ref.read(bikeLogDaoProvider).insertLog(entry); } catch (_) {}
  }

  Future<void> forceLog() async {
    final data = _ref.read(bikeDataProvider);
    if (_ref.read(bleConnectionProvider).isConnected) await _writeLog(data);
  }

  // ── Trip Detection ────────────────────────────────────────────────────────

  void _processTripDetection(BikeData data) {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    switch (_tripState) {
      case _TripState.idle:
        if (data.pcbState == 3 && data.speed > 3) {
          _tripState = _TripState.active;
          _tripStartOdo = data.odo;
          _tripStartTime = nowMs;
          _tripStartSoc = data.soc;
          _tripMaxSpeed = data.speed;
          _tripMaxTemp = data.tempMotor;
          _tripTotalWh = 0;
          _tripLastVoltage = data.voltage;
          _tripLastCurrent = data.current;
          _tripLastTickMs = nowMs;
        }
      case _TripState.active:
        _tripMaxSpeed = max(_tripMaxSpeed, data.speed);
        _tripMaxTemp  = max(_tripMaxTemp,  data.tempMotor);
        if (_tripLastTickMs > 0) {
          final dtH = (nowMs - _tripLastTickMs) / 3600000.0;
          _tripTotalWh += (_tripLastVoltage + data.voltage) / 2 *
              (_tripLastCurrent.abs() + data.current.abs()) / 2 * dtH;
        }
        _tripLastVoltage = data.voltage;
        _tripLastCurrent = data.current;
        _tripLastTickMs  = nowMs;
        if (data.pcbState != 3 || data.speed < 1) {
          _tripState = _TripState.ending;
          _tripEndTimer = Timer(const Duration(minutes: 3), () => _finalizeTrip(data));
        }
      case _TripState.ending:
        if (data.pcbState == 3 && data.speed > 3) {
          _cancelTripEnd();
          _tripState = _TripState.active;
        }
    }
  }

  Future<void> _finalizeTrip(BikeData data) async {
    _tripState = _TripState.idle;
    if (_tripStartOdo == null || _tripStartTime == null) return;
    final nowMs      = DateTime.now().millisecondsSinceEpoch;
    final durationS  = (nowMs - _tripStartTime!) ~/ 1000;
    final distanceKm = (data.odo - _tripStartOdo!).clamp(0.0, 9999.0);
    if (distanceKm < 0.1 || durationS < 60) { _tripStartOdo = null; return; }
    final entry = TripEntry(
      startTime: _tripStartTime!, endTime: nowMs,
      startOdo: _tripStartOdo!, endOdo: data.odo,
      distanceKm: distanceKm, durationSeconds: durationS,
      avgSpeedKmh: distanceKm / durationS * 3600,
      maxSpeedKmh: _tripMaxSpeed, energyWh: _tripTotalWh,
      startSoc: _tripStartSoc, endSoc: data.soc,
      maxTempMotor: _tripMaxTemp,
    );
    try { await _ref.read(tripDaoProvider).insertTrip(entry); } catch (_) {}
    _tripStartOdo = null; _tripStartTime = null;
  }

  void _cancelTripEnd() { _tripEndTimer?.cancel(); _tripEndTimer = null; }

  // ── Speed Alert ──────────────────────────────────────────────────────────

  void _checkSpeedAlert(BikeData data) {
    final threshold = _ref.read(speedAlertThresholdProvider);
    if (threshold <= 0 || data.speed < threshold) return;
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    if (nowMs - _lastSpeedAlertMs < 60000) return;
    _lastSpeedAlertMs = nowMs;
    NotificationService.showSpeedAlert(speed: data.speed, threshold: threshold);
  }

  void dispose() { _stopLogging(); _cancelTripEnd(); }
}
