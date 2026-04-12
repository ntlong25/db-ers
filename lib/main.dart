import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'services/foreground_service_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo cấu hình foreground task (phải gọi trước runApp)
  initForegroundTask();

  runApp(
    const ProviderScope(
      child: WithForegroundTask(
        child: DtcBikeApp(),
      ),
    ),
  );
}
