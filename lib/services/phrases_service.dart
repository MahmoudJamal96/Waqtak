import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';

/// Manages the list of Dhikr phrases with persistence.
/// 
/// Features:
/// - Load/save phrases from SharedPreferences
/// - Random phrase selection
/// - CRUD operations for phrases
/// - Reset to defaults
class PhrasesService {
  static const String _phrasesKey = 'dhikr_phrases';
  final Random _random = Random();
  List<String> _phrases = [];

  List<String> get phrases => List.unmodifiable(_phrases);

  /// Initialize phrases from storage or use defaults
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPhrases = prefs.getStringList(_phrasesKey);
    
    if (storedPhrases != null && storedPhrases.isNotEmpty) {
      _phrases = storedPhrases;
    } else {
      _phrases = List.from(AppSettings.defaultPhrases);
      await _savePhrases();
    }
  }

  /// Get a random phrase from the list
  String getRandomPhrase() {
    if (_phrases.isEmpty) {
      return 'سبحان الله';
    }
    return _phrases[_random.nextInt(_phrases.length)];
  }

  /// Add a new phrase
  Future<void> addPhrase(String phrase) async {
    if (phrase.trim().isNotEmpty && !_phrases.contains(phrase.trim())) {
      _phrases.add(phrase.trim());
      await _savePhrases();
    }
  }

  /// Remove a phrase by index
  Future<void> removePhrase(int index) async {
    if (index >= 0 && index < _phrases.length) {
      _phrases.removeAt(index);
      await _savePhrases();
    }
  }

  /// Edit a phrase at index
  Future<void> editPhrase(int index, String newPhrase) async {
    if (index >= 0 && index < _phrases.length && newPhrase.trim().isNotEmpty) {
      _phrases[index] = newPhrase.trim();
      await _savePhrases();
    }
  }

  /// Update all phrases (used when loading from settings)
  Future<void> updatePhrases(List<String> newPhrases) async {
    _phrases = List.from(newPhrases);
    await _savePhrases();
  }

  /// Reset to default phrases
  Future<void> resetToDefaults() async {
    _phrases = List.from(AppSettings.defaultPhrases);
    await _savePhrases();
  }

  /// Save phrases to persistent storage
  Future<void> _savePhrases() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_phrasesKey, _phrases);
  }
}
