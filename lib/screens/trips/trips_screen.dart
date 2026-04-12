import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/trip_entry.dart';
import '../../providers/database_provider.dart';
import '../../theme/app_colors.dart';

/// Provider lấy danh sách chuyến đi
final _allTripsProvider = FutureProvider<List<TripEntry>>((ref) async {
  return ref.watch(tripDaoProvider).getAll();
});

class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(_allTripsProvider);

    return tripsAsync.when(
      loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent)),
      error: (e, _) => Center(
          child: Text('Lỗi: $e',
              style: const TextStyle(color: AppColors.danger))),
      data: (trips) => trips.isEmpty
          ? _EmptyState()
          : _TripList(trips: trips, ref: ref),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.route, size: 64, color: AppColors.textDim),
          SizedBox(height: 16),
          Text('Chưa có chuyến đi nào',
              style: TextStyle(
                  color: AppColors.textSecondary, fontSize: 15)),
          SizedBox(height: 8),
          Text('App tự động ghi khi bạn chạy xe',
              style: TextStyle(
                  color: AppColors.textDim, fontSize: 12)),
        ],
      ),
    );
  }
}

class _TripList extends StatelessWidget {
  final List<TripEntry> trips;
  final WidgetRef ref;
  const _TripList({required this.trips, required this.ref});

  // Tổng stats
  double get _totalKm =>
      trips.fold(0.0, (s, t) => s + t.distanceKm);
  double get _totalWh =>
      trips.fold(0.0, (s, t) => s + t.energyWh);
  int get _totalSeconds =>
      trips.fold(0, (s, t) => s + t.durationSeconds);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Summary banner
        SliverToBoxAdapter(
          child: _SummaryBanner(
            totalKm: _totalKm,
            totalWh: _totalWh,
            totalSeconds: _totalSeconds,
            tripCount: trips.length,
          ),
        ),
        // Trip list
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          sliver: SliverList.builder(
            itemCount: trips.length,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _TripCard(
                trip: trips[i],
                onDelete: () async {
                  final id = trips[i].id;
                  if (id != null) {
                    await ref.read(tripDaoProvider).deleteById(id);
                    ref.invalidate(_allTripsProvider);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Summary Banner ────────────────────────────────────────────────────────────

class _SummaryBanner extends StatelessWidget {
  final double totalKm;
  final double totalWh;
  final int totalSeconds;
  final int tripCount;

  const _SummaryBanner({
    required this.totalKm,
    required this.totalWh,
    required this.totalSeconds,
    required this.tripCount,
  });

  String _formatDuration(int secs) {
    final h = secs ~/ 3600;
    final m = (secs % 3600) ~/ 60;
    return h > 0 ? '${h}g ${m}p' : '${m} phút';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF001830), Color(0xFF002040)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accent.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tổng cộng',
              style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  letterSpacing: 1)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SumStat('${totalKm.toStringAsFixed(1)} km', 'Quãng đường',
                  Icons.route),
              _SumStat('$tripCount', 'Chuyến đi', Icons.flag),
              _SumStat(_formatDuration(totalSeconds), 'Thời gian',
                  Icons.timer_outlined),
              _SumStat('${(totalWh / 1000).toStringAsFixed(2)} kWh',
                  'Năng lượng', Icons.bolt),
            ],
          ),
        ],
      ),
    );
  }
}

class _SumStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _SumStat(this.value, this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppColors.accent),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 9)),
      ],
    );
  }
}

// ── Trip Card ─────────────────────────────────────────────────────────────────

class _TripCard extends StatelessWidget {
  final TripEntry trip;
  final VoidCallback onDelete;
  const _TripCard({required this.trip, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('trip_${trip.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppColors.danger.withAlpha(40),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.danger),
      ),
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
            // Header: date + time
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withAlpha(20),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: AppColors.accent.withAlpha(60)),
                  ),
                  child: Text(
                    trip.dateLabel,
                    style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${trip.startTimeLabel} · ${trip.durationLabel}',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
                const Spacer(),
                // Efficiency badge
                if (trip.efficiency > 0)
                  Text(
                    '${trip.efficiency.toStringAsFixed(0)} Wh/km',
                    style: const TextStyle(
                        color: AppColors.textDim, fontSize: 10),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Stats row
            Row(
              children: [
                _TripStat(
                  Icons.route,
                  '${trip.distanceKm.toStringAsFixed(1)} km',
                  'Quãng đường',
                ),
                _TripStat(
                  Icons.speed,
                  '${trip.avgSpeedKmh.toStringAsFixed(0)} km/h',
                  'TB tốc độ',
                ),
                _TripStat(
                  Icons.fast_forward,
                  '${trip.maxSpeedKmh.toStringAsFixed(0)} km/h',
                  'Tốc độ max',
                ),
                _TripStat(
                  Icons.battery_charging_full,
                  '${trip.socUsed.toStringAsFixed(0)}%',
                  'Pin dùng',
                  color: trip.socUsed > 30
                      ? AppColors.warning
                      : AppColors.textSecondary,
                ),
              ],
            ),
            // Energy bar
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.bolt, size: 12, color: AppColors.orange),
                const SizedBox(width: 4),
                Text(
                  '${trip.energyWh.toStringAsFixed(0)} Wh  ·  🌡️ max ${trip.maxTempMotor.toStringAsFixed(0)}°C',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TripStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? color;
  const _TripStat(this.icon, this.value, this.label, {this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textSecondary;
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 14, color: c),
          const SizedBox(height: 3),
          Text(value,
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style:
                  const TextStyle(color: AppColors.textDim, fontSize: 9)),
        ],
      ),
    );
  }
}
