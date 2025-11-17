import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'recipe_model.dart';

class FoodLogModel extends Equatable {
  final String logId;
  final String userId;
  final DateTime date;
  final String mealType; // 'breakfast', 'lunch', 'dinner', 'snacks'
  final String source; // 'recipe', 'manual', 'photo'
  final String? recipeId;
  final String? recipeName;
  final ManualEntry? manualEntry;
  final String? photoUrl;
  final NutritionInfo nutrition;
  final double portionMultiplier; // For recipes: 1.0 = 1 serving, 0.5 = half serving
  final DateTime createdAt;

  const FoodLogModel({
    required this.logId,
    required this.userId,
    required this.date,
    required this.mealType,
    required this.source,
    this.recipeId,
    this.recipeName,
    this.manualEntry,
    this.photoUrl,
    required this.nutrition,
    this.portionMultiplier = 1.0,
    required this.createdAt,
  });

  factory FoodLogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FoodLogModel(
      logId: doc.id,
      userId: data['userId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      mealType: data['mealType'] ?? 'lunch',
      source: data['source'] ?? 'manual',
      recipeId: data['recipeId'],
      recipeName: data['recipeName'],
      manualEntry: data['manualEntry'] != null
          ? ManualEntry.fromMap(data['manualEntry'])
          : null,
      photoUrl: data['photoUrl'],
      nutrition: NutritionInfo.fromMap(data['nutrition'] ?? {}),
      portionMultiplier: (data['portionMultiplier'] ?? 1.0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'mealType': mealType,
      'source': source,
      'recipeId': recipeId,
      'recipeName': recipeName,
      'manualEntry': manualEntry?.toMap(),
      'photoUrl': photoUrl,
      'nutrition': nutrition.toMap(),
      'portionMultiplier': portionMultiplier,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  FoodLogModel copyWith({
    String? logId,
    String? userId,
    DateTime? date,
    String? mealType,
    String? source,
    String? recipeId,
    String? recipeName,
    ManualEntry? manualEntry,
    String? photoUrl,
    NutritionInfo? nutrition,
    double? portionMultiplier,
    DateTime? createdAt,
  }) {
    return FoodLogModel(
      logId: logId ?? this.logId,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      mealType: mealType ?? this.mealType,
      source: source ?? this.source,
      recipeId: recipeId ?? this.recipeId,
      recipeName: recipeName ?? this.recipeName,
      manualEntry: manualEntry ?? this.manualEntry,
      photoUrl: photoUrl ?? this.photoUrl,
      nutrition: nutrition ?? this.nutrition,
      portionMultiplier: portionMultiplier ?? this.portionMultiplier,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        logId,
        userId,
        date,
        mealType,
        source,
        recipeId,
        recipeName,
        manualEntry,
        photoUrl,
        nutrition,
        portionMultiplier,
        createdAt,
      ];
}

class ManualEntry extends Equatable {
  final String foodName;
  final double quantity;
  final String unit;
  final String? description;

  const ManualEntry({
    required this.foodName,
    required this.quantity,
    required this.unit,
    this.description,
  });

  factory ManualEntry.fromMap(Map<String, dynamic> map) {
    return ManualEntry(
      foodName: map['foodName'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      unit: map['unit'] ?? 'g',
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foodName': foodName,
      'quantity': quantity,
      'unit': unit,
      'description': description,
    };
  }

  ManualEntry copyWith({
    String? foodName,
    double? quantity,
    String? unit,
    String? description,
  }) {
    return ManualEntry(
      foodName: foodName ?? this.foodName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      description: description ?? this.description,
    );
  }

  // Backward compatibility: portionSize returns formatted quantity + unit
  String get portionSize => '${quantity.toStringAsFixed(quantity.truncateToDouble() == quantity ? 0 : 1)} $unit';

  @override
  List<Object?> get props => [foodName, quantity, unit, description];
}
