import 'package:system_tray/system_tray.dart';
import 'package:flutter/material.dart';

/// Manages the Windows system tray icon and menu for Waqtak.
/// 
/// Provides:
/// - Tray icon with tooltip
/// - Context menu with settings, test, and quit options
/// - Click handlers for tray interactions
class TrayService {
  final SystemTray _systemTray = SystemTray();
  final Menu _menu = Menu();

  /// Callbacks for menu actions
  VoidCallback? onOpenSettings;
  VoidCallback? onTestNow;
  VoidCallback? onQuit;

  /// Initialize the system tray
  Future<void> initialize() async {
    // Initialize the system tray icon
    await _systemTray.initSystemTray(
      title: 'وقتك - Waqtak',
      iconPath: 'assets/images/tray_icon.ico',
      toolTip: 'وقتك - Waqtak | Click to open settings',
    );

    // Build the context menu
    await _buildMenu();

    // Register event handlers
    _systemTray.registerSystemTrayEventHandler((eventName) {
      if (eventName == kSystemTrayEventClick) {
        // Left click - open settings
        onOpenSettings?.call();
      } else if (eventName == kSystemTrayEventRightClick) {
        // Right click - show context menu
        _systemTray.popUpContextMenu();
      }
    });
  }

  /// Build the context menu (text-only, no icons)
  Future<void> _buildMenu() async {
    await _menu.buildFrom([
      MenuItemLabel(
        label: 'Open Settings (الإعدادات)',
        onClicked: (menuItem) {
          onOpenSettings?.call();
        },
      ),
      MenuSeparator(),
      MenuItemLabel(
        label: 'Test Now (اختبر الآن)',
        onClicked: (menuItem) {
          onTestNow?.call();
        },
      ),
      MenuSeparator(),
      MenuItemLabel(
        label: 'Quit (إغلاق)',
        onClicked: (menuItem) {
          onQuit?.call();
        },
      ),
    ]);

    await _systemTray.setContextMenu(_menu);
  }

  /// Update the tray tooltip
  Future<void> setToolTip(String tooltip) async {
    await _systemTray.setToolTip(tooltip);
  }

  /// Update the tray icon
  Future<void> setIcon(String iconPath) async {
    await _systemTray.setImage(iconPath);
  }

  /// Show a balloon notification from tray
  Future<void> showBalloon({
    required String title,
    required String body,
  }) async {
    // Note: system_tray doesn't directly support balloon notifications
    // We use flutter_local_notifications for this instead
  }

  /// Destroy the system tray
  Future<void> destroy() async {
    await _systemTray.destroy();
  }
}
