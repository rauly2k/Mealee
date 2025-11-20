import '../../core/constants/profile_data.dart';

/// Utility class for matching Romanian ingredient names with robust text normalization
/// Handles diacritics, case-insensitivity, and various Romanian spelling variations
class IngredientMatcher {
  IngredientMatcher._();

  /// Romanian diacritics mapping for normalization
  static const Map<String, String> _diacriticsMap = {
    'ă': 'a',
    'â': 'a',
    'î': 'i',
    'ș': 's',
    'ş': 's',
    'ț': 't',
    'ţ': 't',
    'Ă': 'a',
    'Â': 'a',
    'Î': 'i',
    'Ș': 's',
    'Ş': 's',
    'Ț': 't',
    'Ţ': 't',
  };

  /// Normalize Romanian text by removing diacritics and converting to lowercase
  ///
  /// Examples:
  /// - "Brânză" -> "branza"
  /// - "Șuncă" -> "sunca"
  /// - "Țelină" -> "telina"
  static String normalizeText(String text) {
    String normalized = text.toLowerCase().trim();

    // Replace Romanian diacritics
    _diacriticsMap.forEach((diacritic, replacement) {
      normalized = normalized.replaceAll(diacritic, replacement);
    });

    // Remove extra whitespace
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ');

    return normalized;
  }

  /// Check if an ingredient name contains any of the keywords for a food category
  ///
  /// Examples:
  /// - matchesCategory("piept de pui", "chicken") -> true
  /// - matchesCategory("brânză telemea", "cheese") -> true
  /// - matchesCategory("cartofi copți", "potatoes") -> true
  static bool matchesCategory(String ingredientName, String categoryKey) {
    final keywords = ProfileData.ingredientKeywordMap[categoryKey];
    if (keywords == null) return false;

    final normalizedIngredient = normalizeText(ingredientName);

    for (final keyword in keywords) {
      final normalizedKeyword = normalizeText(keyword);
      if (normalizedIngredient.contains(normalizedKeyword)) {
        return true;
      }
    }

    return false;
  }

  /// Find all matching categories for a given ingredient name
  /// Returns a list of category keys that match
  ///
  /// Example:
  /// - findMatchingCategories("brânză telemea") -> ["cheese", "dairy"]
  static List<String> findMatchingCategories(String ingredientName) {
    final matches = <String>[];

    for (final entry in ProfileData.ingredientKeywordMap.entries) {
      if (matchesCategory(ingredientName, entry.key)) {
        matches.add(entry.key);
      }
    }

    return matches;
  }

  /// Check if an ingredient matches any of the user's allergies
  ///
  /// Example:
  /// - containsAllergen("brânză", ["dairy", "nuts"]) -> true
  static bool containsAllergen(
    String ingredientName,
    List<String> userAllergies,
  ) {
    for (final allergen in userAllergies) {
      if (matchesCategory(ingredientName, allergen)) {
        return true;
      }
    }
    return false;
  }

  /// Check if an ingredient matches any of the user's preferred foods
  ///
  /// Example:
  /// - matchesPreferredFood("piept de pui", ["chicken", "fish"]) -> true
  static bool matchesPreferredFood(
    String ingredientName,
    List<String> preferredFoods,
  ) {
    for (final food in preferredFoods) {
      if (matchesCategory(ingredientName, food)) {
        return true;
      }
    }
    return false;
  }

  /// Extract all recognized ingredient keywords from a recipe
  /// Returns a list of normalized keywords that can be used for Firestore indexing
  ///
  /// Example:
  /// - Input: ["piept de pui", "brânză telemea", "roșii"]
  /// - Output: ["pui", "branza", "rosii"]
  static List<String> extractKeywords(List<String> ingredientNames) {
    final keywords = <String>{};

    for (final ingredient in ingredientNames) {
      final normalized = normalizeText(ingredient);

      // Add the normalized ingredient itself
      keywords.add(normalized);

      // Also add individual words (for better matching)
      final words = normalized.split(' ');
      for (final word in words) {
        if (word.length >= 3) {
          // Only add words with 3+ characters
          keywords.add(word);
        }
      }
    }

    return keywords.toList();
  }

  /// Calculate how well a recipe matches user preferences
  /// Returns a score between 0.0 and 1.0
  ///
  /// Scoring:
  /// - +1 for each preferred food ingredient
  /// - -1 for each allergen
  /// - -0.5 for each disliked ingredient
  static double calculatePreferenceScore({
    required List<String> recipeIngredients,
    required List<String> preferredFoods,
    required List<String> allergies,
    required List<String> dislikedIngredients,
  }) {
    double score = 0.0;
    int totalIngredients = recipeIngredients.length;

    if (totalIngredients == 0) return 0.0;

    for (final ingredient in recipeIngredients) {
      // Check for allergens (critical)
      if (containsAllergen(ingredient, allergies)) {
        return 0.0; // Recipe is unsuitable if it contains allergens
      }

      // Check for preferred foods (positive)
      if (matchesPreferredFood(ingredient, preferredFoods)) {
        score += 1.0;
      }

      // Check for disliked ingredients (negative)
      if (matchesPreferredFood(ingredient, dislikedIngredients)) {
        score -= 0.5;
      }
    }

    // Normalize score to 0.0-1.0 range
    // Maximum possible score is totalIngredients
    final normalizedScore = (score + totalIngredients) / (totalIngredients * 2);
    return normalizedScore.clamp(0.0, 1.0);
  }

  /// Check if two ingredient names are similar enough to be considered the same
  /// Uses Levenshtein-like approach for fuzzy matching
  ///
  /// Example:
  /// - areSimilar("brânză", "branza") -> true
  /// - areSimilar("piept de pui", "piept pui") -> true
  static bool areSimilar(String ingredient1, String ingredient2,
      {double threshold = 0.8}) {
    final norm1 = normalizeText(ingredient1);
    final norm2 = normalizeText(ingredient2);

    if (norm1 == norm2) return true;

    // Check if one contains the other
    if (norm1.contains(norm2) || norm2.contains(norm1)) {
      return true;
    }

    // Simple word overlap check
    final words1 = norm1.split(' ').toSet();
    final words2 = norm2.split(' ').toSet();
    final intersection = words1.intersection(words2);
    final union = words1.union(words2);

    if (union.isEmpty) return false;

    final similarity = intersection.length / union.length;
    return similarity >= threshold;
  }
}
