import 'dart:typed_data';
import '../models/bike_data.dart';

/// Parser cho 41-byte binary dashboard packet
/// Tương đương DashboardTelemetry.java + DataParser.parseBinary()
///
/// Byte map (little-endian):
/// offset  0 : float32 — odo (km)
/// offset  4 : float32 — speed (km/h)
/// offset  8 : float32 — current (A)
/// offset 12 : uint8   — isLeftTurn (1 = on)
/// offset 13 : uint8   — isRightTurn (1 = on)
/// offset 14 : uint8   — isParking (1 = on)
/// offset 15 : float32 — voltage (V)  ← UNALIGNED, ByteData handles safely
/// offset 19 : uint8   — batteryPercent (0–100)
/// offset 20 : float32 — batteryTemp / tempBalanceReg (°C)
/// offset 24 : float32 — motorTemp (°C)
/// offset 28 : float32 — controllerTemp (°C)
/// offset 32 : uint8   — pcbState
/// offset 33 : uint8   — pcbError
/// offset 34 : uint8   — headlight (1 = on)
/// offset 35 : uint8   — idleOff (1 = active)
/// offset 36 : uint8   — reserved / throttle raw
/// offset 37 : float32 — estimatedRange (km)  ← chỉ có khi len >= 41
class DashboardParser {
  DashboardParser._();

  /// Parse 41-byte binary packet, trả về BikeData mới từ existing state.
  /// Không thay đổi các field không thuộc dashboard packet.
  static BikeData parse(List<int> bytes, BikeData existing) {
    if (bytes.length < 33) {
      // Packet quá ngắn, bỏ qua
      return existing;
    }

    final data = ByteData.sublistView(Uint8List.fromList(bytes));

    final odo = data.getFloat32(0, Endian.little);
    final speed = data.getFloat32(4, Endian.little);
    final current = data.getFloat32(8, Endian.little);
    final isLeftTurn = data.getUint8(12) == 1;
    final isRightTurn = data.getUint8(13) == 1;
    final isParking = data.getUint8(14) == 1;
    final voltage = data.getFloat32(15, Endian.little); // unaligned — safe
    final batteryPercent = data.getUint8(19).toDouble();
    final tempBalanceReg = data.getFloat32(20, Endian.little);
    final tempMotor = data.getFloat32(24, Endian.little);
    final tempController = data.getFloat32(28, Endian.little);
    final pcbState = data.getUint8(32);
    final pcbError = bytes.length > 33 ? data.getUint8(33) : 0;

    bool headlight = existing.headlight;
    bool idleOff = existing.idleOff;
    double throttle = existing.throttle;
    if (bytes.length > 34) headlight = data.getUint8(34) == 1;
    if (bytes.length > 35) idleOff = data.getUint8(35) == 1;
    if (bytes.length > 36) throttle = data.getUint8(36).toDouble();

    // estimatedRange chỉ có khi packet >= 41 bytes
    double kmLeft = existing.kmLeft;
    if (bytes.length >= 41) {
      kmLeft = data.getFloat32(37, Endian.little);
    } else if (bytes.length >= 40) {
      // Fallback: tính từ SOC (xe cũ gửi 40 bytes)
      kmLeft = batteryPercent * 2.0;
    }

    return existing.copyWith(
      odo: _sanitize(odo),
      speed: _sanitize(speed),
      current: _sanitize(current),
      turnLeft: isLeftTurn,
      turnRight: isRightTurn,
      isParking: isParking,
      voltage: _sanitize(voltage),
      soc: batteryPercent.clamp(0.0, 100.0),
      tempBalanceReg: _sanitize(tempBalanceReg),
      tempMotor: _sanitize(tempMotor),
      tempController: _sanitize(tempController),
      pcbState: pcbState,
      pcbError: pcbError,
      headlight: headlight,
      idleOff: idleOff,
      throttle: throttle,
      kmLeft: _sanitize(kmLeft),
    );
  }

  /// Loại bỏ giá trị NaN/Infinity từ float parse
  static double _sanitize(double value) {
    if (value.isNaN || value.isInfinite) return 0.0;
    return value;
  }
}
