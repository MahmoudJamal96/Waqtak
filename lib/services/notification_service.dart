import 'dart:io';
import 'package:flutter/foundation.dart';

/// Service for Windows notifications using native Windows toast notifications.
/// 
/// Features:
/// - Windows Toast notifications with custom title/body
/// - Fallback to balloon tip notifications
/// - Arabic and English text support
class NotificationService {
  bool _isInitialized = false;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
  }

  /// Show a notification with the current time and phrase
  Future<void> showChimeNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      // Use PowerShell to show Windows Toast notification
      await _showWindowsToast(title, body);
    } catch (e) {
      debugPrint('Notification error: $e');
    }
  }

  /// Show a time-based chime notification
  Future<void> showTimeNotification(String phrase) async {
    final now = DateTime.now();
    final timeString = _formatTime(now);

    await showChimeNotification(
      title: '🕐 $timeString - وقت الذكر',
      body: phrase,
      payload: 'chime_${now.millisecondsSinceEpoch}',
    );
  }

  /// Format time for display
  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  /// Show Windows toast notification using PowerShell
  Future<void> _showWindowsToast(String title, String body) async {
    // Escape special characters for PowerShell
    final escapedTitle = title.replaceAll("'", "''").replaceAll('"', '`"');
    final escapedBody = body.replaceAll("'", "''").replaceAll('"', '`"');

    final script = '''
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

\$template = @"
<toast>
  <visual>
    <binding template="ToastText02">
      <text id="1">$escapedTitle</text>
      <text id="2">$escapedBody</text>
    </binding>
  </visual>
  <audio src="ms-winsoundevent:Notification.Default"/>
</toast>
"@

\$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
\$xml.LoadXml(\$template)
\$toast = [Windows.UI.Notifications.ToastNotification]::new(\$xml)
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Waqtak").Show(\$toast)
''';

    try {
      await Process.run(
        'powershell',
        ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command', script],
        runInShell: true,
      );
    } catch (e) {
      debugPrint('Toast notification error: $e');
      // Fallback: try simpler BurntToast approach or msg.exe
      await _showFallbackNotification(title, body);
    }
  }

  /// Fallback notification using msg.exe (console dialog)
  Future<void> _showFallbackNotification(String title, String body) async {
    try {
      // Use a simple PowerShell balloon tip as fallback
      final script = '''
Add-Type -AssemblyName System.Windows.Forms
\$notify = New-Object System.Windows.Forms.NotifyIcon
\$notify.Icon = [System.Drawing.SystemIcons]::Information
\$notify.Visible = \$true
\$notify.BalloonTipTitle = "$title"
\$notify.BalloonTipText = "$body"
\$notify.ShowBalloonTip(5000)
Start-Sleep -Milliseconds 5100
\$notify.Dispose()
''';

      Process.run(
        'powershell',
        ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command', script],
        runInShell: true,
      );
    } catch (e) {
      debugPrint('Fallback notification error: $e');
    }
  }

  /// Cancel all notifications (not applicable for toast notifications)
  Future<void> cancelAll() async {
    // Toast notifications auto-dismiss, no action needed
  }

  /// Cancel specific notification (not applicable for toast notifications)
  Future<void> cancel(int id) async {
    // Toast notifications auto-dismiss, no action needed
  }
}
