import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ble/ble_state.dart';
import '../../models/bike_data.dart';
import '../../providers/ble_connection_provider.dart';
import '../../providers/bike_data_provider.dart';
import '../../providers/saved_mac_provider.dart';
import '../../providers/logger_notifier.dart';
import '../../providers/speed_alert_provider.dart';
import '../../services/alarm_service.dart';
import '../../services/foreground_service_handler.dart';
import '../../services/notification_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/permission_helper.dart';
import '../../utils/bike_state_labels.dart';
import 'scan_dialog.dart';
import 'widgets/speed_gauge.dart';
import 'widgets/battery_indicator.dart';
import 'widgets/signal_indicator.dart';
import 'widgets/turn_indicators.dart';
import 'widgets/temp_summary_row.dart';
import 'widgets/function_button.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with WidgetsBindingObserver {
  Timer? _blinkTimer;
  bool _blinkOn = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startBlink();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _blinkTimer?.cancel();
    super.dispose();
  }

  void _startBlink() {
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) setState(() => _blinkOn = !_blinkOn);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final notifier = ref.read(bleConnectionProvider.notifier);
    if (state == AppLifecycleState.resumed) {
      notifier.onAppForeground();
    } else if (state == AppLifecycleState.paused) {
      notifier.onAppBackground();
      ref.read(loggerProvider).forceLog();
    }
  }

  Future<void> _initialize() async {
    ref.read(loggerProvider);
    ref.read(alarmServiceProvider);

    final ok = await PermissionHelper.requestAll();
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cần cấp quyền Bluetooth để kết nối xe'),
          action: SnackBarAction(label: 'Cài đặt', onPressed: PermissionHelper.openSettings),
        ),
      );
    }

    ref.listen(bleConnectionProvider, (prev, next) async {
      final data = ref.read(bikeDataProvider);
      if (next.isConnected && !(prev?.isConnected ?? false)) {
        startForegroundService();
      } else if (!next.isConnected && (prev?.isConnected ?? false)) {
        stopForegroundService();
      }
      if (next.isConnected) {
        await NotificationService.updateConnected(
          speed: data.speed,
          soc: data.soc,
          bikeName: data.name,
          alarmSounding: data.isAlarmSounding,
        );
      }
    });

    if (mounted) await ref.read(bleConnectionProvider.notifier).initialize();
  }

  Future<void> _onScanPressed() async {
    final ok = await PermissionHelper.checkAll();
    if (!ok) { await PermissionHelper.requestAll(); return; }
    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const ScanDialog(),
    );
  }

  Future<void> _showSettingsSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _SettingsSheet(
        onScanTap: () {
          Navigator.pop(ctx);
          _onScanPressed();
        },
        onForgetTap: ref.read(savedMacProvider) != null
            ? () {
                Navigator.pop(ctx);
                _showForgetDialog();
              }
            : null,
      ),
    );
  }

  void _showForgetDialog() {
    final mac = ref.read(savedMacProvider);
    if (mac == null) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Quên xe?', style: TextStyle(color: AppColors.textPrimary)),
        content: Text('Xóa xe đã lưu ($mac)?',
            style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(bleConnectionProvider.notifier).forgetDevice();
            },
            child: const Text('Xóa', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bleState = ref.watch(bleConnectionProvider);
    final data     = ref.watch(bikeDataProvider);
    final savedMac = ref.watch(savedMacProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              bleState: bleState,
              data: data,
              savedMac: savedMac,
              blinkOn: _blinkOn,
              onMenuTap: _showSettingsSheet,
              onMenuLongPress: _showForgetDialog,
            ),
            if (bleState.isConnected) _StatusStrip(data: data),
            Expanded(
              child: bleState.isConnected
                  ? _ConnectedBody(data: data, blinkOn: _blinkOn)
                  : _DisconnectedBody(bleState: bleState, onScanTap: _onScanPressed),
            ),
            if (bleState.isConnected)
              DashboardBottomBar(data: data, bleState: bleState),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TOP BAR
// ═══════════════════════════════════════════════════════════════════════════════

class _TopBar extends StatelessWidget {
  final BleState bleState;
  final BikeData data;
  final String? savedMac;
  final bool blinkOn;
  final VoidCallback onMenuTap;
  final VoidCallback onMenuLongPress;

  const _TopBar({
    required this.bleState,
    required this.data,
    required this.savedMac,
    required this.blinkOn,
    required this.onMenuTap,
    required this.onMenuLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final bikeName = data.name.isNotEmpty ? data.name : (savedMac ?? 'DTC Bike');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          // Menu
          GestureDetector(
            onTap: onMenuTap,
            onLongPress: onMenuLongPress,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.divider),
              ),
              child: const Icon(Icons.menu, color: AppColors.textSecondary, size: 18),
            ),
          ),
          const SizedBox(width: 12),

          // Bike name + status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bikeName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  bleState.statusLabel,
                  style: TextStyle(
                    color: bleState.isConnected
                        ? AppColors.success
                        : AppColors.textSecondary,
                    fontSize: 10,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),

          // Loading spinner
          if (bleState.isConnecting || bleState.isScanning) ...[
            const SizedBox(
              width: 14, height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Signal bars
          SignalDots(rssi: data.rssi, connected: bleState.isConnected),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STATUS STRIP — đèn, khóa, sạc, còi, bảo vệ
// ═══════════════════════════════════════════════════════════════════════════════

class _StatusStrip extends StatelessWidget {
  final BikeData data;
  const _StatusStrip({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      color: AppColors.bg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StatusPill(Icons.highlight,    'Đèn',    data.headlight,       Colors.yellow.shade600),
          _StatusPill(Icons.lock,         data.isLocked ? 'Khóa' : 'Mở', data.isLocked, AppColors.orange),
          _StatusPill(Icons.bolt,         data.isCharging ? 'Sạc' : 'Xả', data.isCharging, AppColors.success),
          _StatusPill(Icons.campaign,     'Còi',    data.isAlarmSounding, AppColors.danger),
          _StatusPill(Icons.shield,       'BV',     data.isArmed,         AppColors.accent),
          _StatusPill(Icons.snooze,       'Idle',   data.idleOff,         Colors.purple.shade300),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final Color color;

  const _StatusPill(this.icon, this.label, this.active, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: active ? color.withAlpha(30) : AppColors.divider.withAlpha(80),
        borderRadius: BorderRadius.circular(20),
        border: active
            ? Border.all(color: color.withAlpha(100))
            : Border.all(color: Colors.transparent),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: active ? color : AppColors.textDim),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              color: active ? color : AppColors.textDim,
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// CONNECTED BODY
// ═══════════════════════════════════════════════════════════════════════════════

class _ConnectedBody extends StatelessWidget {
  final BikeData data;
  final bool blinkOn;

  const _ConnectedBody({required this.data, required this.blinkOn});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Xi nhan + đồng hồ ──────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BigTurnArrow(
                isLeft: true,
                active: data.turnLeft && blinkOn,
              ),
              Expanded(
                child: SpeedGauge(
                  speed: data.speed,
                  pcbState: data.pcbState,
                ),
              ),
              BigTurnArrow(
                isLeft: false,
                active: data.turnRight && blinkOn,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ── Pin ────────────────────────────────────────────
          BatteryIndicator(data: data),

          const SizedBox(height: 12),

          // ── Quick stats 2×3 ────────────────────────────────
          _QuickStatsGrid(data: data),

          const SizedBox(height: 12),

          // ── Nhiệt độ ──────────────────────────────────────
          TempSummaryRow(data: data),

          const SizedBox(height: 8),

          // ── Cell diff banner (nếu có cảnh báo) ────────────
          if (data.cellVoltages.isNotEmpty && data.isCellDiffWarning)
            _CellDiffBanner(data: data),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// ── Quick Stats 2×3 grid ──────────────────────────────────────────────────────

class _QuickStatsGrid extends StatelessWidget {
  final BikeData data;
  const _QuickStatsGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatItem(Icons.route,           '${data.odo.toStringAsFixed(1)} km',   'ODO'),
      _StatItem(Icons.electric_bolt,   '${data.current.toStringAsFixed(1)} A','Dòng điện'),
      _StatItem(Icons.thermostat,      '${data.tempMotor.toStringAsFixed(0)}°', 'Nhiệt độ'),
      _StatItem(Icons.battery_charging_full, '${data.voltage.toStringAsFixed(1)} V', 'Điện áp'),
      _StatItem(Icons.loop,            '${data.cycles}',                      'Chu kỳ'),
      _StatItem(Icons.info_outline,    BikeStateLabels.fromPcbState(data.pcbState), 'Trạng thái'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.8,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => items[i],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatItem(this.icon, this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: AppColors.accent),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 9,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── Cell Diff Banner ──────────────────────────────────────────────────────────

class _CellDiffBanner extends StatelessWidget {
  final BikeData data;
  const _CellDiffBanner({required this.data});

  @override
  Widget build(BuildContext context) {
    final isDanger = data.isCellDiffDanger;
    final color    = isDanger ? AppColors.danger : AppColors.warning;

    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Cell lệch ${(data.cellDiff * 1000).toStringAsFixed(0)} mV  '
              '(min ${data.vMin.toStringAsFixed(3)}V / max ${data.vMax.toStringAsFixed(3)}V)',
              style: TextStyle(color: color, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DISCONNECTED BODY
// ═══════════════════════════════════════════════════════════════════════════════

class _DisconnectedBody extends StatelessWidget {
  final BleState bleState;
  final VoidCallback onScanTap;
  const _DisconnectedBody({required this.bleState, required this.onScanTap});

  @override
  Widget build(BuildContext context) {
    final isLoading =
        bleState.isScanning || bleState.isConnecting || bleState.isReconnecting;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bike icon với glow
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.electric_moped,
                  size: 100,
                  color: isLoading
                      ? AppColors.accent.withAlpha(30)
                      : AppColors.divider,
                ),
                Icon(
                  Icons.electric_moped,
                  size: 80,
                  color: isLoading ? AppColors.accent : AppColors.textDim,
                ),
              ],
            ),

            const SizedBox(height: 24),

            if (isLoading) ...[
              const SizedBox(
                width: 32, height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 16),
            ],

            Text(
              bleState.statusLabel,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),

            if (bleState is BleError) ...[
              const SizedBox(height: 8),
              Text(
                (bleState as BleError).message,
                style: const TextStyle(color: AppColors.danger, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],

            if (!isLoading) ...[
              const SizedBox(height: 32),
              // Gradient scan button
              GestureDetector(
                onTap: onScanTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.accent, Color(0xFF0088CC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withAlpha(80),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bluetooth_searching, color: Colors.black, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Tìm xe Datbike',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SETTINGS SHEET — scan + speed alert + forget
// ═══════════════════════════════════════════════════════════════════════════════

class _SettingsSheet extends ConsumerStatefulWidget {
  final VoidCallback onScanTap;
  final VoidCallback? onForgetTap;

  const _SettingsSheet({required this.onScanTap, this.onForgetTap});

  @override
  ConsumerState<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends ConsumerState<_SettingsSheet> {
  late double _sliderVal;

  @override
  void initState() {
    super.initState();
    _sliderVal = ref.read(speedAlertThresholdProvider);
    if (_sliderVal == 0) _sliderVal = 80;
  }

  @override
  Widget build(BuildContext context) {
    final threshold = ref.watch(speedAlertThresholdProvider);
    final notifier = ref.read(speedAlertThresholdProvider.notifier);
    final enabled = notifier.isEnabled;

    return Padding(
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Scan button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.bg,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.bluetooth_searching),
              label: const Text('Quét & kết nối xe',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: widget.onScanTap,
            ),
          ),
          const SizedBox(height: 20),

          // Speed alert section
          Row(
            children: [
              const Icon(Icons.speed, size: 16, color: AppColors.orange),
              const SizedBox(width: 8),
              const Text('Cảnh báo tốc độ',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
              const Spacer(),
              Switch(
                value: enabled,
                activeColor: AppColors.accent,
                onChanged: (v) {
                  if (v) {
                    notifier.setThreshold(_sliderVal);
                  } else {
                    notifier.disable();
                  }
                },
              ),
            ],
          ),
          if (enabled) ...[
            Row(
              children: [
                const Icon(Icons.arrow_forward, size: 12,
                    color: AppColors.textDim),
                const SizedBox(width: 4),
                Text(
                  'Ngưỡng: ${threshold.toStringAsFixed(0)} km/h',
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
            Slider(
              value: _sliderVal,
              min: 30,
              max: 120,
              divisions: 18,
              activeColor: AppColors.orange,
              inactiveColor: AppColors.divider,
              label: '${_sliderVal.toStringAsFixed(0)} km/h',
              onChanged: (v) => setState(() => _sliderVal = v),
              onChangeEnd: (v) => notifier.setThreshold(v),
            ),
          ],
          const SizedBox(height: 8),

          // Forget device
          if (widget.onForgetTap != null)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.danger, width: 0.8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.link_off, size: 16),
                label: const Text('Quên xe đã lưu'),
                onPressed: widget.onForgetTap,
              ),
            ),
        ],
      ),
    );
  }
}
