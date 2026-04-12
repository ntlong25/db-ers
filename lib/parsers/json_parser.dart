import 'dart:convert';
import '../models/bike_data.dart';

/// Parser cho JSON data từ BLE characteristics:
/// - kCharBatteryLog (84c7be0b): BMS, cell voltages, NTC sensors
/// - kCharBikeLog (018e6a6f): firmware, VIN, PCB state, throttle ADC
///
/// Tương đương DataParser.parseJson() trong Android.
class JsonParser {
  JsonParser._();

  /// Parse raw bytes từ characteristic, tự detect loại JSON (BMS hay config)
  static BikeData parse(List<int> bytes, BikeData existing) {
    try {
      final jsonStr = utf8.decode(bytes);
      final Map<String, dynamic> json = jsonDecode(jsonStr);

      // Detect loại packet dựa vào key có trong JSON
      if (json.containsKey('voltage') || json.containsKey('cellVols')) {
        return _parseBms(json, existing);
      } else if (json.containsKey('firmware') || json.containsKey('mainPcb')) {
        return _parseConfig(json, existing);
      }
    } catch (_) {
      // Bỏ qua nếu không parse được
    }
    return existing;
  }

  // ═══════════════════════════════════════════════════════
  // BMS PACKET (kCharBatteryLog)
  // ═══════════════════════════════════════════════════════

  static BikeData _parseBms(Map<String, dynamic> json, BikeData existing) {
    // --- Điện áp / dòng điện ---
    final voltage = _toDouble(json['voltage']);
    final current = _toDouble(json['current']);

    // --- SOC ---
    double soc = existing.soc;
    final socObj = json['soc'];
    if (socObj is Map) {
      soc = _toDouble(socObj['percent'] ?? socObj['soc'] ?? socObj['value']);
    } else if (socObj != null) {
      soc = _toDouble(socObj);
    }

    // --- Trạng thái sạc ---
    final isCharging = _toBool(json['isCharging'] ?? json['charging']);
    final isDischarging = _toBool(json['isDischarging'] ?? json['discharging']);

    // --- Nhiệt độ BMS / FET ---
    double tempBms = existing.tempBms;
    double tempFet = existing.tempFet;
    double tempBalanceReg = existing.tempBalanceReg;

    final temps = json['temps'];
    if (temps is Map) {
      tempBms = _toDouble(temps['bms'] ?? temps['avg']);
      tempFet = _toDouble(temps['fet'] ?? temps['mosfet']);
      tempBalanceReg = _toDouble(temps['balanceReg'] ?? temps['balance']);
    } else {
      tempFet = _toDouble(json['tempFet'] ?? json['fetTemp']);
      tempBms = _toDouble(json['tempBms'] ?? json['bmsTemp']);
      tempBalanceReg = _toDouble(json['tempBalanceReg']);
    }

    // --- NTC sensors (4 cảm biến nhiệt NTC) ---
    double tempPin1 = existing.tempPin1;
    double tempPin2 = existing.tempPin2;
    double tempPin3 = existing.tempPin3;
    double tempPin4 = existing.tempPin4;

    final ntcs = json['NTCs'] ?? json['ntcs'] ?? json['ntcTemps'];
    if (ntcs is List && ntcs.length >= 4) {
      tempPin1 = _toDouble(ntcs[0]);
      tempPin2 = _toDouble(ntcs[1]);
      tempPin3 = _toDouble(ntcs[2]);
      tempPin4 = _toDouble(ntcs[3]);
    } else if (ntcs is List) {
      if (ntcs.isNotEmpty) tempPin1 = _toDouble(ntcs[0]);
      if (ntcs.length > 1) tempPin2 = _toDouble(ntcs[1]);
      if (ntcs.length > 2) tempPin3 = _toDouble(ntcs[2]);
      if (ntcs.length > 3) tempPin4 = _toDouble(ntcs[3]);
    }

    // --- Cell voltages (23 cells) ---
    List<double> cellVoltages = existing.cellVoltages;
    double vMin = existing.vMin;
    double vMax = existing.vMax;
    double cellDiff = existing.cellDiff;

    final cellsRaw = json['cellVols'] ?? json['cellVoltages'] ?? json['cells'];
    if (cellsRaw is List && cellsRaw.isNotEmpty) {
      cellVoltages = cellsRaw.map((e) => _toDouble(e)).toList();
      if (cellVoltages.isNotEmpty) {
        vMin = cellVoltages.reduce((a, b) => a < b ? a : b);
        vMax = cellVoltages.reduce((a, b) => a > b ? a : b);
        cellDiff = vMax - vMin;
      }
    }

    // --- Chu kỳ sạc / dung lượng ---
    final cycles = _toInt(json['cycles'] ?? json['chargeCycles']);
    final currentAh = _toDouble(json['currentAh'] ?? json['capacityAh']);
    final absAh = _toDouble(json['absAh'] ?? json['totalAh']);

    // --- Lỗi BMS ---
    final bmsError = _toInt(json['bmsError'] ?? json['error']);

    return existing.copyWith(
      voltage: voltage > 0 ? voltage : existing.voltage,
      current: current != 0 ? current : existing.current,
      soc: soc > 0 ? soc.clamp(0.0, 100.0) : existing.soc,
      isCharging: isCharging,
      isDischarging: isDischarging,
      tempBms: tempBms > 0 ? tempBms : existing.tempBms,
      tempFet: tempFet > 0 ? tempFet : existing.tempFet,
      tempBalanceReg: tempBalanceReg > 0 ? tempBalanceReg : existing.tempBalanceReg,
      tempPin1: tempPin1 > 0 ? tempPin1 : existing.tempPin1,
      tempPin2: tempPin2 > 0 ? tempPin2 : existing.tempPin2,
      tempPin3: tempPin3 > 0 ? tempPin3 : existing.tempPin3,
      tempPin4: tempPin4 > 0 ? tempPin4 : existing.tempPin4,
      cellVoltages: cellVoltages.isNotEmpty ? cellVoltages : existing.cellVoltages,
      vMin: vMin > 0 ? vMin : existing.vMin,
      vMax: vMax > 0 ? vMax : existing.vMax,
      cellDiff: cellDiff >= 0 ? cellDiff : existing.cellDiff,
      cycles: cycles > 0 ? cycles : existing.cycles,
      currentAh: currentAh > 0 ? currentAh : existing.currentAh,
      absAh: absAh > 0 ? absAh : existing.absAh,
      bmsError: bmsError,
    );
  }

  // ═══════════════════════════════════════════════════════
  // CONFIG PACKET (kCharBikeLog)
  // ═══════════════════════════════════════════════════════

  static BikeData _parseConfig(Map<String, dynamic> json, BikeData existing) {
    // --- Thông tin firmware ---
    String fw = existing.fw;
    String fwHash = existing.fwHash;
    final fwObj = json['firmware'];
    if (fwObj is Map) {
      fw = fwObj['version']?.toString() ?? existing.fw;
      fwHash = fwObj['hash']?.toString() ?? existing.fwHash;
    } else if (fwObj != null) {
      fw = fwObj.toString();
    }

    // --- Main PCB info ---
    String name = existing.name;
    String frame = existing.frame;
    String vin = existing.vin;
    double odo = existing.odo;
    int pcbState = existing.pcbState;
    bool idleOff = existing.idleOff;

    final pcb = json['mainPcb'] ?? json['pcb'];
    if (pcb is Map) {
      name = pcb['name']?.toString() ?? existing.name;
      frame = pcb['frame']?.toString() ?? existing.frame;
      vin = pcb['vin']?.toString() ?? existing.vin;
      odo = _toDouble(pcb['odo'] ?? pcb['odometer']);
      pcbState = _toInt(pcb['state'] ?? pcb['pcbState']);
      idleOff = _toBool(pcb['idleOff'] ?? pcb['idle_off']);
    } else {
      name = json['name']?.toString() ?? existing.name;
      vin = json['vin']?.toString() ?? existing.vin;
    }

    // --- Controller / ADC ---
    double adc1 = existing.adc1;
    double adc2 = existing.adc2;
    double throttle = existing.throttle;
    double tempController = existing.tempController;
    double tempMotor = existing.tempMotor;

    final controller = json['controller'];
    if (controller is Map) {
      adc1 = _toDouble(controller['adc1'] ?? controller['throttleAdc']);
      adc2 = _toDouble(controller['adc2'] ?? controller['adc']);
      throttle = _toDouble(controller['throttle']);
      tempController = _toDouble(controller['temp'] ?? controller['temperature']);
    }

    // Motor temp có thể trong config
    tempMotor = _toDouble(json['motorTemp'] ?? json['tempMotor']) > 0
        ? _toDouble(json['motorTemp'] ?? json['tempMotor'])
        : existing.tempMotor;

    return existing.copyWith(
      fw: fw.isNotEmpty ? fw : existing.fw,
      fwHash: fwHash.isNotEmpty ? fwHash : existing.fwHash,
      name: name.isNotEmpty ? name : existing.name,
      frame: frame.isNotEmpty ? frame : existing.frame,
      vin: vin.isNotEmpty ? vin : existing.vin,
      odo: odo > 0 ? odo : existing.odo,
      pcbState: pcbState >= 0 ? pcbState : existing.pcbState,
      idleOff: idleOff,
      adc1: adc1,
      adc2: adc2,
      throttle: throttle > 0 ? throttle : existing.throttle,
      tempController: tempController > 0 ? tempController : existing.tempController,
      tempMotor: tempMotor > 0 ? tempMotor : existing.tempMotor,
    );
  }

  // ═══════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value.isNaN || value.isInfinite ? 0.0 : value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static bool _toBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) return value == '1' || value.toLowerCase() == 'true';
    return false;
  }
}
