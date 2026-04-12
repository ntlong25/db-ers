import 'package:flutter/material.dart';
import '../../../models/bike_data.dart';
import 'info_card.dart';

/// CellGrid — lưới 23 cell với màu sắc: min=vàng, max=xanh, danger=đỏ
/// Tương đương cell voltage display trong TechInfoActivity.java
class CellGrid extends StatelessWidget {
  final BikeData data;

  const CellGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final cells = data.cellVoltages;

    if (cells.isEmpty) {
      return const InfoCard(
        title: 'Cell Voltages (0 cells)',
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Chưa có dữ liệu cell',
              style: TextStyle(color: Color(0xFFAAAAAA)),
            ),
          ),
        ),
      );
    }

    final isDanger = data.isCellDiffDanger;

    return InfoCard(
      title:
          'Cell Voltages (${cells.length} cells) — diff: ${(data.cellDiff * 1000).toStringAsFixed(0)} mV',
      titleColor: isDanger ? Colors.red : null,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          childAspectRatio: 1.1,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: cells.length,
        itemBuilder: (_, i) => CellCard(
          index: i + 1,
          voltage: cells[i],
          isMin: cells[i] == data.vMin,
          isMax: cells[i] == data.vMax,
          isDanger: isDanger,
        ),
      ),
    );
  }
}

/// CellCard — ô đơn lẻ cho một cell, color-coded
class CellCard extends StatelessWidget {
  final int index;
  final double voltage;
  final bool isMin;
  final bool isMax;
  final bool isDanger;

  const CellCard({
    super.key,
    required this.index,
    required this.voltage,
    required this.isMin,
    required this.isMax,
    required this.isDanger,
  });

  @override
  Widget build(BuildContext context) {
    Color bg = const Color(0xFF1E2233);
    Color textColor = const Color(0xFFEBEBF5);

    if (isDanger) {
      bg = const Color(0x44FF5252);
      textColor = Colors.red;
    } else if (isMin) {
      bg = const Color(0x44FFD600);
      textColor = Colors.yellow;
    } else if (isMax) {
      bg = const Color(0x444FC3F7);
      textColor = const Color(0xFF4FC3F7);
    }

    return Container(
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            voltage.toStringAsFixed(3),
            style: TextStyle(
                color: textColor, fontSize: 9, fontWeight: FontWeight.bold),
          ),
          Text(
            '#$index',
            style: const TextStyle(color: Color(0xFF666666), fontSize: 8),
          ),
        ],
      ),
    );
  }
}
