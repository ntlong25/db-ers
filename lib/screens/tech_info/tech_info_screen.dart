import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/bike_data.dart';
import '../../providers/bike_data_provider.dart';
import '../../providers/database_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_strings.dart';
import '../../utils/debug_log_exporter.dart';
import '../health/health_screen.dart';
import 'widgets/bms_table.dart';
import 'widgets/temp_table.dart';
import 'widgets/cell_grid.dart';
import 'widgets/pcb_table.dart';

/// TechInfo Screen — thông tin kỹ thuật chi tiết
/// Tương đương TechInfoActivity.java
class TechInfoScreen extends ConsumerStatefulWidget {
  const TechInfoScreen({super.key});

  @override
  ConsumerState<TechInfoScreen> createState() => _TechInfoScreenState();
}

class _TechInfoScreenState extends ConsumerState<TechInfoScreen> {
  Timer? _refreshTimer;
  int _titleTapCount = 0;
  Timer? _tapResetTimer;

  @override
  void initState() {
    super.initState();
    // Auto-refresh mỗi 1 giây
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _tapResetTimer?.cancel();
    super.dispose();
  }

  /// Triple-tap trên title → xuất debug log
  void _onTitleTap() {
    _tapResetTimer?.cancel();
    _titleTapCount++;

    if (_titleTapCount >= 3) {
      _titleTapCount = 0;
      _exportDebugLog();
    } else {
      // Reset nếu không tap đủ 3 lần trong 1 giây
      _tapResetTimer = Timer(const Duration(seconds: 1), () {
        _titleTapCount = 0;
      });
    }
  }

  Future<void> _exportDebugLog() async {
    final dao = ref.read(bikeLogDaoProvider);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.history.exportingLog),
        duration: const Duration(seconds: 1),
      ),
    );

    try {
      await DebugLogExporter.export(dao);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${S.history.exportError}$e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(bikeDataProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: GestureDetector(
          onTap: _onTitleTap,
          child: Text(S.screen.techInfo),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.accent),
            tooltip: S.screen.battHealth,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HealthScreen()),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          BmsTable(data: data),
          const SizedBox(height: 12),
          TempTable(data: data),
          const SizedBox(height: 12),
          CellGrid(data: data),
          const SizedBox(height: 12),
          PcbTable(data: data),
          const SizedBox(height: 12),
          if (_hasWarning(data)) _WarningBanner(data: data),
        ],
      ),
    );
  }

  bool _hasWarning(BikeData data) =>
      data.isCellDiffWarning || (data.adc1 - data.adc2).abs() > 0.05;
}

// ═══════════════════════════════════════════════════════════
// WARNING BANNER
// ═══════════════════════════════════════════════════════════

class _WarningBanner extends StatelessWidget {
  final BikeData data;
  const _WarningBanner({required this.data});

  @override
  Widget build(BuildContext context) {
    final warnings = <String>[];
    if (data.isCellDiffDanger) {
      warnings.add(
          '⚠️ Cell lệch nguy hiểm: ${(data.cellDiff * 1000).toStringAsFixed(0)} mV (>100mV)');
    } else if (data.isCellDiffWarning) {
      warnings.add(
          '⚡ Cell lệch nhẹ: ${(data.cellDiff * 1000).toStringAsFixed(0)} mV (>40mV)');
    }
    if ((data.adc1 - data.adc2).abs() > 0.05) {
      warnings.add(
          '⚠️ Throttle ADC noise: ${(data.adc1 - data.adc2).abs().toStringAsFixed(3)}');
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: data.isCellDiffDanger
            ? const Color(0x44FF5252)
            : const Color(0x22FFB74D),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: data.isCellDiffDanger ? Colors.red : Colors.orange,
            width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: warnings
            .map((w) => Text(w,
                style: TextStyle(
                    color: data.isCellDiffDanger ? Colors.red : Colors.orange,
                    fontSize: 12)))
            .toList(),
      ),
    );
  }
}
