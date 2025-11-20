import '../models/user_model.dart';
import '../models/recipe_model.dart';
import '../models/food_log_model.dart';
import '../../core/constants/profile_data.dart';

/// Service for building rich AI context from user data
/// Prepares structured prompts for Gemini API with comprehensive user information
class AIContextService {
  AIContextService._();

  /// Build a comprehensive user context string for AI prompts
  ///
  /// This includes:
  /// - Demographics (age, gender, activity level)
  /// - Health goals (weight loss, muscle gain, etc.)
  /// - Dietary preferences and restrictions
  /// - Nutritional targets (calories, macros)
  /// - Food preferences and dislikes
  /// - Recent meal history (optional)
  static String buildUserContext({
    required UserModel user,
    List<FoodLogModel>? recentMeals,
    bool includeNutritionalTargets = true,
    bool includeFoodPreferences = true,
    bool includeRecentMeals = true,
  }) {
    final buffer = StringBuffer();

    // === User Profile ===
    buffer.writeln('PROFILUL UTILIZATORULUI:');
    buffer.writeln('---');

    if (user.profile != null) {
      final profile = user.profile!;
      buffer.writeln('Vârstă: ${profile.age} ani');
      buffer.writeln('Gen: ${_getGenderLabel(profile.gender)}');
      buffer.writeln('Înălțime: ${profile.height.toStringAsFixed(0)} cm');
      buffer.writeln('Greutate: ${profile.weight.toStringAsFixed(1)} kg');
      buffer.writeln(
        'Nivel activitate: ${_getActivityLevelLabel(profile.activityLevel)}',
      );
      buffer.writeln();
    }

    // === Health Goals ===
    if (user.goals != null) {
      final goals = user.goals!;
      buffer.writeln('OBIECTIVE DE SĂNĂTATE:');
      buffer.writeln('---');
      buffer.writeln('Obiectiv: ${_getGoalTypeLabel(goals.goalType)}');

      if (goals.targetWeight != null) {
        buffer.writeln(
          'Greutate țintă: ${goals.targetWeight!.toStringAsFixed(1)} kg',
        );
      }

      if (includeNutritionalTargets) {
        buffer.writeln();
        buffer.writeln('ȚINTE NUTRIȚIONALE (ZILNICE):');
        buffer.writeln(
          'Calorii: ${goals.calorieTarget.toStringAsFixed(0)} kcal',
        );
        buffer.writeln(
          'Proteine: ${goals.proteinTarget.toStringAsFixed(0)}g',
        );
        buffer.writeln(
          'Carbohidrați: ${goals.carbsTarget.toStringAsFixed(0)}g',
        );
        buffer.writeln('Grăsimi: ${goals.fatsTarget.toStringAsFixed(0)}g');
      }
      buffer.writeln();
    }

    // === Dietary Preferences ===
    if (user.preferences != null && includeFoodPreferences) {
      final prefs = user.preferences!;
      buffer.writeln('PREFERINȚE ALIMENTARE:');
      buffer.writeln('---');

      if (prefs.dietType != null) {
        buffer.writeln(
          'Tip dietă: ${_getDietTypeLabel(prefs.dietType!)}',
        );
      }

      if (prefs.allergies.isNotEmpty) {
        buffer.writeln(
          'Alergii: ${prefs.allergies.map(_getAllergyLabel).join(", ")}',
        );
      }

      if (prefs.preferredFoods.isNotEmpty) {
        buffer.writeln(
          'Alimente preferate: ${prefs.preferredFoods.map(_getPreferredFoodLabel).join(", ")}',
        );
      }

      if (prefs.dislikedIngredients.isNotEmpty) {
        buffer.writeln(
          'Ingrediente evitate: ${prefs.dislikedIngredients.join(", ")}',
        );
      }

      if (prefs.dietaryRestrictions.isNotEmpty) {
        buffer.writeln(
          'Restricții: ${prefs.dietaryRestrictions.join(", ")}',
        );
      }
      buffer.writeln();
    }

    // === Recent Meals ===
    if (recentMeals != null &&
        recentMeals.isNotEmpty &&
        includeRecentMeals) {
      buffer.writeln('MESE RECENTE (Ultimele ${recentMeals.length}):');
      buffer.writeln('---');

      for (var i = 0; i < recentMeals.length && i < 5; i++) {
        final meal = recentMeals[i];
        buffer.writeln(
          '${i + 1}. ${meal.mealType}: ${meal.foodName} (${meal.calories.toStringAsFixed(0)} kcal)',
        );
      }
      buffer.writeln();
    }

    return buffer.toString();
  }

  /// Build a recipe suggestion prompt with user context
  static String buildRecipeSuggestionPrompt({
    required UserModel user,
    required List<String> availableIngredients,
    String? mealType,
    int numberOfRecipes = 5,
    List<FoodLogModel>? recentMeals,
  }) {
    final context = buildUserContext(
      user: user,
      recentMeals: recentMeals,
      includeNutritionalTargets: true,
      includeFoodPreferences: true,
      includeRecentMeals: true,
    );

    final mealTypeText = mealType != null ? ' pentru $mealType' : '';

    return '''
$context

SARCINĂ: Sugerează $numberOfRecipes rețete românești$mealTypeText care pot fi preparate folosind următoarele ingrediente:
${availableIngredients.join(", ")}

CERINȚE IMPORTANTE:
1. Respectă STRICT toate alergiile și restricțiile utilizatorului
2. Prioritizează ingredientele preferate
3. Evită ingredientele pe care utilizatorul nu le place
4. Țintește valorile nutriționale zilnice specificate
5. Ia în considerare obiectivele de sănătate (${user.goals?.goalType ?? 'general'})
6. Dacă există mese recente, oferă varietate (nu repeta aceleași ingrediente)

Pentru fiecare rețetă, furnizează:
- Titlul rețetei
- Descrierea scurtă
- Lista completă de ingrediente cu cantități
- Pașii de preparare (numerotați)
- Timpul de preparare (în minute)
- Timpul de gătit (în minute)
- Numărul de porții
- Dificultatea (beginner, intermediate, advanced)
- Informații nutriționale per porție (calorii, proteine, carbohidrați, grăsimi)

Răspunde DOAR cu un JSON valid în următorul format, fără text suplimentar:
{
  "recipes": [
    {
      "title": "Nume rețetă",
      "description": "Descriere scurtă",
      "prepTime": 15,
      "cookTime": 30,
      "servings": 4,
      "difficulty": "beginner",
      "ingredients": [
        {"name": "Ingredient 1", "amount": "200", "unit": "g"}
      ],
      "instructions": [
        "Pasul 1",
        "Pasul 2"
      ],
      "nutrition": {
        "calories": 300,
        "protein": 25,
        "carbs": 30,
        "fats": 10
      }
    }
  ]
}
''';
  }

  /// Build a meal plan generation prompt with user context
  static String buildMealPlanPrompt({
    required UserModel user,
    required int days,
    List<FoodLogModel>? recentMeals,
  }) {
    final context = buildUserContext(
      user: user,
      recentMeals: recentMeals,
      includeNutritionalTargets: true,
      includeFoodPreferences: true,
      includeRecentMeals: true,
    );

    final caloriesPerDay = user.goals?.calorieTarget.toStringAsFixed(0) ?? '2000';
    final proteinPerDay = user.goals?.proteinTarget.toStringAsFixed(0) ?? '150';
    final carbsPerDay = user.goals?.carbsTarget.toStringAsFixed(0) ?? '200';
    final fatsPerDay = user.goals?.fatsTarget.toStringAsFixed(0) ?? '65';

    return '''
$context

SARCINĂ: Generează un plan de mese pentru $days zile cu următoarele obiective nutriționale:
- Calorii zilnice: $caloriesPerDay kcal
- Proteine: ${proteinPerDay}g
- Carbohidrați: ${carbsPerDay}g
- Grăsimi: ${fatsPerDay}g

CERINȚE IMPORTANTE:
1. Respectă STRICT toate alergiile și restricțiile utilizatorului
2. Prioritizează ingredientele preferate
3. Evită ingredientele pe care utilizatorul nu le place
4. Ia în considerare obiectivele de sănătate
5. Oferă varietate între zile
6. Dacă există mese recente, evită repetarea lor în primele zile

Pentru fiecare zi, include:
- Micul dejun
- Prânz
- Cină
- 1-2 gustări

Pentru fiecare masă, specifică:
- Numele rețetei
- Ingredientele cu cantități
- Pașii de preparare
- Informații nutriționale (calorii, proteine, carbohidrați, grăsimi)

Răspunde în limba română cu rețete specifice bucătăriei românești.
Formatează răspunsul ca JSON valid.
''';
  }

  /// Build a nutritional advice prompt
  static String buildNutritionalAdvicePrompt({
    required UserModel user,
    required String question,
    List<FoodLogModel>? recentMeals,
  }) {
    final context = buildUserContext(
      user: user,
      recentMeals: recentMeals,
      includeNutritionalTargets: true,
      includeFoodPreferences: true,
      includeRecentMeals: true,
    );

    return '''
$context

Ești un asistent nutriționist și expert în bucătăria românească.

ÎNTREBARE: $question

Răspunde la întrebare luând în considerare:
1. Profilul utilizatorului (vârstă, gen, greutate, înălțime, activitate)
2. Obiectivele de sănătate
3. Restricțiile și preferințele alimentare
4. Istoricul recent de mese (dacă este disponibil)

Oferă sfaturi practice, personalizate și accesibile, folosind exemple din bucătăria românească când este posibil.
Răspunde în limba română.
''';
  }

  // === Helper methods for label mapping ===

  static String _getGenderLabel(String gender) {
    return ProfileData.genderOptions[gender] ?? gender;
  }

  static String _getActivityLevelLabel(String activityLevel) {
    return ProfileData.activityLevels[activityLevel]?['label'] ?? activityLevel;
  }

  static String _getGoalTypeLabel(String goalType) {
    return ProfileData.healthGoals[goalType]?['label'] ?? goalType;
  }

  static String _getDietTypeLabel(String dietType) {
    return ProfileData.dietTypeLabels[dietType] ?? dietType;
  }

  static String _getAllergyLabel(String allergy) {
    return ProfileData.allergies[allergy] ?? allergy;
  }

  static String _getPreferredFoodLabel(String food) {
    return ProfileData.allPreferredFoods[food] ?? food;
  }
}
