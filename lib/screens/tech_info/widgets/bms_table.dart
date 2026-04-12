import 'package:flutter/material.dart';
import '../../../models/bike_data.dart';
import 'info_card.dart';

/// BmsTable — bảng thông số BMS (9 dòng)
/// Tương đương phần BMS trong TechInfoActivity.java
class BmsTable extends StatelessWidget {
  final BikeData data;

  const BmsTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: 'BMS',
      child: Table(
        columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1)},
        children: [
          _row('Điện áp', '${data.voltage.toStringAsFixed(3)} V'),
          _row('Dòng điện', '${data.current.toStringAsFixed(2)} A'),
          _row('SOC', '${data.soc.toStringAsFixed(1)} %'),
          _row('Công suất', '${(data.voltage * data.current).toStringAsFixed(1)} W'),
          _row('Dung lượng', '${data.currentAh.toStringAsFixed(2)} Ah'),
          _row('Tổng Ah', '${data.absAh.toStringAsFixed(1)} Ah'),
          _row('Chu kỳ sạc', '${data.cycles} lần'),
          _row('Trạng thái', data.isCharging ? '🔌 Đang sạc' : '⚡ Đang xả'),
          _row(
            'Lỗi BMS',
            data.bmsError != 0
                ? '0x${data.bmsError.toRadixString(16).toUpperCase()}'
                : 'Không',
          ),
        ],
      ),
    );
  }

  static TableRow _row(String label, String value) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(label,
            style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 12)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(value,
            style: const TextStyle(
                color: Color(0xFFEBEBF5),
                fontSize: 12,
                fontWeight: FontWeight.bold)),
      ),
    ]);
  }
}
