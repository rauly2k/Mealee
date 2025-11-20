import '../../data/models/recipe_model.dart';
import 'ingredient_matcher.dart';

/// Rule-based diet type detection for recipes
/// Uses configurable thresholds and ingredient analysis to determine diet compatibility
class DietRules {
  DietRules._();

  // ============== MACRO THRESHOLDS ==============

  /// Keto diet thresholds (per serving)
  static const double _ketoMaxCarbs = 15.0; // grams
  static const double _ketoMinFats = 15.0; // grams

  /// Low-carb diet thresholds (per serving)
  static const double _lowCarbMaxCarbs = 30.0; // grams

  /// High-protein diet thresholds (per serving)
  static const double _highProteinMinProtein = 25.0; // grams
  static const double _highProteinMinProteinRatio = 0.30; // 30% of calories

  /// Paleo diet - no specific macro thresholds, ingredient-based

  /// Mediterranean diet - flexible macros, ingredient-focused

  // ============== EXCLUDED INGREDIENTS ==============

  /// Ingredients that exclude a recipe from vegetarian diet
  static const List<String> _meatIngredients = [
    'chicken',
    'pork',
    'beef',
    'fish',
  ];

  /// Ingredients that exclude a recipe from vegan diet (includes vegetarian exclusions)
  static const List<String> _animalProductIngredients = [
    'chicken',
    'pork',
    'beef',
    'fish',
    'shellfish',
    'eggs',
    'cheese',
    'yogurt',
    'milk',
    'butter',
  ];

  /// Ingredients that exclude a recipe from paleo diet
  static const List<String> _nonPaleoIngredients = [
    'beans',
    'bread',
    'pasta',
    'rice',
    'cheese',
    'yogurt',
    'milk',
    'wheat',
  ];

  /// Ingredients that exclude a recipe from pescatarian diet
  static const List<String> _pescatarianExcludedMeats = [
    'chicken',
    'pork',
    'beef',
  ];

  // ============== DIET DETECTION METHODS ==============

  /// Detect all applicable diet flags for a recipe
  /// Returns a list of diet type keys (e.g., ['keto', 'low_carb', 'high_protein'])
  static List<String> detectDietFlags(RecipeModel recipe) {
    final flags = <String>[];

    // Always add 'classic' - it accepts everything
    flags.add('classic');

    // Check macro-based diets
    if (isKeto(recipe)) flags.add('keto');
    if (isLowCarb(recipe)) flags.add('low_carb');
    if (isHighProtein(recipe)) flags.add('high_protein');

    // Check ingredient-based diets
    if (isVegan(recipe)) {
      flags.add('vegan');
      flags.add('vegetarian'); // Vegan is also vegetarian
    } else if (isVegetarian(recipe)) {
      flags.add('vegetarian');
    }

    if (isPescatarian(recipe)) flags.add('pescatarian');
    if (isPaleo(recipe)) flags.add('paleo');

    // Mediterranean is flexible - check for olive oil, vegetables, fish
    if (isMediterranean(recipe)) flags.add('mediterranean');

    return flags;
  }

  /// Check if recipe is Keto-compatible
  /// Criteria: Low carbs (<15g per serving) AND high fats (>15g per serving)
  static bool isKeto(RecipeModel recipe) {
    final carbsPerServing = recipe.nutrition.carbs / recipe.servings;
    final fatsPerServing = recipe.nutrition.fats / recipe.servings;

    return carbsPerServing <= _ketoMaxCarbs && fatsPerServing >= _ketoMinFats;
  }

  /// Check if recipe is Low-Carb compatible
  /// Criteria: Carbs < 30g per serving
  static bool isLowCarb(RecipeModel recipe) {
    final carbsPerServing = recipe.nutrition.carbs / recipe.servings;
    return carbsPerServing <= _lowCarbMaxCarbs;
  }

  /// Check if recipe is High-Protein compatible
  /// Criteria: Protein >= 25g per serving OR protein provides >= 30% of calories
  static bool isHighProtein(RecipeModel recipe) {
    final proteinPerServing = recipe.nutrition.protein / recipe.servings;
    final caloriesPerServing = recipe.nutrition.calories / recipe.servings;

    // Check absolute protein amount
    if (proteinPerServing >= _highProteinMinProtein) return true;

    // Check protein ratio (protein calories / total calories)
    // 1g protein = 4 calories
    final proteinCalories = proteinPerServing * 4;
    final proteinRatio = proteinCalories / caloriesPerServing;

    return proteinRatio >= _highProteinMinProteinRatio;
  }

  /// Check if recipe is Vegetarian
  /// Criteria: No meat or fish ingredients
  static bool isVegetarian(RecipeModel recipe) {
    return !_containsAnyCategory(
      recipe.ingredients.map((i) => i.name).toList(),
      _meatIngredients,
    );
  }

  /// Check if recipe is Vegan
  /// Criteria: No animal products at all
  static bool isVegan(RecipeModel recipe) {
    return !_containsAnyCategory(
      recipe.ingredients.map((i) => i.name).toList(),
      _animalProductIngredients,
    );
  }

  /// Check if recipe is Pescatarian
  /// Criteria: No meat (chicken, pork, beef), but fish/eggs/dairy allowed
  static bool isPescatarian(RecipeModel recipe) {
    return !_containsAnyCategory(
      recipe.ingredients.map((i) => i.name).toList(),
      _pescatarianExcludedMeats,
    );
  }

  /// Check if recipe is Paleo
  /// Criteria: No grains, legumes, or dairy
  static bool isPaleo(RecipeModel recipe) {
    return !_containsAnyCategory(
      recipe.ingredients.map((i) => i.name).toList(),
      _nonPaleoIngredients,
    );
  }

  /// Check if recipe is Mediterranean-style
  /// Criteria: Contains olive oil, vegetables, or fish (flexible)
  static bool isMediterranean(RecipeModel recipe) {
    final ingredientNames = recipe.ingredients.map((i) => i.name).toList();

    // Check for Mediterranean-friendly ingredients
    final hasOliveOil = _containsAnyCategory(ingredientNames, ['oil']);
    final hasVegetables = _containsAnyCategory(
      ingredientNames,
      ['tomatoes', 'eggplant', 'cabbage', 'leafy_greens', 'root_veg'],
    );
    final hasFish = _containsAnyCategory(ingredientNames, ['fish']);

    // Recipe is Mediterranean if it has at least 2 of these characteristics
    int score = 0;
    if (hasOliveOil) score++;
    if (hasVegetables) score++;
    if (hasFish) score++;

    return score >= 2;
  }

  // ============== HELPER METHODS ==============

  /// Check if ingredient list contains any ingredients from the specified categories
  static bool _containsAnyCategory(
    List<String> ingredientNames,
    List<String> categories,
  ) {
    for (final ingredient in ingredientNames) {
      for (final category in categories) {
        if (IngredientMatcher.matchesCategory(ingredient, category)) {
          return true;
        }
      }
    }
    return false;
  }

  /// Get human-readable explanation of why a recipe matches a diet type
  static String getMatchExplanation(RecipeModel recipe, String dietType) {
    switch (dietType) {
      case 'keto':
        final carbs = (recipe.nutrition.carbs / recipe.servings).toStringAsFixed(1);
        final fats = (recipe.nutrition.fats / recipe.servings).toStringAsFixed(1);
        return 'Keto: ${carbs}g carbohidrați, ${fats}g grăsimi per porție';

      case 'low_carb':
        final carbs = (recipe.nutrition.carbs / recipe.servings).toStringAsFixed(1);
        return 'Low-Carb: ${carbs}g carbohidrați per porție';

      case 'high_protein':
        final protein = (recipe.nutrition.protein / recipe.servings).toStringAsFixed(1);
        return 'Hiperproteică: ${protein}g proteine per porție';

      case 'vegan':
        return 'Vegan: Fără produse de origine animală';

      case 'vegetarian':
        return 'Vegetarian: Fără carne sau pește';

      case 'pescatarian':
        return 'Pescatarian: Fără carne (pește permis)';

      case 'paleo':
        return 'Paleo: Fără cereale, leguminoase sau lactate';

      case 'mediterranean':
        return 'Mediteraneană: Bogată în legume și ulei de măsline';

      case 'classic':
        return 'Clasic: Fără restricții';

      default:
        return '';
    }
  }

  /// Calculate confidence score for a diet flag (0.0 - 1.0)
  /// Higher confidence means the recipe strongly matches the diet
  static double getDietConfidence(RecipeModel recipe, String dietType) {
    switch (dietType) {
      case 'keto':
        final carbsPerServing = recipe.nutrition.carbs / recipe.servings;
        final fatsPerServing = recipe.nutrition.fats / recipe.servings;

        // Perfect keto: very low carbs, high fats
        if (carbsPerServing <= 5.0 && fatsPerServing >= 25.0) return 1.0;
        if (carbsPerServing <= 10.0 && fatsPerServing >= 20.0) return 0.9;
        if (isKeto(recipe)) return 0.7;
        return 0.0;

      case 'high_protein':
        final proteinPerServing = recipe.nutrition.protein / recipe.servings;

        // Very high protein
        if (proteinPerServing >= 40.0) return 1.0;
        if (proteinPerServing >= 30.0) return 0.9;
        if (isHighProtein(recipe)) return 0.7;
        return 0.0;

      case 'vegan':
      case 'vegetarian':
        // Ingredient-based diets have binary confidence (either they are or aren't)
        return 1.0;

      default:
        return 0.8; // Default confidence for other diets
    }
  }
}
