import 'package:flutter/material.dart';
import '../../../models/bike_data.dart';
import '../../../utils/temp_formatter.dart';
import 'info_card.dart';

/// TempTable — lưới 4 cột hiển thị 8 cảm biến nhiệt độ với màu cảnh báo
class TempTable extends StatelessWidget {
  final BikeData data;

  const TempTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final temps = [
      ('Motor', data.tempMotor),
      ('ECU/Controller', data.tempController),
      ('FET', data.tempFet),
      ('BMS avg', data.tempBms),
      ('NTC-1', data.tempPin1),
      ('NTC-2', data.tempPin2),
      ('NTC-3', data.tempPin3),
      ('NTC-4', data.tempPin4),
    ];

    return InfoCard(
      title: 'Nhiệt độ',
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.3,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        children: temps
            .map((e) => TempCell(label: e.$1, temp: e.$2))
            .toList(),
      ),
    );
  }
}

/// TempCell — ô nhiệt độ đơn lẻ với background màu theo ngưỡng
class TempCell extends StatelessWidget {
  final String label;
  final double temp;

  const TempCell({super.key, required this.label, required this.temp});

  @override
  Widget build(BuildContext context) {
    final color = TempFormatter.colorFor(temp);
    final bg = TempFormatter.bgColorFor(temp) ?? const Color(0xFF1E2233);
    return Container(
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            TempFormatter.format(temp),
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 9),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
