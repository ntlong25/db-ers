import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ble/bike_ble_constants.dart';

/// Provider cho MAC address xe đã lưu (SharedPreferences)
/// null = chưa kết nối xe nào
final savedMacProvider =
    StateNotifierProvider<SavedMacNotifier, String?>((ref) {
  return SavedMacNotifier();
});

class SavedMacNotifier extends StateNotifier<String?> {
  SavedMacNotifier() : super(null) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(kPrefSavedMac);
  }

  Future<void> save(String mac, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kPrefSavedMac, mac);
    await prefs.setString(kPrefSavedName, name);
    state = mac;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kPrefSavedMac);
    await prefs.remove(kPrefSavedName);
    state = null;
  }
}

/// Provider tên xe đã lưu
final savedBikeNameProvider = FutureProvider<String?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(kPrefSavedName);
});
