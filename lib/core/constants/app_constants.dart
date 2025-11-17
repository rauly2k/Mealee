library;

/// Application-wide constants
///
/// This file contains all magic numbers, durations, sizes, and other
/// constant values used throughout the application.

class AppConstants {
  AppConstants._();

  // ============== SPACING & SIZING ==============

  /// Standard padding values
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  /// Border radius values
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusCircular = 100.0;

  /// Icon sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;
  static const double iconSizeXXLarge = 64.0;

  /// Button heights
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightMedium = 48.0;
  static const double buttonHeightLarge = 56.0;

  /// Card elevation
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  /// Image sizes
  static const double imageThumbSize = 60.0;
  static const double imageSmallSize = 100.0;
  static const double imageMediumSize = 150.0;
  static const double imageLargeSize = 200.0;
  static const double imageHeroHeight = 250.0;

  /// Progress indicator sizes
  static const double progressSizeSmall = 20.0;
  static const double progressSizeMedium = 40.0;
  static const double progressSizeLarge = 60.0;

  // ============== DURATIONS ==============

  /// Animation durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  /// Snackbar & Toast durations
  static const Duration snackbarShort = Duration(seconds: 2);
  static const Duration snackbarNormal = Duration(seconds: 3);
  static const Duration snackbarLong = Duration(seconds: 5);

  /// Debounce durations
  static const Duration debounceSearch = Duration(milliseconds: 500);
  static const Duration debounceInput = Duration(milliseconds: 300);

  /// Timeout durations
  static const Duration timeoutShort = Duration(seconds: 10);
  static const Duration timeoutNormal = Duration(seconds: 30);
  static const Duration timeoutLong = Duration(seconds: 60);

  // ============== NUTRITION ==============

  /// Calorie limits
  static const int minDailyCalories = 1200;
  static const int maxDailyCalories = 5000;
  static const int defaultCalories = 2000;

  /// Macro percentage limits (as whole numbers, not decimals)
  static const int minProteinPercent = 10;
  static const int maxProteinPercent = 40;
  static const int defaultProteinPercent = 25;

  static const int minCarbsPercent = 20;
  static const int maxCarbsPercent = 65;
  static const int defaultCarbsPercent = 50;

  static const int minFatsPercent = 15;
  static const int maxFatsPercent = 40;
  static const int defaultFatsPercent = 25;

  /// Calories per gram
  static const int caloriesPerGramProtein = 4;
  static const int caloriesPerGramCarbs = 4;
  static const int caloriesPerGramFat = 9;

  /// Water intake (ml per kg of body weight)
  static const int waterPerKg = 30;
  static const int minWaterIntake = 1500; // ml
  static const int maxWaterIntake = 4000; // ml

  // ============== USER PROFILE ==============

  /// Age limits
  static const int minAge = 13;
  static const int maxAge = 120;
  static const int defaultAge = 25;

  /// Height limits (cm)
  static const double minHeight = 100.0;
  static const double maxHeight = 250.0;
  static const double defaultHeight = 170.0;

  /// Weight limits (kg)
  static const double minWeight = 30.0;
  static const double maxWeight = 300.0;
  static const double defaultWeight = 70.0;

  /// BMI ranges
  static const double bmiUnderweight = 18.5;
  static const double bmiNormal = 24.9;
  static const double bmiOverweight = 29.9;
  // Above 29.9 is obese

  // ============== VALIDATION ==============

  /// Password
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;

  /// Name
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  /// Text fields
  static const int maxTextFieldLength = 200;
  static const int maxDescriptionLength = 1000;

  /// Email
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  // ============== PANTRY ==============

  /// Expiry warning days
  static const int expiryWarningDays = 7;
  static const int expiryUrgentDays = 3;
  static const int expiryExpiredDays = 0;

  /// Quantity limits
  static const double minQuantity = 0.01;
  static const double maxQuantity = 9999.99;

  // ============== RECIPES ==============

  /// Recipe limits
  static const int minPrepTime = 1; // minutes
  static const int maxPrepTime = 480; // 8 hours
  static const int minCookTime = 1; // minutes
  static const int maxCookTime = 720; // 12 hours

  /// Serving limits
  static const int minServings = 1;
  static const int maxServings = 20;
  static const int defaultServings = 4;

  /// Ingredient limits
  static const int minIngredients = 1;
  static const int maxIngredients = 50;

  /// Instruction limits
  static const int minInstructions = 1;
  static const int maxInstructions = 30;

  // ============== PAGINATION ==============

  /// Items per page
  static const int recipesPerPage = 20;
  static const int foodLogsPerPage = 50;
  static const int pantryItemsPerPage = 30;
  static const int shoppingItemsPerPage = 50;

  /// Infinite scroll
  static const double scrollThreshold = 0.8; // 80% scrolled triggers load

  // ============== CACHING ==============

  /// Cache durations
  static const Duration recipeCacheDuration = Duration(hours: 24);
  static const Duration userCacheDuration = Duration(hours: 12);
  static const Duration imageCacheDuration = Duration(days: 7);

  /// Cache sizes
  static const int maxCachedRecipes = 100;
  static const int maxCachedImages = 50;
  static const int maxImageCacheSizeMB = 100;

  // ============== UPLOADS ==============

  /// Image upload limits
  static const int maxImageSizeMB = 5;
  static const int maxImageSizeBytes = maxImageSizeMB * 1024 * 1024;
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];

  /// Image quality
  static const int imageQualityHigh = 90;
  static const int imageQualityMedium = 75;
  static const int imageQualityLow = 60;

  // ============== DATE & TIME ==============

  /// Date formats
  static const String dateFormatShort = 'd MMM';
  static const String dateFormatMedium = 'd MMM yyyy';
  static const String dateFormatLong = 'd MMMM yyyy';
  static const String dateFormatFull = 'EEEE, d MMMM yyyy';
  static const String timeFormat24h = 'HH:mm';
  static const String dateTimeFormat = 'd MMM yyyy, HH:mm';

  /// Days
  static const int daysInWeek = 7;
  static const int daysInMonth = 30; // average
  static const int daysInYear = 365;

  // ============== MEAL TYPES ==============

  /// Meal type keys
  static const String mealBreakfast = 'breakfast';
  static const String mealLunch = 'lunch';
  static const String mealDinner = 'dinner';
  static const String mealSnacks = 'snacks';

  /// Meal type labels (Romanian)
  static const String mealBreakfastLabel = 'Micul dejun';
  static const String mealLunchLabel = 'Prânz';
  static const String mealDinnerLabel = 'Cină';
  static const String mealSnacksLabel = 'Gustări';

  // ============== ACTIVITY LEVELS ==============

  /// Activity level multipliers
  static const double activitySedentary = 1.2;
  static const double activityLight = 1.375;
  static const double activityModerate = 1.55;
  static const double activityActive = 1.725;
  static const double activityVeryActive = 1.9;

  // ============== GOALS ==============

  /// Weight change rate (kg per week)
  static const double weightLossRateSlow = 0.25;
  static const double weightLossRateNormal = 0.5;
  static const double weightLossRateFast = 0.75;
  static const double weightGainRateSlow = 0.25;
  static const double weightGainRateNormal = 0.5;
  static const double weightGainRateFast = 0.75;

  /// Calorie adjustment per kg
  static const int caloriesPerKg = 7700; // 1kg fat ≈ 7700 calories

  // ============== SHOPPING LIST ==============

  /// List limits
  static const int maxActiveListsPerUser = 5;
  static const int maxItemsPerList = 100;
  static const int maxCompletedListsToKeep = 20;

  // ============== UI BEHAVIOR ==============

  /// Refresh triggers
  static const double refreshTriggerDistance = 100.0;

  /// Scroll physics
  static const double minScrollVelocity = 100.0;

  /// Tab bar
  static const int maxTabs = 7;
  static const double tabHeight = 48.0;

  /// Bottom sheet
  static const double bottomSheetBorderRadius = 24.0;
  static const double bottomSheetHandleWidth = 40.0;
  static const double bottomSheetHandleHeight = 4.0;

  /// Dialogs
  static const double dialogMaxWidth = 400.0;
  static const double dialogBorderRadius = 16.0;

  // ============== RETRY & NETWORK ==============

  /// Retry configuration
  static const int maxRetryAttempts = 3;
  static const Duration retryInitialDelay = Duration(seconds: 1);
  static const Duration retryMaxDelay = Duration(seconds: 10);
  static const double retryBackoffMultiplier = 2.0;

  /// Network timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // ============== ANALYTICS ==============

  /// Event names (for future analytics implementation)
  static const String eventLogin = 'login';
  static const String eventRegister = 'register';
  static const String eventLogout = 'logout';
  static const String eventRecipeView = 'recipe_view';
  static const String eventRecipeLog = 'recipe_log';
  static const String eventFoodLog = 'food_log';
  static const String eventProfileUpdate = 'profile_update';
  static const String eventGoalUpdate = 'goal_update';

  // ============== CATEGORIES ==============

  /// Food categories
  static const List<String> foodCategories = [
    'Legume',
    'Fructe',
    'Lactate',
    'Carne',
    'Cereale',
    'Pâine & Cereale',
    'Condimente',
    'Băuturi',
    'Altele',
  ];

  /// Measurement units
  static const List<String> measurementUnits = [
    'g',
    'kg',
    'ml',
    'l',
    'buc',
    'lingură',
    'linguriță',
    'pachete',
    'conserve',
  ];

  // ============== SPECIAL VALUES ==============

  /// Minimum tap target size (accessibility)
  static const double minTapTargetSize = 48.0;

  /// Maximum line width for readability
  static const double maxReadableWidth = 600.0;

  /// Golden ratio
  static const double goldenRatio = 1.618;

  /// Z-index/Layer values
  static const int zIndexBackground = 0;
  static const int zIndexContent = 1;
  static const int zIndexOverlay = 2;
  static const int zIndexModal = 3;
  static const int zIndexSnackbar = 4;
  static const int zIndexTooltip = 5;
}
