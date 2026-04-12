import 'dart:convert';

/// Converters cho các kiểu dữ liệu cần serialize vào SQLite
/// Tương đương Converters.java (Room TypeConverter)
class BikeConverters {
  BikeConverters._();

  /// List<double> → JSON string để lưu vào TEXT column
  static String cellVoltagesToJson(List<double> cells) {
    if (cells.isEmpty) return '[]';
    return jsonEncode(cells);
  }

  /// JSON string → List<double> khi đọc từ DB
  static List<double> cellVoltagesFromJson(String json) {
    if (json.isEmpty || json == '[]') return [];
    try {
      final list = jsonDecode(json) as List;
      return list.map((e) => (e as num).toDouble()).toList();
    } catch (_) {
      return [];
    }
  }
}
