import 'package:flutter/material.dart';
import '../../data/models/meal_plan_model.dart';
import '../../data/repositories/meal_plan_repository.dart';

class MealPlanProvider with ChangeNotifier {
  final MealPlanRepository _mealPlanRepository = MealPlanRepository();

  List<MealPlanModel> _mealPlans = [];
  MealPlanModel? _currentWeekPlan;
  bool _isLoading = false;
  String? _errorMessage;

  List<MealPlanModel> get mealPlans => _mealPlans;
  MealPlanModel? get currentWeekPlan => _currentWeekPlan;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load all meal plans for a user
  Future<void> loadMealPlans(String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _mealPlans = await _mealPlanRepository.getMealPlansByUserId(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load current week's meal plan
  Future<void> loadCurrentWeekPlan(String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentWeekPlan =
          await _mealPlanRepository.getCurrentWeekMealPlan(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load meal plan by ID
  Future<MealPlanModel?> loadMealPlanById(String planId) async {
    try {
      return await _mealPlanRepository.getMealPlanById(planId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Create a new meal plan
  Future<bool> createMealPlan(MealPlanModel mealPlan) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _mealPlanRepository.createMealPlan(mealPlan);

      // Reload meal plans
      await loadMealPlans(mealPlan.userId);

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

  /// Update meal plan
  Future<bool> updateMealPlan(MealPlanModel mealPlan) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _mealPlanRepository.updateMealPlan(mealPlan);

      // Reload meal plans
      await loadMealPlans(mealPlan.userId);

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

  /// Delete meal plan
  Future<bool> deleteMealPlan(String userId, String planId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _mealPlanRepository.deleteMealPlan(planId);

      // Reload meal plans
      await loadMealPlans(userId);

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

  /// Get meal plan for a specific date
  MealPlanModel? getMealPlanForDate(DateTime date) {
    for (final plan in _mealPlans) {
      if (date.isAfter(plan.startDate.subtract(const Duration(days: 1))) &&
          date.isBefore(plan.endDate.add(const Duration(days: 1)))) {
        return plan;
      }
    }
    return null;
  }

  /// Get day meal plan for a specific date
  DayMealPlan? getDayMealPlan(DateTime date) {
    final plan = getMealPlanForDate(date);
    if (plan == null) return null;

    // Find the day in the plan
    final daysDiff = date.difference(plan.startDate).inDays;
    if (daysDiff >= 0 && daysDiff < plan.days.length) {
      return plan.days[daysDiff];
    }

    return null;
  }

  /// Check if there's a meal plan for today
  bool hasMealPlanForToday() {
    return getDayMealPlan(DateTime.now()) != null;
  }

  /// Get total calories for a day
  double getDayCalories(DayMealPlan dayPlan) {
    double total = 0;
    for (final meal in dayPlan.meals) {
      total += meal.nutrition.calories;
    }
    return total;
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
