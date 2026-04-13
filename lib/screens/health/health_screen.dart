import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/bike_data_provider.dart';
import '../../providers/database_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/battery_health_analyzer.dart';

/// Provider lấy logs 30 ngày + chạy phân tích
final _healthReportProvider = FutureProvider<BatteryHealthReport>((ref) async {
  final dao  = ref.watch(bikeLogDaoProvider);
  final data = ref.read(bikeDataProvider);  // read, không watch — tránh re-trigger liên tục

  final end   = DateTime.now();
  final start = end.subtract(const Duration(days: 30));
  final logs  = await dao.getLogsByTimeRange(
    start.millisecondsSinceEpoch,
    end.millisecondsSinceEpoch,
  );

  return BatteryHealthAnalyzer.analyze(
    recentLogs: logs,
    current: data,
  );
});

class HealthScreen extends ConsumerWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(_healthReportProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: const Text('Sức khỏe Pin'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
      ),
      body: reportAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (e, _) => Center(
          child: Text('Lỗi: $e',
              style: const TextStyle(color: AppColors.danger)),
        ),
        data: (report) => _HealthBody(report: report),
      ),
    );
  }
}

// ── Body ─────────────────────────────────────────────────────────────────────

class _HealthBody extends StatelessWidget {
  final BatteryHealthReport report;
  const _HealthBody({required this.report});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Overall score ring
        _ScoreRing(score: report.overallScore, report: report),
        const SizedBox(height: 20),

        // Metric bars
        _MetricCard(
          icon: Icons.balance,
          label: 'Cân bằng Cell',
          score: report.cellBalanceScore,
          subtitle:
              'Chênh lệch TB: ${report.avgCellDiffMv.toStringAsFixed(1)} mV',
          color: _scoreColor(report.cellBalanceScore),
        ),
        const SizedBox(height: 10),
        _MetricCard(
          icon: Icons.battery_full,
          label: 'Dung lượng',
          score: report.capacityScore,
          subtitle: report.currentAh > 0
              ? '${report.currentAh.toStringAsFixed(1)} / 48.5 Ah'
              : 'Ước tính từ chu kỳ',
          color: _scoreColor(report.capacityScore),
        ),
        const SizedBox(height: 10),
        _MetricCard(
          icon: Icons.thermostat,
          label: 'Nhiệt độ vận hành',
          score: report.thermalScore,
          subtitle: report.logCount > 0
              ? 'Phân tích ${report.logCount} mẫu (30 ngày)'
              : 'Chưa đủ dữ liệu',
          color: _scoreColor(report.thermalScore),
        ),
        const SizedBox(height: 10),
        _MetricCard(
          icon: Icons.loop,
          label: 'Vòng đời còn lại',
          score: report.cycleLifeScore,
          subtitle: '${report.cycles} / 500 chu kỳ',
          color: _scoreColor(report.cycleLifeScore),
        ),

        const SizedBox(height: 20),

        // Cycle progress bar
        _CycleBar(cycles: report.cycles),

        const SizedBox(height: 20),

        // Weak cells (if any)
        if (report.weakCellIndices.isNotEmpty) ...[
          _WeakCellsCard(indices: report.weakCellIndices),
          const SizedBox(height: 20),
        ],

        // Recommendations
        _RecommendationsCard(recs: report.recommendations),
        const SizedBox(height: 8),
      ],
    );
  }

  static Color _scoreColor(int score) {
    if (score >= 85) return AppColors.success;
    if (score >= 70) return AppColors.accent;
    if (score >= 50) return AppColors.warning;
    return AppColors.danger;
  }
}

// ── Score Ring ────────────────────────────────────────────────────────────────

class _ScoreRing extends StatelessWidget {
  final int score;
  final BatteryHealthReport report;
  const _ScoreRing({required this.score, required this.report});

  @override
  Widget build(BuildContext context) {
    final color = Color(report.statusColorValue);

    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: CustomPaint(
              painter: _RingPainter(score: score, color: color),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$score',
                      style: TextStyle(
                        color: color,
                        fontSize: 52,
                        fontWeight: FontWeight.w800,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      '/ 100',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withAlpha(80)),
            ),
            child: Text(
              report.statusLabel,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final int score;
  final Color color;
  _RingPainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 12;
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * score / 100;

    // Track
    canvas.drawCircle(center, radius,
        Paint()
          ..color = AppColors.divider
          ..style = PaintingStyle.stroke
          ..strokeWidth = 14);

    // Glow
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle, sweepAngle, false,
      Paint()
        ..color = color.withAlpha(60)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 22
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Value arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle, sweepAngle, false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.score != score;
}

// ── Metric Card ───────────────────────────────────────────────────────────────

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int score;
  final String subtitle;
  final Color color;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.score,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  )),
              const Spacer(),
              Text(
                '$score%',
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(children: [
              Container(height: 8, color: AppColors.divider),
              FractionallySizedBox(
                widthFactor: score / 100.0,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withAlpha(180), color],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 6),
          Text(subtitle,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              )),
        ],
      ),
    );
  }
}

// ── Cycle Bar ─────────────────────────────────────────────────────────────────

class _CycleBar extends StatelessWidget {
  final int cycles;
  const _CycleBar({required this.cycles});

  @override
  Widget build(BuildContext context) {
    final ratio = (cycles / 500).clamp(0.0, 1.0);
    final color = ratio > 0.8
        ? AppColors.danger
        : ratio > 0.6
            ? AppColors.warning
            : AppColors.success;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.loop, size: 16, color: AppColors.accent),
              const SizedBox(width: 8),
              const Text('Chu kỳ sạc',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
              const Spacer(),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: '$cycles',
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: ' / 500',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ]),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(children: [
              Container(height: 8, color: AppColors.divider),
              FractionallySizedBox(
                widthFactor: ratio,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [AppColors.success, color]),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 6),
          Text(
            'Còn lại ~${((1 - ratio) * 500).toInt()} chu kỳ',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Weak Cells Card ───────────────────────────────────────────────────────────

class _WeakCellsCard extends StatelessWidget {
  final List<int> indices;
  const _WeakCellsCard({required this.indices});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.warning.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withAlpha(80)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppColors.warning, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Cell yếu phát hiện',
                    style: TextStyle(
                        color: AppColors.warning,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  'Cell ${indices.map((i) => i + 1).join(', ')} thấp hơn trung bình đáng kể',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Recommendations ───────────────────────────────────────────────────────────

class _RecommendationsCard extends StatelessWidget {
  final List<String> recs;
  const _RecommendationsCard({required this.recs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.lightbulb_outline, size: 16, color: AppColors.accent),
            SizedBox(width: 8),
            Text('Khuyến nghị',
                style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ]),
          const SizedBox(height: 12),
          ...recs.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(r,
                    style: const TextStyle(
                        color: AppColors.textPrimary, fontSize: 13, height: 1.4)),
              )),
        ],
      ),
    );
  }
}
