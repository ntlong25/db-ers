import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/history_provider.dart';
import '../../theme/app_colors.dart';
import '../trips/trips_screen.dart';
import 'widgets/charge_history_tab.dart';
import 'widgets/time_filter_bar.dart';
import 'widgets/temp_chart.dart';
import 'widgets/power_chart.dart';
import 'widgets/cell_chart.dart';

/// History Screen — lịch sử hành trình + biểu đồ
/// Tương đương HistoryActivity.java
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _endTime = TimeOfDay.now();

  // Visibility toggles cho từng series
  final Map<String, bool> _tempVisible = {
    'BalReg': true, 'FET': true, 'NTC1': true, 'NTC2': true,
    'NTC3': true, 'NTC4': true, 'Motor': true, 'ECU': true,
  };
  final Map<String, bool> _powerVisible = {
    'Volt': true, 'Current': true, 'Speed': true, 'SOC': true,
  };

  int get _startMs {
    final d = _selectedDate;
    return DateTime(d.year, d.month, d.day, _startTime.hour, _startTime.minute)
        .millisecondsSinceEpoch;
  }

  int get _endMs {
    final d = _selectedDate;
    return DateTime(d.year, d.month, d.day, _endTime.hour, _endTime.minute, 59)
        .millisecondsSinceEpoch;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: AppColors.accent),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime({required bool isStart}) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: AppColors.accent),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;

    // Validation: không cho chọn tương lai
    final today = DateTime.now();
    final isToday = _selectedDate.year == today.year &&
        _selectedDate.month == today.month &&
        _selectedDate.day == today.day;
    if (isToday &&
        (picked.hour > now.hour ||
            (picked.hour == now.hour && picked.minute > now.minute))) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Không thể chọn thời gian trong tương lai')),
        );
      }
      return;
    }

    setState(() {
      if (isStart) { _startTime = picked; }
      else { _endTime = picked; }
    });
  }

  @override
  Widget build(BuildContext context) {
    final range = (startMs: _startMs, endMs: _endMs);
    final logsAsync = ref.watch(historyLogsProvider(range));
    final countAsync = ref.watch(historyCountProvider(range));

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: Row(
          children: [
            const Text('Lịch sử'),
            const SizedBox(width: 8),
            countAsync.when(
              data: (c) => Text('($c bản ghi)',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              loading: () => const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 1.5)),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accent,
          labelColor: AppColors.accent,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Biểu đồ'),
            Tab(text: 'Chuyến đi'),
            Tab(text: 'Lần sạc'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 0: Charts
          Column(
            children: [
              TimeFilterBar(
                date: _selectedDate,
                startTime: _startTime,
                endTime: _endTime,
                onDateTap: _pickDate,
                onStartTap: () => _pickTime(isStart: true),
                onEndTap: () => _pickTime(isStart: false),
              ),
              Expanded(
                child: logsAsync.when(
                  loading: () => const Center(
                      child: CircularProgressIndicator(color: AppColors.accent)),
                  error: (e, _) => Center(
                      child: Text('Lỗi: $e',
                          style: const TextStyle(color: Colors.red))),
                  data: (logs) => logs.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.history_toggle_off,
                                  size: 48, color: AppColors.textDim),
                              SizedBox(height: 12),
                              Text(
                                'Không có dữ liệu trong khoảng thời gian này',
                                style: TextStyle(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(12),
                          children: [
                            TempChart(
                              logs: logs,
                              visible: _tempVisible,
                              onToggle: (k) =>
                                  setState(() => _tempVisible[k] = !_tempVisible[k]!),
                            ),
                            const SizedBox(height: 12),
                            PowerChart(
                              logs: logs,
                              visible: _powerVisible,
                              onToggle: (k) =>
                                  setState(() => _powerVisible[k] = !_powerVisible[k]!),
                            ),
                            const SizedBox(height: 12),
                            CellChart(logs: logs),
                          ],
                        ),
                ),
              ),
            ],
          ),

          // Tab 1: Trips
          const TripsScreen(),

          // Tab 2: Charge history
          const ChargeHistoryTab(),
        ],
      ),
    );
  }
}
