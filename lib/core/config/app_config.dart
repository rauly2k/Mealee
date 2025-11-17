library;

import 'package:flutter/foundation.dart';

/// Application configuration and environment variables
///
/// This class manages all environment-specific configurations including
/// API keys, feature flags, and environment settings.
///
/// Usage:
/// 1. Create a .env file in the project root with your keys:
///    GEMINI_API_KEY=your_key_here
/// 2. Access config values: AppConfig.geminiApiKey
/// 3. Check environment: AppConfig.isProduction

class AppConfig {
  // Private constructor to prevent instantiation
  AppConfig._();

  // Environment
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  // API Keys
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  // Firebase Configuration
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'mealee-app',
  );

  // App Configuration
  static const String appName = 'Mealee';
  static const String appVersion = '1.0.0';
  static const int buildNumber = 1;

  // Feature Flags
  static const bool enableAI = true;
  static const bool enableOfflineMode = true;
  static const bool enableAnalytics = false; // Will be enabled in production
  static const bool enableCrashReporting = false; // Will be enabled in production
  static const bool enablePushNotifications = false; // Future feature

  // API Configuration
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Cache Configuration
  static const Duration cacheExpiry = Duration(hours: 24);
  static const int maxCacheSize = 100; // MB
  static const bool enableImageCache = true;

  // Pagination
  static const int recipesPerPage = 20;
  static const int logsPerPage = 50;
  static const int plantsPerPage = 30;

  // Nutrition Limits
  static const int minCalories = 1200;
  static const int maxCalories = 5000;
  static const double minProteinPercent = 10.0;
  static const double maxProteinPercent = 40.0;
  static const double minCarbsPercent = 20.0;
  static const double maxCarbsPercent = 65.0;
  static const double minFatsPercent = 15.0;
  static const double maxFatsPercent = 40.0;

  // Expiry Warning Days
  static const int expiryWarningDays = 7;
  static const int expiryUrgentDays = 3;

  // Upload Limits
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];

  // Session Configuration
  static const Duration sessionTimeout = Duration(hours: 24);
  static const bool rememberMe = true;

  // UI Configuration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackbarDuration = Duration(seconds: 3);
  static const Duration toastDuration = Duration(seconds: 2);

  // Validation
  static const int minPasswordLength = 6;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minAge = 13;
  static const int maxAge = 120;
  static const double minHeight = 100; // cm
  static const double maxHeight = 250; // cm
  static const double minWeight = 30; // kg
  static const double maxWeight = 300; // kg

  // Getters for environment checks
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';
  static bool get isStaging => environment == 'staging';

  // Validation helpers
  static bool get hasGeminiApiKey => geminiApiKey.isNotEmpty;

  /// Validates that all required configuration is present
  static bool validateConfig() {
    final errors = <String>[];

    if (!hasGeminiApiKey && enableAI) {
      errors.add('GEMINI_API_KEY is required when AI features are enabled');
    }

    if (firebaseProjectId.isEmpty) {
      errors.add('FIREBASE_PROJECT_ID is required');
    }

    if (errors.isNotEmpty) {
      debugPrint('⚠️ Configuration Errors:');
      for (final error in errors) {
        debugPrint('  - $error');
      }
      return false;
    }

    return true;
  }

  /// Prints current configuration (safe for logging)
  static void printConfig() {
    debugPrint('═══════════════════════════════════════');
    debugPrint('🔧 Mealee App Configuration');
    debugPrint('═══════════════════════════════════════');
    debugPrint('Environment: $environment');
    debugPrint('App Version: $appVersion ($buildNumber)');
    debugPrint('Firebase Project: $firebaseProjectId');
    debugPrint('AI Enabled: $enableAI');
    debugPrint('Gemini API Key: ${hasGeminiApiKey ? "✓ Configured" : "✗ Missing"}');
    debugPrint('Offline Mode: $enableOfflineMode');
    debugPrint('Analytics: $enableAnalytics');
    debugPrint('Crash Reporting: $enableCrashReporting');
    debugPrint('═══════════════════════════════════════');
  }
}
