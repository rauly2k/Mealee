import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_log_model.dart';
import '../models/recipe_model.dart';
import '../services/firebase_service.dart';

class FoodLogRepository {
  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Create a food log
  Future<String> createFoodLog(FoodLogModel foodLog) async {
    try {
      final docRef = await _firebaseService.foodLogsCollection.add(
        foodLog.toFirestore(),
      );
      return docRef.id;
    } catch (e) {
      throw Exception('Eroare la salvarea alimentului: $e');
    }
  }

  /// Get food logs for a specific date
  Future<List<FoodLogModel>> getFoodLogsByDate(
    String userId,
    DateTime date,
  ) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await _firebaseService.foodLogsCollection
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThan: Timestamp.fromDate(endOfDay))
          .orderBy('date')
          .get();

      return snapshot.docs
          .map((doc) => FoodLogModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Eroare la încărcarea alimentelor: $e');
    }
  }

  /// Get food logs for a date range
  Future<List<FoodLogModel>> getFoodLogsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final snapshot = await _firebaseService.foodLogsCollection
          .where('userId', isEqualTo: userId)
          .where('date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('date')
          .get();

      return snapshot.docs
          .map((doc) => FoodLogModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Eroare la încărcarea alimentelor: $e');
    }
  }

  /// Stream food logs for today
  Stream<List<FoodLogModel>> streamTodayFoodLogs(String userId) {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _firebaseService.foodLogsCollection
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThan: Timestamp.fromDate(endOfDay))
        .orderBy('date')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FoodLogModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Update food log
  Future<void> updateFoodLog(FoodLogModel foodLog) async {
    try {
      await _firebaseService.foodLogsCollection
          .doc(foodLog.logId)
          .update(foodLog.toFirestore());
    } catch (e) {
      throw Exception('Eroare la actualizarea alimentului: $e');
    }
  }

  /// Delete food log
  Future<void> deleteFoodLog(String logId) async {
    try {
      await _firebaseService.foodLogsCollection.doc(logId).delete();
    } catch (e) {
      throw Exception('Eroare la ștergerea alimentului: $e');
    }
  }

  /// Calculate daily nutrition totals
  Future<NutritionInfo> getDailyNutritionTotals(
    String userId,
    DateTime date,
  ) async {
    try {
      final logs = await getFoodLogsByDate(userId, date);

      double totalCalories = 0;
      double totalProtein = 0;
      double totalCarbs = 0;
      double totalFats = 0;

      for (var log in logs) {
        totalCalories += log.nutrition.calories;
        totalProtein += log.nutrition.protein;
        totalCarbs += log.nutrition.carbs;
        totalFats += log.nutrition.fats;
      }

      return NutritionInfo(
        calories: totalCalories,
        protein: totalProtein,
        carbs: totalCarbs,
        fats: totalFats,
      );
    } catch (e) {
      throw Exception('Eroare la calcularea nutriției: $e');
    }
  }

  /// Get nutrition by meal type for a specific date
  Future<Map<String, NutritionInfo>> getNutritionByMealType(
    String userId,
    DateTime date,
  ) async {
    try {
      final logs = await getFoodLogsByDate(userId, date);

      final Map<String, NutritionInfo> nutritionByMeal = {
        'breakfast': const NutritionInfo(
            calories: 0, protein: 0, carbs: 0, fats: 0),
        'lunch':
            const NutritionInfo(calories: 0, protein: 0, carbs: 0, fats: 0),
        'dinner':
            const NutritionInfo(calories: 0, protein: 0, carbs: 0, fats: 0),
        'snacks':
            const NutritionInfo(calories: 0, protein: 0, carbs: 0, fats: 0),
      };

      for (var log in logs) {
        final current = nutritionByMeal[log.mealType]!;
        nutritionByMeal[log.mealType] = NutritionInfo(
          calories: current.calories + log.nutrition.calories,
          protein: current.protein + log.nutrition.protein,
          carbs: current.carbs + log.nutrition.carbs,
          fats: current.fats + log.nutrition.fats,
        );
      }

      return nutritionByMeal;
    } catch (e) {
      throw Exception('Eroare la calcularea nutriției: $e');
    }
  }
}
