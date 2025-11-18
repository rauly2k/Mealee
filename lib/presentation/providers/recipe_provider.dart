import 'package:flutter/material.dart';
import '../../data/models/recipe_model.dart';
import '../../data/repositories/recipe_repository.dart';

class RecipeProvider with ChangeNotifier {
  final RecipeRepository _recipeRepository = RecipeRepository();

  List<RecipeModel> _recipes = [];
  final List<RecipeModel> _favoriteRecipes = [];
  RecipeModel? _selectedRecipe;
  bool _isLoading = false;
  String? _errorMessage;

  List<RecipeModel> get recipes => _recipes;
  List<RecipeModel> get favoriteRecipes => _favoriteRecipes;
  RecipeModel? get selectedRecipe => _selectedRecipe;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load all recipes
  Future<void> loadRecipes({
    String? category,
    String? cuisine,
    String? difficulty,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _recipes = await _recipeRepository.getRecipes(
        category: category,
        cuisine: cuisine,
        difficulty: difficulty,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load recipe by ID
  Future<void> loadRecipeById(String recipeId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _selectedRecipe = await _recipeRepository.getRecipeById(recipeId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Search recipes
  Future<void> searchRecipes(String searchTerm) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _recipes = await _recipeRepository.searchRecipes(searchTerm);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Search recipes and return results without updating state (for quick search)
  Future<List<RecipeModel>> searchRecipesByQuery(String searchTerm) async {
    try {
      return await _recipeRepository.searchRecipes(searchTerm);
    } catch (e) {
      throw Exception('Eroare la căutarea rețetelor: $e');
    }
  }

  /// Load popular recipes
  Future<void> loadPopularRecipes() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _recipes = await _recipeRepository.getPopularRecipes();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Find recipes by available ingredients
  Future<void> findRecipesByIngredients(List<String> ingredients) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _recipes =
          await _recipeRepository.findRecipesByIngredients(ingredients);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle favorite status (client-side only for now)
  void toggleFavorite(String recipeId) {
    final recipeIndex = _recipes.indexWhere((r) => r.recipeId == recipeId);
    if (recipeIndex != -1) {
      final recipe = _recipes[recipeIndex];
      _recipes[recipeIndex] = recipe.copyWith(isFavorite: !recipe.isFavorite);

      // Update favorites list
      if (_recipes[recipeIndex].isFavorite) {
        _favoriteRecipes.add(_recipes[recipeIndex]);
      } else {
        _favoriteRecipes.removeWhere((r) => r.recipeId == recipeId);
      }

      notifyListeners();
    }
  }

  /// Set selected recipe
  void setSelectedRecipe(RecipeModel recipe) {
    _selectedRecipe = recipe;
    notifyListeners();
  }

  /// Clear selected recipe
  void clearSelectedRecipe() {
    _selectedRecipe = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
