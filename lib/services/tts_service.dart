import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/app_settings.dart';

/// TTS Service - Uses Windows SAPI for both Arabic and English.
/// Arabic text uses FULL tashkeel (diacritics) for crystal-clear pronunciation.
///
/// Requirements:
/// - English: Built-in Windows voice (always available)
/// - Arabic: Windows Arabic voice pack (Settings > Time & Language > Speech)
class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  final Random _random = Random();

  bool _isInitialized = false;
  bool _hasArabicVoice = false;
  String _arabicVoiceName = '';
  String _arabicVoiceLocale = '';

  // ──────────────────────────────────────────────
  // Arabic time components with FULL tashkeel
  // ──────────────────────────────────────────────

  /// Egyptian Arabic hours (with tashkeel)
  static const Map<int, String> _hoursEgyptian = {
    1: 'الْوَاحْدَة',
    2: 'الِاتْنِين',
    3: 'التَّلَاتَة',
    4: 'الْأَرْبَعَة',
    5: 'الْخَمْسَة',
    6: 'السِّتَّة',
    7: 'السَّبْعَة',
    8: 'التَّمَانْيَة',
    9: 'التِّسْعَة',
    10: 'الْعَشَرَة',
    11: 'الْحِدَاشَر',
    12: 'الِاتْنَاشَر',
  };

  /// Formal Arabic hours (with tashkeel)
  static const Map<int, String> _hoursFormal = {
    1: 'الْوَاحِدَةُ',
    2: 'الثَّانِيَةُ',
    3: 'الثَّالِثَةُ',
    4: 'الرَّابِعَةُ',
    5: 'الْخَامِسَةُ',
    6: 'السَّادِسَةُ',
    7: 'السَّابِعَةُ',
    8: 'الثَّامِنَةُ',
    9: 'التَّاسِعَةُ',
    10: 'الْعَاشِرَةُ',
    11: 'الْحَادِيَةَ عَشْرَةَ',
    12: 'الثَّانِيَةَ عَشْرَةَ',
  };

  /// Period names — Egyptian
  static const Map<String, String> _periodsEgyptian = {
    'morning': 'الصُّبْح',
    'noon': 'الضُّهْر',
    'afternoon': 'بَعْدِ الضُّهْر',
    'asr': 'الْعَصْر',
    'night': 'بِاللِّيل',
  };

  /// Period names — Formal
  static const Map<String, String> _periodsFormal = {
    'morning': 'صَبَاحًا',
    'noon': 'ظُهْرًا',
    'afternoon': 'بَعْدَ الظُّهْرِ',
    'asr': 'عَصْرًا',
    'night': 'مَسَاءً',
  };

  /// Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      debugPrint('=== TTS SERVICE INIT ===');

      // Check available voices for Arabic support
      final voices = await _flutterTts.getVoices;
      if (voices != null) {
        final voiceList = List<Map<dynamic, dynamic>>.from(voices);
        
        // Find all Arabic voices
        final arabicVoices = voiceList.where((v) {
          final locale = (v['locale'] ?? v['name'] ?? '').toString().toLowerCase();
          return locale.startsWith('ar');
        }).toList();
        
        _hasArabicVoice = arabicVoices.isNotEmpty;
        debugPrint('Arabic voices found: ${arabicVoices.length}');
        
        if (_hasArabicVoice) {
          // Log all Arabic voices
          for (final v in arabicVoices) {
            debugPrint('  Voice: ${v['name']} | Locale: ${v['locale']}');
          }
          
          // Prefer male voice — common male Arabic SAPI voices contain:
          // "Naayf" (ar-SA male), "Hadi" (ar-SA male)
          // Female voices: "Hoda", "Salma", "Zariyah"
          final maleKeywords = ['naayf', 'hadi', 'male', 'shakir'];
          final femaleKeywords = ['hoda', 'salma', 'zariyah', 'female'];
          
          // Try to find a male voice first
          Map<dynamic, dynamic>? selectedVoice;
          for (final v in arabicVoices) {
            final name = (v['name'] ?? '').toString().toLowerCase();
            if (maleKeywords.any((k) => name.contains(k))) {
              selectedVoice = v;
              break;
            }
          }
          
          // If no male found, pick any voice that's NOT female
          if (selectedVoice == null) {
            for (final v in arabicVoices) {
              final name = (v['name'] ?? '').toString().toLowerCase();
              if (!femaleKeywords.any((k) => name.contains(k))) {
                selectedVoice = v;
                break;
              }
            }
          }
          
          // Fallback to first Arabic voice
          selectedVoice ??= arabicVoices.first;
          
          _arabicVoiceName = (selectedVoice['name'] ?? '').toString();
          _arabicVoiceLocale = (selectedVoice['locale'] ?? '').toString();
          debugPrint('Selected Arabic voice: $_arabicVoiceName ($_arabicVoiceLocale)');
        }
      }

      // Default to English
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      _isInitialized = true;
      debugPrint('=== TTS READY ===');
    } catch (e) {
      debugPrint('TTS init error: $e');
      _isInitialized = true;
    }
  }

  /// Speak text and wait for completion
  Future<void> _speak(String text, {String language = 'en-US', double rate = 0.5, bool isArabic = false}) async {
    try {
      debugPrint('TTS [$language]: "$text"');

      // For Arabic, set the specific voice we selected
      if (isArabic && _arabicVoiceName.isNotEmpty) {
        await _flutterTts.setVoice({
          'name': _arabicVoiceName,
          'locale': _arabicVoiceLocale,
        });
      } else {
        await _flutterTts.setLanguage(language);
      }
      
      await _flutterTts.setSpeechRate(rate);
      await _flutterTts.setVolume(1.0);
      // Deeper pitch for male voice feel
      await _flutterTts.setPitch(isArabic ? 0.9 : 1.0);

      final completer = Completer<void>();

      _flutterTts.setCompletionHandler(() {
        if (!completer.isCompleted) {
          completer.complete();
        }
      });

      _flutterTts.setErrorHandler((msg) {
        debugPrint('TTS error: $msg');
        if (!completer.isCompleted) {
          completer.complete();
        }
      });

      await _flutterTts.stop();
      await _flutterTts.speak(text);

      await completer.future.timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          debugPrint('TTS timeout');
        },
      );

      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      debugPrint('TTS speak error: $e');
    }
  }

  /// Get the period key based on hour
  String _getPeriodKey(int hour24) {
    if (hour24 >= 5 && hour24 < 12) return 'morning';
    if (hour24 == 12) return 'noon';
    if (hour24 >= 13 && hour24 < 16) return 'afternoon';
    if (hour24 >= 16 && hour24 < 19) return 'asr';
    return 'night';
  }

  /// Build full Arabic time sentence with tashkeel
  String _getArabicTime(DateTime now, TtsLanguage lang) {
    final int hour24 = now.hour;
    final int minute = now.minute;
    int hour12 = hour24 % 12;
    if (hour12 == 0) hour12 = 12;

    final bool isEgyptian = (lang == TtsLanguage.egyptianArabic);
    final hours = isEgyptian ? _hoursEgyptian : _hoursFormal;
    final periods = isEgyptian ? _periodsEgyptian : _periodsFormal;

    final hourName = hours[hour12]!;
    final periodName = periods[_getPeriodKey(hour24)]!;

    // Build the sentence
    final buffer = StringBuffer();

    if (isEgyptian) {
      buffer.write('السَّاعَة $hourName');
    } else {
      buffer.write('السَّاعَةُ $hourName');
    }

    // Add minutes
    if (minute == 30) {
      buffer.write(isEgyptian ? ' وَنُصّ' : ' وَالنِّصْفُ');
    } else if (minute == 15) {
      buffer.write(isEgyptian ? ' وَرُبْع' : ' وَالرُّبْعُ');
    } else if (minute == 45) {
      buffer.write(isEgyptian ? ' إلَّا رُبْع' : ' إِلَّا رُبْعًا');
    }

    // Add period
    buffer.write(' $periodName');

    return buffer.toString();
  }

  /// Get English time string
  String _getEnglishTime(DateTime now) {
    int hour24 = now.hour;
    int minute = now.minute;
    int hour12 = hour24 % 12;
    if (hour12 == 0) hour12 = 12;

    String period = hour24 >= 12 ? 'P.M.' : 'A.M.';

    if (minute == 0 && hour24 == 0) return "It's midnight";
    if (minute == 0 && hour24 == 12) return "It's noon";

    if (minute == 0) {
      return "It's $hour12 o'clock $period";
    } else if (minute == 30) {
      return "It's half past $hour12 $period";
    } else if (minute == 15) {
      return "It's quarter past $hour12 $period";
    } else if (minute == 45) {
      int nextHour = hour12 == 12 ? 1 : hour12 + 1;
      return "It's quarter to $nextHour $period";
    } else {
      return "It's $hour12 $minute $period";
    }
  }

  /// Get a random dhikr phrase with full tashkeel for TTS
  String _getRandomDhikrForTts() {
    const dhikrWithTashkeel = [
      'سُبْحَانَ اللهِ وَبِحَمْدِهِ',
      'سُبْحَانَ اللهِ الْعَظِيمِ',
      'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
      'لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ',
      'اللهُ أَكْبَرُ كَبِيرًا',
      'أَسْتَغْفِرُ اللهَ الْعَظِيمَ وَأَتُوبُ إِلَيْهِ',
      'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللهِ',
      'حَسْبِيَ اللهُ وَنِعْمَ الْوَكِيلُ',
      'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ',
      'بِسْمِ اللهِ الرَّحْمَنِ الرَّحِيمِ',
      'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
      'رَبِّ زِدْنِي عِلْمًا',
      'أَلَا بِذِكْرِ اللهِ تَطْمَئِنُّ الْقُلُوبُ',
      'وَتَوَكَّلْ عَلَى اللهِ وَكَفَى بِاللهِ وَكِيلًا',
      'فَاذْكُرُونِي أَذْكُرْكُمْ',
      'إِنَّ اللهَ مَعَ الصَّابِرِينَ',
      'وَمَنْ يَتَّقِ اللهَ يَجْعَلْ لَهُ مَخْرَجًا',
      'تَبَسُّمُكَ فِي وَجْهِ أَخِيكَ صَدَقَةٌ',
      'خَيْرُ النَّاسِ أَنْفَعُهُمْ لِلنَّاسِ',
      'الصَّبْرُ مِفْتَاحُ الْفَرَجِ',
    ];
    return dhikrWithTashkeel[_random.nextInt(dhikrWithTashkeel.length)];
  }

  /// MAIN FUNCTION: Speak chime based on settings
  Future<void> speakChime(DateTime now, AppSettings settings) async {
    if (!_isInitialized) await initialize();

    debugPrint('');
    debugPrint('========================================');
    debugPrint('SPEAK CHIME');
    debugPrint('Time: ${now.hour}:${now.minute.toString().padLeft(2, '0')}');
    debugPrint('Language: ${settings.ttsLanguage}');
    debugPrint('========================================');

    try {
      // ENGLISH MODE
      if (settings.ttsLanguage == TtsLanguage.english) {
        debugPrint('>>> ENGLISH MODE <<<');

        if (settings.announceTime) {
          await _speak(_getEnglishTime(now), language: 'en-US', rate: 0.5);
        }

        if (settings.announceDhikr) {
          final phrases = [
            'Glory be to God',
            'Praise be to God',
            'God is the Greatest',
            'There is no god but God',
            'I seek God\'s forgiveness',
          ];
          await _speak(phrases[_random.nextInt(phrases.length)], language: 'en-US', rate: 0.5);
        }
      }
      // ARABIC MODE (Egyptian or Formal)
      else {
        final langCode = settings.ttsLanguage == TtsLanguage.egyptianArabic
            ? 'ar-EG'
            : 'ar-SA';
        debugPrint('>>> ARABIC MODE ($langCode) with tashkeel <<<');

        if (settings.announceTime) {
          final timeText = _getArabicTime(now, settings.ttsLanguage);
          debugPrint('Arabic time text: $timeText');
          await _speak(timeText, language: langCode, rate: 0.45, isArabic: true);
        }

        if (settings.announceDhikr) {
          final dhikr = _getRandomDhikrForTts();
          debugPrint('Dhikr text: $dhikr');
          await _speak(dhikr, language: langCode, rate: 0.4, isArabic: true);
        }
      }

      debugPrint('========== DONE ==========');
    } catch (e) {
      debugPrint('speakChime error: $e');
    }
  }

  /// Stop speaking
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (_) {}
  }

  /// Dispose resources
  void dispose() {
    _flutterTts.stop();
  }

  /// Whether Arabic SAPI voice is available on this Windows
  bool get hasArabicVoice => _hasArabicVoice;
}
