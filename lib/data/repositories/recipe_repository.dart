import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';
import '../services/firebase_service.dart';

class RecipeRepository {
  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Get all recipes with optional filtering
  Future<List<RecipeModel>> getRecipes({
    String? category,
    String? cuisine,
    String? difficulty,
    List<String>? tags,
    int limit = 50,
  }) async {
    try {
      Query query = _firebaseService.recipesCollection;

      // Apply filters
      if (category != null) {
        query = query.where('category', isEqualTo: category);
      }
      if (cuisine != null) {
        query = query.where('cuisine', isEqualTo: cuisine);
      }
      if (difficulty != null) {
        query = query.where('difficulty', isEqualTo: difficulty);
      }
      if (tags != null && tags.isNotEmpty) {
        query = query.where('tags', arrayContainsAny: tags);
      }

      query = query.limit(limit);

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => RecipeModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Eroare la încărcarea rețetelor: $e');
    }
  }

  /// Get recipe by ID
  Future<RecipeModel?> getRecipeById(String recipeId) async {
    try {
      final doc =
          await _firebaseService.recipesCollection.doc(recipeId).get();
      if (doc.exists) {
        return RecipeModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Eroare la încărcarea rețetei: $e');
    }
  }

  /// Search recipes by title or ingredients
  Future<List<RecipeModel>> searchRecipes(String searchTerm) async {
    try {
      // Firebase doesn't support full-text search natively
      // This is a basic implementation - for production, consider using Algolia or ElasticSearch
      final snapshot = await _firebaseService.recipesCollection.get();

      final recipes = snapshot.docs
          .map((doc) => RecipeModel.fromFirestore(doc))
          .where((recipe) {
        final searchLower = searchTerm.toLowerCase();
        final titleMatch = recipe.title.toLowerCase().contains(searchLower);
        final ingredientMatch = recipe.ingredients.any(
          (ingredient) => ingredient.name.toLowerCase().contains(searchLower),
        );
        return titleMatch || ingredientMatch;
      }).toList();

      return recipes;
    } catch (e) {
      throw Exception('Eroare la căutarea rețetelor: $e');
    }
  }

  /// Get recipes by category
  Future<List<RecipeModel>> getRecipesByCategory(String category) async {
    return getRecipes(category: category);
  }

  /// Get popular recipes (based on some criteria)
  Future<List<RecipeModel>> getPopularRecipes({int limit = 10}) async {
    try {
      final snapshot = await _firebaseService.recipesCollection
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => RecipeModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Eroare la încărcarea rețetelor populare: $e');
    }
  }

  /// Stream recipes
  Stream<List<RecipeModel>> streamRecipes({int limit = 50}) {
    return _firebaseService.recipesCollection
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => RecipeModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Find recipes by available ingredients
  Future<List<RecipeModel>> findRecipesByIngredients(
    List<String> availableIngredients,
  ) async {
    try {
      final snapshot = await _firebaseService.recipesCollection.get();

      final recipes = snapshot.docs
          .map((doc) => RecipeModel.fromFirestore(doc))
          .where((recipe) {
        // Check how many ingredients are available
        final requiredIngredients =
            recipe.ingredients.map((i) => i.name.toLowerCase()).toList();
        final available =
            availableIngredients.map((i) => i.toLowerCase()).toList();

        // Count matching ingredients
        int matchCount = 0;
        for (var ingredient in requiredIngredients) {
          if (available.any((a) => ingredient.contains(a))) {
            matchCount++;
          }
        }

        // Recipe must have at least 50% of ingredients available
        final matchPercentage = matchCount / requiredIngredients.length;
        return matchPercentage >= 0.5;
      }).toList();

      // Sort by match percentage (descending)
      recipes.sort((a, b) {
        final aMatch = _calculateMatchPercentage(a, availableIngredients);
        final bMatch = _calculateMatchPercentage(b, availableIngredients);
        return bMatch.compareTo(aMatch);
      });

      return recipes;
    } catch (e) {
      throw Exception('Eroare la căutarea rețetelor: $e');
    }
  }

  double _calculateMatchPercentage(
    RecipeModel recipe,
    List<String> available,
  ) {
    final required = recipe.ingredients.map((i) => i.name.toLowerCase()).toList();
    final availableLower = available.map((i) => i.toLowerCase()).toList();

    int matchCount = 0;
    for (var ingredient in required) {
      if (availableLower.any((a) => ingredient.contains(a))) {
        matchCount++;
      }
    }

    return matchCount / required.length;
  }
}
