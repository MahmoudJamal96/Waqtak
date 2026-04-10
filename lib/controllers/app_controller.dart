import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'package:launch_at_startup/launch_at_startup.dart';

import '../models/app_settings.dart';
import '../services/tray_service.dart';
import '../services/chime_service.dart';
import '../services/tts_service.dart';
import '../services/notification_service.dart';
import '../services/phrases_service.dart';
import '../screens/settings_screen.dart';

/// Main controller that manages the app lifecycle and coordinates services.
/// 
/// Responsibilities:
/// - Initialize and coordinate all services
/// - Handle window events (close, focus)
/// - Manage app settings persistence
/// - Route tray menu actions
class AppController extends StatefulWidget {
  const AppController({super.key});

  @override
  State<AppController> createState() => _AppControllerState();
}

class _AppControllerState extends State<AppController> with WindowListener {
  // Services
  late TtsService _ttsService;
  late NotificationService _notificationService;
  late PhrasesService _phrasesService;
  late ChimeService _chimeService;
  late TrayService _trayService;
  
  // Settings
  AppSettings _settings = AppSettings();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize services
    _ttsService = TtsService();
    _notificationService = NotificationService();
    _phrasesService = PhrasesService();
    
    // Load settings
    await _loadSettings();
    
    // Create chime service with loaded settings
    _chimeService = ChimeService(
      ttsService: _ttsService,
      notificationService: _notificationService,
      phrasesService: _phrasesService,
      settings: _settings,
    );
    
    // Initialize all services
    await _chimeService.initialize();
    
    // Sync phrases from service to settings
    _settings = _settings.copyWith(phrases: _phrasesService.phrases.toList());
    
    // Initialize tray
    _trayService = TrayService();
    await _trayService.initialize();
    
    // Setup tray callbacks
    _trayService.onOpenSettings = _showSettings;
    _trayService.onTestNow = _testNow;
    _trayService.onQuit = _quitApp;
    
    // Setup chime callback
    _chimeService.onChime = (phrase) {
      debugPrint('Chime triggered: $phrase');
    };
    
    // Apply startup setting
    await _applyStartupSetting();
    
    // Prevent window close - hide instead
    await windowManager.setPreventClose(true);
    
    // Start the chime service
    _chimeService.start();
    
    setState(() {
      _isInitialized = true;
    });
    
    debugPrint('Waqtak initialized and running in tray');
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString('app_settings');
      if (settingsJson != null) {
        _settings = AppSettings.fromJsonString(settingsJson);
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
      _settings = AppSettings();
    }
  }

  Future<void> _saveSettings(AppSettings newSettings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_settings', newSettings.toJsonString());
      
      // Update phrases service
      await _phrasesService.updatePhrases(newSettings.phrases);
      
      // Update chime service
      _chimeService.updateSettings(newSettings);
      
      // Apply startup setting
      _settings = newSettings;
      await _applyStartupSetting();
      
      setState(() {});
      
      debugPrint('Settings saved');
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  Future<void> _applyStartupSetting() async {
    try {
      if (_settings.runAtStartup) {
        await launchAtStartup.enable();
      } else {
        await launchAtStartup.disable();
      }
    } catch (e) {
      debugPrint('Error applying startup setting: $e');
    }
  }

  void _showSettings() async {
    await windowManager.show();
    await windowManager.focus();
  }

  void _hideSettings() async {
    await windowManager.hide();
  }

  void _testNow() {
    _chimeService.testNow();
  }

  void _quitApp() async {
    // Cleanup
    _chimeService.dispose();
    await _trayService.destroy();
    
    // Force quit
    exit(0);
  }

  @override
  void onWindowClose() async {
    // Hide window instead of closing
    _hideSettings();
  }

  @override
  void onWindowFocus() {
    // Window gained focus
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _chimeService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.teal),
              SizedBox(height: 16),
              Text('جاري تشغيل وقتك...', style: TextStyle(fontFamily: 'Cairo')),
            ],
          ),
        ),
      );
    }

    return SettingsScreen(
      settings: _settings,
      onSave: _saveSettings,
      onTestNow: _testNow,
      isArabicTtsAvailable: _ttsService.hasArabicVoice,
    );
  }
}
