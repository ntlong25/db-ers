import 'package:flutter/material.dart';
import '../../../models/bike_data.dart';
import '../../../utils/bike_state_labels.dart';
import 'info_card.dart';

/// PcbTable — bảng thông tin PCB/Controller
class PcbTable extends StatelessWidget {
  final BikeData data;

  const PcbTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: 'PCB / Controller',
      child: Table(
        columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1.5)},
        children: [
          _row('Tên xe', data.name.isNotEmpty ? data.name : '--'),
          _row(
            'Firmware',
            data.fw.isNotEmpty ? '${data.fw} (${data.fwHash})' : '--',
          ),
          _row('VIN', data.vin.isNotEmpty ? data.vin : '--'),
          _row('ODO', '${data.odo.toStringAsFixed(1)} km'),
          _row('Trạng thái', BikeStateLabels.fromPcbState(data.pcbState)),
          _row(
            'Mã lỗi PCB',
            data.pcbError != 0
                ? '0x${data.pcbError.toRadixString(16).toUpperCase()}'
                : 'Không',
          ),
          _row('ADC Throttle', data.adc1.toStringAsFixed(3)),
          _row('ADC 2', data.adc2.toStringAsFixed(3)),
          _row('Idle-off', data.idleOff ? 'Bật' : 'Tắt'),
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
                fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis),
      ),
    ]);
  }
}
