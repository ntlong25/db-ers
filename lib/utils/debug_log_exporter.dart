import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../database/bike_log_dao.dart';
import '../models/bike_log_entry.dart';

/// DebugLogExporter — xuất log DB thành file mã hóa và share
/// Phase 5: triple-tap → export → share_plus
///
/// XOR key: 0x5A (cùng key đã dùng trong bike_secrets.c)
/// Format: CSV với header, mã hóa từng byte
class DebugLogExporter {
  static const int _xorKey = 0x5A;

  /// Export tất cả log trong 24h gần nhất ra file, share qua share_plus
  static Future<void> export(BikeLogDao dao) async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(hours: 24));
    final startMs = yesterday.millisecondsSinceEpoch;
    final endMs = now.millisecondsSinceEpoch;

    // Lấy logs từ DB
    final logs = await dao.getLogsByTimeRange(startMs, endMs);

    // Build CSV content
    final csv = _buildCsv(logs);

    // XOR encrypt
    final encrypted = _xorEncrypt(utf8.encode(csv));

    // Ghi ra file temp
    final dir = await getTemporaryDirectory();
    final ts = now.toIso8601String().replaceAll(':', '-').substring(0, 19);
    final file = File('${dir.path}/dtc_bike_log_$ts.log');
    await file.writeAsBytes(encrypted);

    // Share
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/octet-stream')],
      subject: 'DTC Bike Log — $ts',
      text: '${logs.length} bản ghi từ ${yesterday.toString().substring(0, 16)} đến ${now.toString().substring(0, 16)}',
    );
  }

  /// Build CSV từ list log entries
  static String _buildCsv(List<BikeLogEntry> logs) {
    final buf = StringBuffer();

    // Header
    buf.writeln(
      'timestamp,speed,odo,voltage,current,soc,'
      'tempBalReg,tempFet,tempPin1,tempPin2,tempPin3,tempPin4,tempMotor,tempController,'
      'vMin,vMax,cellDiff',
    );

    for (final e in logs) {
      final ts = DateTime.fromMillisecondsSinceEpoch(e.timestamp);
      final cells = e.cellVoltages;
      final vMin = cells.isEmpty ? 0.0 : cells.reduce((a, b) => a < b ? a : b);
      final vMax = cells.isEmpty ? 0.0 : cells.reduce((a, b) => a > b ? a : b);
      final diff = vMax - vMin;

      buf.writeln(
        '${ts.toIso8601String()},'
        '${e.speed.toStringAsFixed(1)},'
        '${e.odo.toStringAsFixed(1)},'
        '${e.voltage.toStringAsFixed(3)},'
        '${e.current.toStringAsFixed(2)},'
        '${e.soc.toStringAsFixed(1)},'
        '${e.tempBalanceReg.toStringAsFixed(1)},'
        '${e.tempFet.toStringAsFixed(1)},'
        '${e.tempPin1.toStringAsFixed(1)},'
        '${e.tempPin2.toStringAsFixed(1)},'
        '${e.tempPin3.toStringAsFixed(1)},'
        '${e.tempPin4.toStringAsFixed(1)},'
        '${e.tempMotor.toStringAsFixed(1)},'
        '${e.tempController.toStringAsFixed(1)},'
        '${vMin.toStringAsFixed(3)},'
        '${vMax.toStringAsFixed(3)},'
        '${(diff * 1000).toStringAsFixed(0)}',
      );
    }

    return buf.toString();
  }

  /// XOR encrypt bytes với key 0x5A
  static List<int> _xorEncrypt(List<int> bytes) {
    return bytes.map((b) => b ^ _xorKey).toList();
  }

  /// Giải mã file đã XOR (dùng key giống nhau)
  static List<int> xorDecrypt(List<int> encrypted) {
    return _xorEncrypt(encrypted); // XOR là đối xứng
  }
}
