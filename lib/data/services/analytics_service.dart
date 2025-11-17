import 'package:flutter/foundation.dart';
import '../../core/config/app_config.dart';
import '../../core/constants/app_constants.dart';

/// Analytics service for tracking user events and app usage
///
/// This service provides a unified interface for analytics tracking.
/// Currently logs to console in debug mode. Can be extended to integrate
/// with Firebase Analytics, Mixpanel, or other analytics platforms.
///
/// Usage:
/// ```dart
/// // Initialize in main.dart
/// AnalyticsService.instance.initialize();
///
/// // Track events
/// AnalyticsService.instance.logEvent('recipe_viewed', parameters: {
///   'recipe_id': recipeId,
///   'recipe_name': recipeName,
/// });
///
/// // Track screens
/// AnalyticsService.instance.logScreenView('RecipeDetail');
///
/// // Set user properties
/// AnalyticsService.instance.setUserId(userId);
/// AnalyticsService.instance.setUserProperty('goal_type', 'weight_loss');
/// ```
class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  bool _initialized = false;
  String? _userId;
  final Map<String, dynamic> _userProperties = {};

  /// Initialize analytics service
  void initialize() {
    if (_initialized) return;

    if (AppConfig.enableAnalytics) {
      // TODO: Initialize analytics SDK (Firebase Analytics, Mixpanel, etc.)
      // await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      debugPrint('✓ Analytics service initialized (enabled)');
    } else {
      debugPrint('✓ Analytics service initialized (disabled)');
    }

    _initialized = true;
  }

  /// Set current user ID
  void setUserId(String? userId) {
    _userId = userId;

    if (AppConfig.enableAnalytics && userId != null) {
      // TODO: Set user ID in analytics platform
      // await FirebaseAnalytics.instance.setUserId(id: userId);
      _logDebug('User ID set: $userId');
    }
  }

  /// Set user property
  void setUserProperty(String name, String? value) {
    _userProperties[name] = value;

    if (AppConfig.enableAnalytics && value != null) {
      // TODO: Set user property in analytics platform
      // await FirebaseAnalytics.instance.setUserProperty(
      //   name: name,
      //   value: value,
      // );
      _logDebug('User property set: $name = $value');
    }
  }

  /// Log custom event
  void logEvent(
    String name, {
    Map<String, dynamic>? parameters,
  }) {
    if (!_initialized) {
      debugPrint('⚠️ Analytics not initialized. Call initialize() first.');
      return;
    }

    if (AppConfig.enableAnalytics) {
      // TODO: Log event to analytics platform
      // await FirebaseAnalytics.instance.logEvent(
      //   name: name,
      //   parameters: parameters,
      // );
      _logDebug('Event: $name ${parameters != null ? "with $parameters" : ""}');
    } else if (kDebugMode) {
      _logDebug('Event (disabled): $name ${parameters != null ? "with $parameters" : ""}');
    }
  }

  /// Log screen view
  void logScreenView(String screenName, {String? screenClass}) {
    logEvent(
      'screen_view',
      parameters: {
        'screen_name': screenName,
        if (screenClass != null) 'screen_class': screenClass,
      },
    );
  }

  // ============== PREDEFINED EVENTS ==============

  /// Authentication Events

  void logLogin(String method) {
    logEvent(
      AppConstants.eventLogin,
      parameters: {'method': method},
    );
  }

  void logRegister(String method) {
    logEvent(
      AppConstants.eventRegister,
      parameters: {'method': method},
    );
  }

  void logLogout() {
    logEvent(AppConstants.eventLogout);
  }

  /// Recipe Events

  void logRecipeView(String recipeId, String recipeName) {
    logEvent(
      AppConstants.eventRecipeView,
      parameters: {
        'recipe_id': recipeId,
        'recipe_name': recipeName,
      },
    );
  }

  void logRecipeLog(String recipeId, String mealType, double calories) {
    logEvent(
      AppConstants.eventRecipeLog,
      parameters: {
        'recipe_id': recipeId,
        'meal_type': mealType,
        'calories': calories,
      },
    );
  }

  void logRecipeSearch(String searchTerm, int resultsCount) {
    logEvent(
      'recipe_search',
      parameters: {
        'search_term': searchTerm,
        'results_count': resultsCount,
      },
    );
  }

  void logRecipeFavorite(String recipeId, bool isFavorite) {
    logEvent(
      'recipe_favorite',
      parameters: {
        'recipe_id': recipeId,
        'is_favorite': isFavorite,
      },
    );
  }

  /// Food Logging Events

  void logFoodEntry(String entryType, String mealType, double calories) {
    logEvent(
      AppConstants.eventFoodLog,
      parameters: {
        'entry_type': entryType, // 'manual' or 'recipe'
        'meal_type': mealType,
        'calories': calories,
      },
    );
  }

  void logFoodDelete(String logId, String mealType) {
    logEvent(
      'food_log_delete',
      parameters: {
        'log_id': logId,
        'meal_type': mealType,
      },
    );
  }

  /// Profile Events

  void logProfileUpdate(List<String> fieldsChanged) {
    logEvent(
      AppConstants.eventProfileUpdate,
      parameters: {
        'fields_changed': fieldsChanged.join(','),
      },
    );
  }

  void logGoalUpdate(String goalType, int targetCalories) {
    logEvent(
      AppConstants.eventGoalUpdate,
      parameters: {
        'goal_type': goalType,
        'target_calories': targetCalories,
      },
    );
  }

  /// Pantry Events

  void logPantryItemAdd(String category, bool hasExpiryDate) {
    logEvent(
      'pantry_item_add',
      parameters: {
        'category': category,
        'has_expiry_date': hasExpiryDate,
      },
    );
  }

  void logPantryItemDelete(String itemId, String category) {
    logEvent(
      'pantry_item_delete',
      parameters: {
        'item_id': itemId,
        'category': category,
      },
    );
  }

  void logPantrySearch(String searchTerm, int resultsCount) {
    logEvent(
      'pantry_search',
      parameters: {
        'search_term': searchTerm,
        'results_count': resultsCount,
      },
    );
  }

  /// Shopping List Events

  void logShoppingItemAdd(String category) {
    logEvent(
      'shopping_item_add',
      parameters: {'category': category},
    );
  }

  void logShoppingItemToggle(bool isCompleted) {
    logEvent(
      'shopping_item_toggle',
      parameters: {'is_completed': isCompleted},
    );
  }

  void logShoppingListComplete(int itemCount) {
    logEvent(
      'shopping_list_complete',
      parameters: {'item_count': itemCount},
    );
  }

  /// Meal Plan Events

  void logMealPlanView(String planId, DateTime startDate) {
    logEvent(
      'meal_plan_view',
      parameters: {
        'plan_id': planId,
        'start_date': startDate.toIso8601String(),
      },
    );
  }

  void logMealPlanGenerate(String goalType, List<String> restrictions) {
    logEvent(
      'meal_plan_generate',
      parameters: {
        'goal_type': goalType,
        'restrictions': restrictions.join(','),
      },
    );
  }

  /// AI Events

  void logAIFoodAnalysis(bool success, int? itemsDetected) {
    logEvent(
      'ai_food_analysis',
      parameters: {
        'success': success,
        if (itemsDetected != null) 'items_detected': itemsDetected,
      },
    );
  }

  void logAIMealPlanGeneration(bool success, String goalType) {
    logEvent(
      'ai_meal_plan_generation',
      parameters: {
        'success': success,
        'goal_type': goalType,
      },
    );
  }

  /// Progress Events

  void logProgressView(String period) {
    logEvent(
      'progress_view',
      parameters: {'period': period},
    );
  }

  void logWeightUpdate(double weight, double bmi) {
    logEvent(
      'weight_update',
      parameters: {
        'weight': weight,
        'bmi': bmi.toStringAsFixed(1),
      },
    );
  }

  /// Settings Events

  void logSettingChange(String settingName, dynamic value) {
    logEvent(
      'setting_change',
      parameters: {
        'setting_name': settingName,
        'value': value.toString(),
      },
    );
  }

  /// Error Events

  void logError(String errorType, String errorMessage, {bool isFatal = false}) {
    logEvent(
      'error_occurred',
      parameters: {
        'error_type': errorType,
        'error_message': errorMessage,
        'is_fatal': isFatal,
      },
    );
  }

  // ============== TIMING EVENTS ==============

  final Map<String, DateTime> _timers = {};

  /// Start timing an operation
  void startTimer(String eventName) {
    _timers[eventName] = DateTime.now();
  }

  /// End timing and log duration
  void endTimer(String eventName, {Map<String, dynamic>? parameters}) {
    final startTime = _timers[eventName];
    if (startTime == null) {
      debugPrint('⚠️ No timer started for: $eventName');
      return;
    }

    final duration = DateTime.now().difference(startTime);
    _timers.remove(eventName);

    logEvent(
      '${eventName}_duration',
      parameters: {
        'duration_ms': duration.inMilliseconds,
        ...?parameters,
      },
    );
  }

  // ============== DEBUGGING ==============

  void _logDebug(String message) {
    if (kDebugMode) {
      debugPrint('📊 Analytics: $message');
    }
  }

  /// Get current analytics state (for debugging)
  Map<String, dynamic> getAnalyticsState() {
    return {
      'initialized': _initialized,
      'enabled': AppConfig.enableAnalytics,
      'user_id': _userId,
      'user_properties': _userProperties,
      'active_timers': _timers.keys.toList(),
    };
  }

  /// Print analytics state
  void printState() {
    if (kDebugMode) {
      final state = getAnalyticsState();
      debugPrint('═══════════════════════════════════════');
      debugPrint('📊 Analytics State');
      debugPrint('═══════════════════════════════════════');
      state.forEach((key, value) {
        debugPrint('$key: $value');
      });
      debugPrint('═══════════════════════════════════════');
    }
  }
}
