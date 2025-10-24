import 'package:PureFit/Core/helpers/app_logger.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoiceService {
  factory VoiceService() => _instance;
  VoiceService._internal();
  static final VoiceService _instance = VoiceService._internal();

  FlutterTts? _flutterTts;
  bool _isEnabled = true;
  String _language = 'en';

  Future<void> initialize() async {
    _flutterTts = FlutterTts();

    // Load preferences
    final prefs = await SharedPreferences.getInstance();
    _isEnabled = prefs.getBool('voice_enabled') ?? true;
    _language = prefs.getString('voice_language') ?? 'en';

    // Configure TTS
    await _flutterTts?.setLanguage(_language);
    await _flutterTts?.setSpeechRate(0.5);
    await _flutterTts?.setVolume(1.0);
    await _flutterTts?.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    if (!_isEnabled || _flutterTts == null) return;

    try {
      await _flutterTts?.speak(text);
    } catch (e) {
      AppLogger.error('Error speaking: $e');
    }
  }

  Future<void> speakExerciseName(String exerciseName) async {
    await speak('Next exercise: $exerciseName');
  }

  Future<void> speakGetReady(String exerciseName) async {
    await speak('Get ready for $exerciseName');
  }

  Future<void> speakStartExercise(String exerciseName) async {
    await speak('Start $exerciseName');
  }

  Future<void> speakRestTime(int seconds) async {
    await speak('Rest for $seconds seconds');
  }

  Future<void> speakWorkoutComplete() async {
    await speak('Great job! Workout completed!');
  }

  Future<void> speakProgress(int current, int total) async {
    await speak('Exercise $current of $total');
  }

  Future<void> speakTimeRemaining(int seconds) async {
    if (seconds > 0) {
      await speak('$seconds seconds remaining');
    }
  }

  Future<void> speakPersonalRecord(String exerciseName) async {
    await speak('New personal record for $exerciseName!');
  }

  Future<void> speakWorkoutStreak(int days) async {
    await speak('Amazing! $days day workout streak!');
  }

  // Settings
  Future<void> setEnabled(bool enabled) async {
    _isEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('voice_enabled', enabled);
  }

  Future<void> setLanguage(String language) async {
    _language = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('voice_language', language);
    await _flutterTts?.setLanguage(language);
  }

  bool get isEnabled => _isEnabled;
  String get language => _language;

  Future<void> stop() async {
    await _flutterTts?.stop();
  }

  Future<void> dispose() async {
    await _flutterTts?.stop();
  }
}
