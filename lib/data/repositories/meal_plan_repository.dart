import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal_plan_model.dart';
import '../services/firebase_service.dart';

class MealPlanRepository {
  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Create a meal plan
  Future<String> createMealPlan(MealPlanModel mealPlan) async {
    try {
      final docRef = await _firebaseService.mealPlansCollection.add(
        mealPlan.toFirestore(),
      );
      return docRef.id;
    } catch (e) {
      throw Exception('Eroare la salvarea planului de mese: $e');
    }
  }

  /// Get meal plan by ID
  Future<MealPlanModel?> getMealPlanById(String mealPlanId) async {
    try {
      final doc =
          await _firebaseService.mealPlansCollection.doc(mealPlanId).get();
      if (doc.exists) {
        return MealPlanModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Eroare la încărcarea planului de mese: $e');
    }
  }

  /// Get all meal plans for a user
  Future<List<MealPlanModel>> getUserMealPlans(String userId) async {
    try {
      final snapshot = await _firebaseService.mealPlansCollection
          .where('userId', isEqualTo: userId)
          .orderBy('weekStartDate', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MealPlanModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Eroare la încărcarea planurilor de mese: $e');
    }
  }

  /// Get current week's meal plan
  Future<MealPlanModel?> getCurrentWeekMealPlan(String userId) async {
    try {
      final now = DateTime.now();
      // Get Monday of current week
      final monday = now.subtract(Duration(days: now.weekday - 1));
      final startOfWeek = DateTime(monday.year, monday.month, monday.day);

      final snapshot = await _firebaseService.mealPlansCollection
          .where('userId', isEqualTo: userId)
          .where('weekStartDate',
              isEqualTo: Timestamp.fromDate(startOfWeek))
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return MealPlanModel.fromFirestore(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      throw Exception('Eroare la încărcarea planului săptămânal: $e');
    }
  }

  /// Stream current week's meal plan
  Stream<MealPlanModel?> streamCurrentWeekMealPlan(String userId) {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeek = DateTime(monday.year, monday.month, monday.day);

    return _firebaseService.mealPlansCollection
        .where('userId', isEqualTo: userId)
        .where('weekStartDate', isEqualTo: Timestamp.fromDate(startOfWeek))
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return MealPlanModel.fromFirestore(snapshot.docs.first);
      }
      return null;
    });
  }

  /// Update meal plan
  Future<void> updateMealPlan(MealPlanModel mealPlan) async {
    try {
      await _firebaseService.mealPlansCollection
          .doc(mealPlan.mealPlanId)
          .update(mealPlan.toFirestore());
    } catch (e) {
      throw Exception('Eroare la actualizarea planului de mese: $e');
    }
  }

  /// Delete meal plan
  Future<void> deleteMealPlan(String mealPlanId) async {
    try {
      await _firebaseService.mealPlansCollection.doc(mealPlanId).delete();
    } catch (e) {
      throw Exception('Eroare la ștergerea planului de mese: $e');
    }
  }

  /// Get meal plan for specific week
  Future<MealPlanModel?> getMealPlanForWeek(
    String userId,
    DateTime weekStartDate,
  ) async {
    try {
      final startOfWeek = DateTime(
        weekStartDate.year,
        weekStartDate.month,
        weekStartDate.day,
      );

      final snapshot = await _firebaseService.mealPlansCollection
          .where('userId', isEqualTo: userId)
          .where('weekStartDate',
              isEqualTo: Timestamp.fromDate(startOfWeek))
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return MealPlanModel.fromFirestore(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      throw Exception('Eroare la încărcarea planului de mese: $e');
    }
  }
}
