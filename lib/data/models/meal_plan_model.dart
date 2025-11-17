import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'recipe_model.dart';

class MealPlanModel extends Equatable {
  final String mealPlanId;
  final String userId;
  final DateTime weekStartDate;
  final List<DayMealPlan> days;
  final NutritionInfo totalNutrition; // Daily average
  final String generatedBy; // 'AI' or 'manual'
  final DateTime createdAt;

  const MealPlanModel({
    required this.mealPlanId,
    required this.userId,
    required this.weekStartDate,
    required this.days,
    required this.totalNutrition,
    required this.generatedBy,
    required this.createdAt,
  });

  factory MealPlanModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MealPlanModel(
      mealPlanId: doc.id,
      userId: data['userId'] ?? '',
      weekStartDate: (data['weekStartDate'] as Timestamp).toDate(),
      days: (data['days'] as List<dynamic>?)
              ?.map((d) => DayMealPlan.fromMap(d as Map<String, dynamic>))
              .toList() ??
          [],
      totalNutrition: NutritionInfo.fromMap(data['totalNutrition'] ?? {}),
      generatedBy: data['generatedBy'] ?? 'manual',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'weekStartDate': Timestamp.fromDate(weekStartDate),
      'days': days.map((d) => d.toMap()).toList(),
      'totalNutrition': totalNutrition.toMap(),
      'generatedBy': generatedBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  MealPlanModel copyWith({
    String? mealPlanId,
    String? userId,
    DateTime? weekStartDate,
    List<DayMealPlan>? days,
    NutritionInfo? totalNutrition,
    String? generatedBy,
    DateTime? createdAt,
  }) {
    return MealPlanModel(
      mealPlanId: mealPlanId ?? this.mealPlanId,
      userId: userId ?? this.userId,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      days: days ?? this.days,
      totalNutrition: totalNutrition ?? this.totalNutrition,
      generatedBy: generatedBy ?? this.generatedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        mealPlanId,
        userId,
        weekStartDate,
        days,
        totalNutrition,
        generatedBy,
        createdAt,
      ];
}

class DayMealPlan extends Equatable {
  final int dayOfWeek; // 1-7 (Monday-Sunday)
  final DateTime date;
  final MealInfo? breakfast;
  final MealInfo? lunch;
  final MealInfo? dinner;
  final List<MealInfo> snacks;

  const DayMealPlan({
    required this.dayOfWeek,
    required this.date,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.snacks = const [],
  });

  factory DayMealPlan.fromMap(Map<String, dynamic> map) {
    return DayMealPlan(
      dayOfWeek: map['dayOfWeek'] ?? 1,
      date: (map['date'] as Timestamp).toDate(),
      breakfast:
          map['breakfast'] != null ? MealInfo.fromMap(map['breakfast']) : null,
      lunch: map['lunch'] != null ? MealInfo.fromMap(map['lunch']) : null,
      dinner: map['dinner'] != null ? MealInfo.fromMap(map['dinner']) : null,
      snacks: (map['snacks'] as List<dynamic>?)
              ?.map((s) => MealInfo.fromMap(s as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dayOfWeek': dayOfWeek,
      'date': Timestamp.fromDate(date),
      'breakfast': breakfast?.toMap(),
      'lunch': lunch?.toMap(),
      'dinner': dinner?.toMap(),
      'snacks': snacks.map((s) => s.toMap()).toList(),
    };
  }

  DayMealPlan copyWith({
    int? dayOfWeek,
    DateTime? date,
    MealInfo? breakfast,
    MealInfo? lunch,
    MealInfo? dinner,
    List<MealInfo>? snacks,
  }) {
    return DayMealPlan(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      date: date ?? this.date,
      breakfast: breakfast ?? this.breakfast,
      lunch: lunch ?? this.lunch,
      dinner: dinner ?? this.dinner,
      snacks: snacks ?? this.snacks,
    );
  }

  /// Get total nutrition for the day
  NutritionInfo get totalNutrition {
    double calories = 0;
    double protein = 0;
    double carbs = 0;
    double fats = 0;

    void addMeal(MealInfo? meal) {
      if (meal != null) {
        calories += meal.nutrition.calories;
        protein += meal.nutrition.protein;
        carbs += meal.nutrition.carbs;
        fats += meal.nutrition.fats;
      }
    }

    addMeal(breakfast);
    addMeal(lunch);
    addMeal(dinner);
    for (var snack in snacks) {
      addMeal(snack);
    }

    return NutritionInfo(
      calories: calories,
      protein: protein,
      carbs: carbs,
      fats: fats,
    );
  }

  @override
  List<Object?> get props => [dayOfWeek, date, breakfast, lunch, dinner, snacks];
}

class MealInfo extends Equatable {
  final String recipeId;
  final String recipeName;
  final String recipeImageUrl;
  final NutritionInfo nutrition;
  final double portionMultiplier;

  const MealInfo({
    required this.recipeId,
    required this.recipeName,
    required this.recipeImageUrl,
    required this.nutrition,
    this.portionMultiplier = 1.0,
  });

  factory MealInfo.fromMap(Map<String, dynamic> map) {
    return MealInfo(
      recipeId: map['recipeId'] ?? '',
      recipeName: map['recipeName'] ?? '',
      recipeImageUrl: map['recipeImageUrl'] ?? '',
      nutrition: NutritionInfo.fromMap(map['nutrition'] ?? {}),
      portionMultiplier: (map['portionMultiplier'] ?? 1.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recipeId': recipeId,
      'recipeName': recipeName,
      'recipeImageUrl': recipeImageUrl,
      'nutrition': nutrition.toMap(),
      'portionMultiplier': portionMultiplier,
    };
  }

  MealInfo copyWith({
    String? recipeId,
    String? recipeName,
    String? recipeImageUrl,
    NutritionInfo? nutrition,
    double? portionMultiplier,
  }) {
    return MealInfo(
      recipeId: recipeId ?? this.recipeId,
      recipeName: recipeName ?? this.recipeName,
      recipeImageUrl: recipeImageUrl ?? this.recipeImageUrl,
      nutrition: nutrition ?? this.nutrition,
      portionMultiplier: portionMultiplier ?? this.portionMultiplier,
    );
  }

  @override
  List<Object?> get props => [
        recipeId,
        recipeName,
        recipeImageUrl,
        nutrition,
        portionMultiplier,
      ];
}
