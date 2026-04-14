import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/charge_cycle_entry.dart';
import '../../../providers/database_provider.dart';
import '../../../providers/smart_range_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_strings.dart';

/// Provider lấy toàn bộ lịch sử phiên xả pin
final _allCyclesProvider = FutureProvider.autoDispose<List<ChargeCycleEntry>>((ref) {
  return ref.read(chargeCycleDaoProvider).getAll();
});

class ChargeHistoryTab extends ConsumerWidget {
  const ChargeHistoryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cyclesAsync    = ref.watch(_allCyclesProvider);
    final smartRangeAsync = ref.watch(smartRangeProvider);

    return cyclesAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: AppColors.accent)),
      error: (e, _) =>
          Center(child: Text('Lỗi: $e', style: const TextStyle(color: AppColors.danger))),
      data: (cycles) => CustomScrollView(
        slivers: [
          // ── Summary banner ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: _SummaryBanner(cycles: cycles, smartAsync: smartRangeAsync),
          ),

          if (cycles.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.battery_charging_full,
                        size: 48, color: AppColors.textDim),
                    const SizedBox(height: 12),
                    Text(
                      S.charge.noData,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      S.charge.autoRecord,
                      style: const TextStyle(color: AppColors.textDim, fontSize: 11),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
              sliver: SliverList.builder(
                itemCount: cycles.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _CycleCard(
                    entry: cycles[i],
                    onDelete: () async {
                      await ref
                          .read(chargeCycleDaoProvider)
                          .deleteById(cycles[i].id);
                      ref.invalidate(_allCyclesProvider);
                      ref.invalidate(smartRangeProvider);
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Summary Banner ────────────────────────────────────────────────────────────

class _SummaryBanner extends StatelessWidget {
  final List<ChargeCycleEntry> cycles;
  final AsyncValue<SmartRangeResult> smartAsync;

  const _SummaryBanner({required this.cycles, required this.smartAsync});

  @override
  Widget build(BuildContext context) {
    double avgKm      = 0;
    double avgSocUsed = 0;
    double avgRange   = 0;

    if (cycles.isNotEmpty) {
      avgKm      = cycles.map((e) => e.distanceKm).reduce((a, b) => a + b) / cycles.length;
      avgSocUsed = cycles.map((e) => e.socUsed).reduce((a, b) => a + b) / cycles.length;
      avgRange   = cycles.map((e) => e.projectedFullRange).reduce((a, b) => a + b) / cycles.length;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D2137), Color(0xFF0D1C2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accent.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.bolt, size: 16, color: AppColors.accent),
              const SizedBox(width: 6),
              Text(S.charge.statsTitle,
                  style: const TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
              const Spacer(),
              Text('${cycles.length} ${S.charge.sessions}',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 14),

          // Avg stats row
          Row(
            children: [
              _StatCell(
                  label: S.charge.avgKmPerCharge,
                  value: '${avgKm.toStringAsFixed(1)} km',
                  color: AppColors.accent),
              _vDivider(),
              _StatCell(
                  label: S.charge.avgSocUsed,
                  value: '${avgSocUsed.toStringAsFixed(1)}%',
                  color: AppColors.orange),
              _vDivider(),
              _StatCell(
                  label: S.charge.avgFullRange,
                  value: '${avgRange.toStringAsFixed(0)} km',
                  color: AppColors.success),
            ],
          ),

          // Smart range prediction (nếu có dữ liệu)
          smartAsync.when(
            data: (smart) => smart.hasData
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.success.withAlpha(18),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppColors.success.withAlpha(60)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.navigation,
                                size: 18, color: AppColors.success),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(S.charge.smartRangeTitle,
                                      style: const TextStyle(
                                          color: AppColors.success,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Với pin hiện tại còn lại ~${smart.predictedKm.toStringAsFixed(0)} km '
                                    '(${smart.avgKmPerPercent.toStringAsFixed(2)} km/%, '
                                    'dựa trên ${smart.sessionCount} phiên gần nhất)',
                                    style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 11,
                                        height: 1.4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _vDivider() => Container(
      width: 1, height: 36, color: AppColors.divider,
      margin: const EdgeInsets.symmetric(horizontal: 12));
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final Color  color;
  const _StatCell({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: AppColors.textDim, fontSize: 10)),
        ],
      ),
    );
  }
}

// ── Cycle Card ────────────────────────────────────────────────────────────────

class _CycleCard extends StatelessWidget {
  final ChargeCycleEntry entry;
  final VoidCallback onDelete;
  const _CycleCard({required this.entry, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.danger.withAlpha(30),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline,
            color: AppColors.danger, size: 22),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.card,
            title: Text(S.charge.deleteSession,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 15)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text(S.cancel,
                      style: TextStyle(color: AppColors.textSecondary))),
              TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text(S.delete,
                      style: TextStyle(color: AppColors.danger))),
            ],
          ),
        ) ?? false;
      },
      onDismissed: (_) => onDelete(),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: ngày + giờ
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 12, color: AppColors.textDim),
                const SizedBox(width: 4),
                Text(entry.dateLabel,
                    style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
                const SizedBox(width: 8),
                Text('${entry.startTimeLabel} – ${entry.endTimeLabel}',
                    style: const TextStyle(
                        color: AppColors.textDim, fontSize: 11)),
                const Spacer(),
                // Efficiency badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.accent.withAlpha(60)),
                  ),
                  child: Text(
                    '${entry.kmPerPercent.toStringAsFixed(2)} km/%',
                    style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Stats grid: 2×2
            Row(
              children: [
                _GridCell(
                    icon: Icons.route,
                    label: S.charge.distance,
                    value: '${entry.distanceKm.toStringAsFixed(1)} km',
                    color: AppColors.accent),
                _GridCell(
                    icon: Icons.battery_4_bar,
                    label: S.charge.battConsumed,
                    value:
                        '${entry.startSoc.toStringAsFixed(0)}% → ${entry.endSoc.toStringAsFixed(0)}%',
                    color: AppColors.orange),
                _GridCell(
                    icon: Icons.bolt,
                    label: S.charge.socUsed,
                    value: '${entry.socUsed.toStringAsFixed(1)}%',
                    color: AppColors.warning),
                _GridCell(
                    icon: Icons.flag,
                    label: S.charge.fullRange,
                    value:
                        '${entry.projectedFullRange.toStringAsFixed(0)} km',
                    color: AppColors.success),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GridCell extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   value;
  final Color    color;
  const _GridCell(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(height: 3),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textDim, fontSize: 10)),
        ],
      ),
    );
  }
}
