import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../models/app_settings.dart';
import 'tts_service.dart';
import 'notification_service.dart';
import 'phrases_service.dart';

/// Core service that orchestrates chime, TTS, and notifications.
/// Uses smart scheduling - calculates exact next chime time and sleeps until then.
/// 
/// HIBERNATE/WAKE FIX:
/// - Validates timer is not stale before triggering chime
/// - Uses heartbeat to detect system time jumps (hibernate/wake)
/// - Automatically reschedules after detecting time drift
class ChimeService {
  final TtsService _ttsService;
  final NotificationService _notificationService;
  final PhrasesService _phrasesService;
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  Timer? _currentTimer;
  Timer? _heartbeatTimer;
  AppSettings _settings;
  bool _isRunning = false;
  DateTime? _nextChimeTime;
  DateTime _lastHeartbeatTime = DateTime.now();
  
  /// Maximum tolerance for timer validity (±60 seconds)
  static const _timerToleranceSeconds = 60;
  
  /// Heartbeat interval to detect time jumps (30 seconds)
  static const _heartbeatIntervalSeconds = 30;
  
  /// Time jump threshold that triggers reschedule (10 seconds drift = likely hibernate)
  static const _timeJumpThresholdSeconds = 10;

  /// Callback for when a chime is triggered
  Function(String phrase)? onChime;

  ChimeService({
    required TtsService ttsService,
    required NotificationService notificationService,
    required PhrasesService phrasesService,
    required AppSettings settings,
  })  : _ttsService = ttsService,
        _notificationService = notificationService,
        _phrasesService = phrasesService,
        _settings = settings;

  bool get isRunning => _isRunning;
  AppSettings get settings => _settings;
  DateTime? get nextChimeTime => _nextChimeTime;

  /// Initialize the service
  Future<void> initialize() async {
    await _ttsService.initialize();
    await _notificationService.initialize();
    await _phrasesService.initialize();
    
    // Set audio player volume
    await _audioPlayer.setVolume(_settings.chimeVolume);
  }

  /// Start the chime scheduler
  void start() {
    if (_isRunning) return;

    _isRunning = true;
    _scheduleNextChime();
    _startHeartbeat();
  }

  /// Stop the chime scheduler
  void stop() {
    _currentTimer?.cancel();
    _currentTimer = null;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _nextChimeTime = null;
    _isRunning = false;
  }

  /// Restart with new settings
  void restart() {
    stop();
    start();
  }

  /// Update settings
  void updateSettings(AppSettings newSettings) {
    _settings = newSettings;
    _audioPlayer.setVolume(_settings.chimeVolume);
    
    // Note: TTS language is now handled inside speakChime()
    
    // Restart scheduler if running (to apply new interval)
    if (_isRunning) {
      restart();
    }
  }

  /// Start the heartbeat timer to detect time jumps (hibernate/wake)
  void _startHeartbeat() {
    _lastHeartbeatTime = DateTime.now();
    _heartbeatTimer?.cancel();
    
    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: _heartbeatIntervalSeconds),
      (_) => _onHeartbeat(),
    );
  }
  
  /// Heartbeat callback - detects time jumps from hibernate/wake
  void _onHeartbeat() {
    final now = DateTime.now();
    const expectedElapsed = Duration(seconds: _heartbeatIntervalSeconds);
    final actualElapsed = now.difference(_lastHeartbeatTime);
    
    // If actual elapsed time differs significantly from expected,
    // a time jump occurred (hibernate/wake)
    final drift = (actualElapsed.inSeconds - expectedElapsed.inSeconds).abs();
    
    if (drift > _timeJumpThresholdSeconds) {
      debugPrint('Time jump detected: drift=${drift}s. Rescheduling chime timer.');
      _rescheduleAfterTimeJump();
    }
    
    _lastHeartbeatTime = now;
  }
  
  /// Reschedule after detecting a time jump (hibernate/wake)
  void _rescheduleAfterTimeJump() {
    _currentTimer?.cancel();
    _currentTimer = null;
    _scheduleNextChime();
  }

  /// Smart scheduler: Calculate next exact chime time and schedule
  void _scheduleNextChime() {
    final now = DateTime.now();
    DateTime next;

    switch (_settings.interval) {
      case ChimeInterval.oneHour:
        // Next exact hour (:00)
        next = DateTime(now.year, now.month, now.day, now.hour + 1, 0, 0);
        break;
        
      case ChimeInterval.thirtyMinutes:
        // Next :00 or :30 — whichever comes first
        if (now.minute < 30) {
          next = DateTime(now.year, now.month, now.day, now.hour, 30, 0);
        } else {
          next = DateTime(now.year, now.month, now.day, now.hour + 1, 0, 0);
        }
        break;
        
      case ChimeInterval.twoHours:
        // Next even hour (:00 only)
        int currentHour = now.hour;
        int nextHour;
        if (currentHour % 2 == 0) {
          // Currently at even hour, go to next even hour
          nextHour = currentHour + 2;
        } else {
          // Currently at odd hour, go to next even hour
          nextHour = currentHour + 1;
        }
        next = DateTime(now.year, now.month, now.day, nextHour, 0, 0);
        break;
        
      case ChimeInterval.oneMinute:
        // Test mode: next exact minute
        next = DateTime(now.year, now.month, now.day, now.hour, now.minute + 1, 0);
        break;
    }

    _nextChimeTime = next;
    final delay = next.difference(now);

    debugPrint('Next chime scheduled at: $next (in ${delay.inSeconds} seconds)');

    _currentTimer?.cancel();
    _currentTimer = Timer(delay, () {
      _onTimerFired(next);
    });
  }
  
  /// Timer callback - validates and triggers chime or reschedules
  void _onTimerFired(DateTime scheduledTime) {
    final now = DateTime.now();
    final diff = now.difference(scheduledTime).inSeconds.abs();
    
    // HIBERNATE/WAKE FIX: Validate the timer is not stale
    if (diff > _timerToleranceSeconds) {
      // Timer is stale (likely fired after hibernate/wake)
      // Skip this chime and reschedule for the correct next time
      debugPrint(
        'Stale timer detected: scheduled=$scheduledTime, now=$now, diff=${diff}s. '
        'Skipping and rescheduling.',
      );
      _scheduleNextChime();
      return;
    }
    
    // Timer is valid - trigger the chime
    _triggerChime(scheduledTime);
    _scheduleNextChime();
  }

  /// Trigger a chime with all enabled features
  Future<void> _triggerChime(DateTime chimeTime) async {
    final phrase = _phrasesService.getRandomPhrase();
    
    // Notify listeners
    onChime?.call(phrase);

    // Play chime sound
    if (_settings.chimeEnabled) {
      await _playChimeSound();
    }

    // Show notification
    if (_settings.notificationEnabled) {
      await _notificationService.showTimeNotification(phrase);
    }

    // Speak time and/or phrase
    if (_settings.speechEnabled) {
      // Small delay to let the chime finish
      await Future.delayed(const Duration(milliseconds: 500));
      await _ttsService.speakChime(chimeTime, _settings);
    }
  }

  /// Play the chime sound
  Future<void> _playChimeSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setVolume(_settings.chimeVolume);
      await _audioPlayer.play(AssetSource('sounds/chime.wav'));
    } catch (e) {
      debugPrint('Error playing chime sound: $e');
      // Try alternate sound if main fails
      try {
        await _audioPlayer.play(AssetSource('sounds/chime.mp3'));
      } catch (_) {}
    }
  }

  /// Test function - triggers all enabled features immediately
  Future<void> testNow() async {
    await _triggerChime(DateTime.now());
  }

  /// Get the next scheduled chime time
  DateTime? getNextChimeTime() {
    return _nextChimeTime;
  }

  /// Dispose resources
  void dispose() {
    stop();
    _audioPlayer.dispose();
    _ttsService.dispose();
  }
}
