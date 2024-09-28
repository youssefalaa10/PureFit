import 'package:shared_preferences/shared_preferences.dart';

class TrackStepSharedPref {
  final SharedPreferences _prefs;

  TrackStepSharedPref(this._prefs);

  // Initialize preferences
  static Future<TrackStepSharedPref> create() async {
    final prefs = await SharedPreferences.getInstance();
    return TrackStepSharedPref(prefs);
  }

  // Check if this is the first launch
  bool isFirstLaunch() {
    return _prefs.getBool('isFirstLaunch') ?? true;
  }

  // Load saved steps and initial steps
  Future<Map<String, int>> loadSteps() async {
    int savedSteps = _prefs.getInt('savedSteps') ?? 0;
    int initialSteps = _prefs.getInt('initialSteps') ?? 0;

    return {
      'savedSteps': savedSteps,
      'initialSteps': initialSteps,
    };
  }

  // Save initial steps
  Future<void> saveInitialSteps(int initialSteps) async {
    await _prefs.setInt('initialSteps', initialSteps);
  }

  // Save current saved steps
  Future<void> saveSavedSteps(int savedSteps) async {
    await _prefs.setInt('savedSteps', savedSteps);
  }

  // Mark the app as not first launch
  Future<void> markFirstLaunchComplete() async {
    await _prefs.setBool('isFirstLaunch', false);
  }

  // Reset all preferences (optional)
  Future<void> resetPreferences() async {
    await _prefs.clear(); // Clears all stored preferences
  }
}
