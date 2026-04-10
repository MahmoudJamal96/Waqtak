import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:launch_at_startup/launch_at_startup.dart';

import 'controllers/app_controller.dart';

/// Application entry point.
/// 
/// Initializes the window manager and launches the app minimized to tray.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize window manager
  await windowManager.ensureInitialized();

  // Configure window options - hidden by default
  const windowOptions = WindowOptions(
    size: Size(550, 800),
    minimumSize: Size(500, 700),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false, // Show in taskbar when window is visible
    titleBarStyle: TitleBarStyle.normal,
    title: 'وقتك - الإعدادات',
  );

  // Initialize window but keep it hidden
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    // Don't show window on startup - app runs in tray
    await windowManager.hide();
  });

  // Setup launch at startup
  try {
    launchAtStartup.setup(
      appName: 'Waqtak',
      appPath: Platform.resolvedExecutable,
    );
  } catch (e) {
    debugPrint('Launch at startup setup error: $e');
  }

  runApp(const WaqtakApp());
}

/// The main application widget.
class WaqtakApp extends StatelessWidget {
  const WaqtakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'وقتك',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF153457), // Deep Navy Blue
          secondary: const Color(0xFFCCA762), // Gold
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        // Using system font for Arabic support - Segoe UI has good Arabic support on Windows
        fontFamily: 'Segoe UI',
      ),
      home: const AppController(),
    );
  }
}

