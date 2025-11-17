import 'package:shared_preferences/shared_preferences.dart';

/// Service for local storage using SharedPreferences
class LocalStorageService {
  LocalStorageService._();

  static final LocalStorageService instance = LocalStorageService._();
  static SharedPreferences? _preferences;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Get SharedPreferences instance
  SharedPreferences get prefs {
    if (_preferences == null) {
      throw Exception(
        'LocalStorageService not initialized. Call LocalStorageService.init() first.',
      );
    }
    return _preferences!;
  }

  // Keys
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyFirstLaunch = 'first_launch';
  static const String keyLastSyncDate = 'last_sync_date';
  static const String keyDarkMode = 'dark_mode';
  static const String keyLanguage = 'language';
  static const String keyNotificationsEnabled = 'notifications_enabled';

  // Onboarding
  bool get isOnboardingCompleted =>
      prefs.getBool(keyOnboardingCompleted) ?? false;
  Future<bool> setOnboardingCompleted(bool value) =>
      prefs.setBool(keyOnboardingCompleted, value);

  // First launch
  bool get isFirstLaunch => prefs.getBool(keyFirstLaunch) ?? true;
  Future<bool> setFirstLaunch(bool value) =>
      prefs.setBool(keyFirstLaunch, value);

  // Last sync date
  DateTime? get lastSyncDate {
    final timestamp = prefs.getInt(keyLastSyncDate);
    return timestamp != null
        ? DateTime.fromMillisecondsSinceEpoch(timestamp)
        : null;
  }

  Future<bool> setLastSyncDate(DateTime date) =>
      prefs.setInt(keyLastSyncDate, date.millisecondsSinceEpoch);

  // Dark mode
  bool get isDarkMode => prefs.getBool(keyDarkMode) ?? false;
  Future<bool> setDarkMode(bool value) => prefs.setBool(keyDarkMode, value);

  // Language
  String get language => prefs.getString(keyLanguage) ?? 'ro';
  Future<bool> setLanguage(String value) =>
      prefs.setString(keyLanguage, value);

  // Notifications
  bool get notificationsEnabled =>
      prefs.getBool(keyNotificationsEnabled) ?? true;
  Future<bool> setNotificationsEnabled(bool value) =>
      prefs.setBool(keyNotificationsEnabled, value);

  // Clear all data
  Future<bool> clearAll() => prefs.clear();

  // Clear specific key
  Future<bool> remove(String key) => prefs.remove(key);
}
