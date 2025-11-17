import 'package:flutter/material.dart';
import '../../data/models/food_log_model.dart';
import '../../data/models/recipe_model.dart';
import '../../data/repositories/food_log_repository.dart';

class FoodLogProvider with ChangeNotifier {
  final FoodLogRepository _foodLogRepository = FoodLogRepository();

  List<FoodLogModel> _todayLogs = [];
  NutritionInfo _todayNutrition = const NutritionInfo(
    calories: 0,
    protein: 0,
    carbs: 0,
    fats: 0,
  );
  Map<String, NutritionInfo> _nutritionByMeal = {};
  bool _isLoading = false;
  String? _errorMessage;

  List<FoodLogModel> get todayLogs => _todayLogs;
  NutritionInfo get todayNutrition => _todayNutrition;
  Map<String, NutritionInfo> get nutritionByMeal => _nutritionByMeal;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load today's food logs
  Future<void> loadTodayLogs(String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final today = DateTime.now();
      _todayLogs = await _foodLogRepository.getFoodLogsByDate(userId, today);
      _todayNutrition =
          await _foodLogRepository.getDailyNutritionTotals(userId, today);
      _nutritionByMeal =
          await _foodLogRepository.getNutritionByMealType(userId, today);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add food log
  Future<bool> addFoodLog(FoodLogModel foodLog) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _foodLogRepository.createFoodLog(foodLog);

      // Reload today's logs
      await loadTodayLogs(foodLog.userId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Add recipe as food log
  Future<bool> addRecipeLog({
    required String userId,
    required String recipeId,
    required String recipeName,
    required String mealType,
    required NutritionInfo nutrition,
    double portionMultiplier = 1.0,
  }) async {
    final foodLog = FoodLogModel(
      logId: '',
      userId: userId,
      date: DateTime.now(),
      mealType: mealType,
      source: 'recipe',
      recipeId: recipeId,
      recipeName: recipeName,
      nutrition: nutrition.scale(portionMultiplier),
      portionMultiplier: portionMultiplier,
      createdAt: DateTime.now(),
    );

    return await addFoodLog(foodLog);
  }

  /// Add manual food log
  Future<bool> addManualLog({
    required String userId,
    required String mealType,
    required ManualEntry manualEntry,
    required NutritionInfo nutrition,
  }) async {
    final foodLog = FoodLogModel(
      logId: '',
      userId: userId,
      date: DateTime.now(),
      mealType: mealType,
      source: 'manual',
      manualEntry: manualEntry,
      nutrition: nutrition,
      createdAt: DateTime.now(),
    );

    return await addFoodLog(foodLog);
  }

  /// Delete food log
  Future<bool> deleteFoodLog(String userId, String logId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _foodLogRepository.deleteFoodLog(logId);

      // Reload today's logs
      await loadTodayLogs(userId);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get logs by meal type
  List<FoodLogModel> getLogsByMealType(String mealType) {
    return _todayLogs.where((log) => log.mealType == mealType).toList();
  }

  /// Calculate remaining calories
  double getRemainingCalories(double targetCalories) {
    return targetCalories - _todayNutrition.calories;
  }

  /// Calculate remaining protein
  double getRemainingProtein(double targetProtein) {
    return targetProtein - _todayNutrition.protein;
  }

  /// Calculate remaining carbs
  double getRemainingCarbs(double targetCarbs) {
    return targetCarbs - _todayNutrition.carbs;
  }

  /// Calculate remaining fats
  double getRemainingFats(double targetFats) {
    return targetFats - _todayNutrition.fats;
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
