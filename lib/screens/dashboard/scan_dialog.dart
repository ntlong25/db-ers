import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ble/bike_ble_constants.dart';
import '../../providers/ble_connection_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_strings.dart';

/// Scan Dialog — bottom sheet hiển thị danh sách xe Datbike tìm được
/// Tương đương device scan list trong MainActivity.java
class ScanDialog extends ConsumerStatefulWidget {
  const ScanDialog({super.key});

  @override
  ConsumerState<ScanDialog> createState() => _ScanDialogState();
}

class _ScanDialogState extends ConsumerState<ScanDialog> {
  final List<ScanResult> _results = [];
  StreamSubscription? _scanSub;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  @override
  void dispose() {
    _scanSub?.cancel();
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  Future<void> _startScan() async {
    setState(() {
      _results.clear();
      _isScanning = true;
    });

    _scanSub?.cancel();
    _scanSub = FlutterBluePlus.scanResults.listen((results) {
      if (!mounted) return;
      setState(() {
        for (final r in results) {
          final name = r.device.platformName.toLowerCase();
          final hasPrefix =
              kBikeNamePrefixes.any((p) => name.startsWith(p));
          final hasService = r.advertisementData.serviceUuids
              .map((u) => u.str128.toLowerCase())
              .any((u) =>
                  u == kServiceDashboard.toLowerCase() ||
                  u == kServiceInfo.toLowerCase());

          if (hasPrefix || hasService) {
            final idx = _results.indexWhere(
                (x) => x.device.remoteId == r.device.remoteId);
            if (idx >= 0) {
              _results[idx] = r;
            } else {
              _results.add(r);
            }
          }
        }
        // Sort theo RSSI (gần nhất lên đầu)
        _results.sort((a, b) => b.rssi.compareTo(a.rssi));
      });
    });

    await FlutterBluePlus.startScan(
      timeout: const Duration(milliseconds: kScanTimeoutMs),
      androidScanMode: AndroidScanMode.lowLatency,
    );

    if (mounted) setState(() => _isScanning = false);
  }

  void _connectTo(BluetoothDevice device) {
    Navigator.pop(context);
    ref.read(bleConnectionProvider.notifier).connectToDevice(device);
  }

  void _startDemo() {
    Navigator.pop(context);
    ref.read(bleConnectionProvider.notifier).startDemoMode();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) {
        return Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Text(
                    S.ble.scanTitle,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  if (_isScanning)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.accent),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 20),
                      onPressed: _startScan,
                      tooltip: S.ble.rescan,
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Demo mode button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: OutlinedButton.icon(
                onPressed: _startDemo,
                icon: const Icon(Icons.play_circle_outline, size: 18),
                label: Text(S.ble.demoMode),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.orange,
                  side: const BorderSide(color: AppColors.orange),
                  minimumSize: const Size.fromHeight(40),
                ),
              ),
            ),
            const Divider(height: 1),
            // Device list
            Expanded(
              child: _results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bluetooth_searching,
                            size: 48,
                            color: _isScanning
                                ? AppColors.accent
                                : Colors.grey,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _isScanning
                                ? S.ble.scanning
                                : S.ble.notFound,
                            style:
                                const TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: _results.length,
                      itemBuilder: (_, i) =>
                          _DeviceTile(result: _results[i], onTap: _connectTo),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _DeviceTile extends StatelessWidget {
  final ScanResult result;
  final void Function(BluetoothDevice) onTap;

  const _DeviceTile({required this.result, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final name = result.device.platformName.isNotEmpty
        ? result.device.platformName
        : 'Datbike (${result.device.remoteId.str})';
    final mac = result.device.remoteId.str;
    final rssi = result.rssi;
    final bars = rssi >= -60
        ? 4
        : rssi >= -70
            ? 3
            : rssi >= -80
                ? 2
                : 1;

    return ListTile(
      leading: const Icon(Icons.electric_moped, color: AppColors.accent),
      title: Text(name),
      subtitle: Text(mac,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$rssi dBm',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(width: 4),
          Icon(
            bars >= 4
                ? Icons.signal_cellular_4_bar
                : bars == 3
                    ? Icons.signal_cellular_alt_2_bar
                    : Icons.signal_cellular_alt_1_bar,
            size: 16,
            color: AppColors.accent,
          ),
        ],
      ),
      onTap: () => onTap(result.device),
    );
  }
}
