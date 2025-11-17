import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RecipeModel extends Equatable {
  final String recipeId;
  final String title;
  final String description;
  final String imageUrl;
  final int prepTime; // in minutes
  final int cookTime; // in minutes
  final int totalTime; // in minutes
  final int servings;
  final String difficulty; // 'beginner', 'intermediate', 'advanced'
  final List<Ingredient> ingredients;
  final List<String> instructions;
  final NutritionInfo nutrition;
  final List<String> tags;
  final String category; // 'breakfast', 'lunch', 'dinner', 'snack', 'dessert'
  final String cuisine; // 'romanian', 'italian', 'asian', etc.
  final String createdBy;
  final DateTime createdAt;
  final bool isFavorite;

  const RecipeModel({
    required this.recipeId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.prepTime,
    required this.cookTime,
    required this.totalTime,
    required this.servings,
    required this.difficulty,
    required this.ingredients,
    required this.instructions,
    required this.nutrition,
    this.tags = const [],
    required this.category,
    required this.cuisine,
    required this.createdBy,
    required this.createdAt,
    this.isFavorite = false,
  });

  factory RecipeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecipeModel(
      recipeId: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      prepTime: data['prepTime'] ?? 0,
      cookTime: data['cookTime'] ?? 0,
      totalTime: data['totalTime'] ?? 0,
      servings: data['servings'] ?? 1,
      difficulty: data['difficulty'] ?? 'beginner',
      ingredients: (data['ingredients'] as List<dynamic>?)
              ?.map((i) => Ingredient.fromMap(i as Map<String, dynamic>))
              .toList() ??
          [],
      instructions: List<String>.from(data['instructions'] ?? []),
      nutrition: NutritionInfo.fromMap(data['nutrition'] ?? {}),
      tags: List<String>.from(data['tags'] ?? []),
      category: data['category'] ?? 'lunch',
      cuisine: data['cuisine'] ?? 'romanian',
      createdBy: data['createdBy'] ?? 'admin',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isFavorite: data['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'totalTime': totalTime,
      'servings': servings,
      'difficulty': difficulty,
      'ingredients': ingredients.map((i) => i.toMap()).toList(),
      'instructions': instructions,
      'nutrition': nutrition.toMap(),
      'tags': tags,
      'category': category,
      'cuisine': cuisine,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  RecipeModel copyWith({
    String? recipeId,
    String? title,
    String? description,
    String? imageUrl,
    int? prepTime,
    int? cookTime,
    int? totalTime,
    int? servings,
    String? difficulty,
    List<Ingredient>? ingredients,
    List<String>? instructions,
    NutritionInfo? nutrition,
    List<String>? tags,
    String? category,
    String? cuisine,
    String? createdBy,
    DateTime? createdAt,
    bool? isFavorite,
  }) {
    return RecipeModel(
      recipeId: recipeId ?? this.recipeId,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      prepTime: prepTime ?? this.prepTime,
      cookTime: cookTime ?? this.cookTime,
      totalTime: totalTime ?? this.totalTime,
      servings: servings ?? this.servings,
      difficulty: difficulty ?? this.difficulty,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      nutrition: nutrition ?? this.nutrition,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      cuisine: cuisine ?? this.cuisine,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        recipeId,
        title,
        description,
        imageUrl,
        prepTime,
        cookTime,
        totalTime,
        servings,
        difficulty,
        ingredients,
        instructions,
        nutrition,
        tags,
        category,
        cuisine,
        createdBy,
        createdAt,
        isFavorite,
      ];
}

class Ingredient extends Equatable {
  final String name;
  final double quantity;
  final String unit; // 'g', 'kg', 'ml', 'l', 'buc', 'linguriță', 'lingură', etc.

  const Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      unit: map['unit'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
    };
  }

  Ingredient copyWith({
    String? name,
    double? quantity,
    String? unit,
  }) {
    return Ingredient(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
    );
  }

  @override
  List<Object?> get props => [name, quantity, unit];
}

class NutritionInfo extends Equatable {
  final double calories;
  final double protein; // in grams
  final double carbs; // in grams
  final double fats; // in grams
  final int healthScore; // 0-100

  const NutritionInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    this.healthScore = 50,
  });

  factory NutritionInfo.fromMap(Map<String, dynamic> map) {
    return NutritionInfo(
      calories: (map['calories'] ?? 0).toDouble(),
      protein: (map['protein'] ?? 0).toDouble(),
      carbs: (map['carbs'] ?? 0).toDouble(),
      fats: (map['fats'] ?? 0).toDouble(),
      healthScore: map['healthScore'] ?? 50,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'healthScore': healthScore,
    };
  }

  NutritionInfo copyWith({
    double? calories,
    double? protein,
    double? carbs,
    double? fats,
    int? healthScore,
  }) {
    return NutritionInfo(
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      healthScore: healthScore ?? this.healthScore,
    );
  }

  /// Scale nutrition info by portion multiplier
  NutritionInfo scale(double multiplier) {
    return NutritionInfo(
      calories: calories * multiplier,
      protein: protein * multiplier,
      carbs: carbs * multiplier,
      fats: fats * multiplier,
      healthScore: healthScore,
    );
  }

  @override
  List<Object?> get props => [calories, protein, carbs, fats, healthScore];
}
