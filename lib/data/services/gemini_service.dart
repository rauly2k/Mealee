import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = 'YOUR_GEMINI_API_KEY_HERE'; // TODO: Move to environment variables
  late final GenerativeModel _model;
  late final GenerativeModel _visionModel;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );
    _visionModel = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );
  }

  /// Analyze food from image and return nutrition information
  Future<Map<String, dynamic>> analyzeFoodFromImage(Uint8List imageBytes) async {
    try {
      final prompt = '''
Analizează această imagine și identifică alimentele prezente.
Pentru fiecare aliment identificat, estimează:
- Numele alimentului în română
- Mărimea porției (ex: 100g, 1 bucată, etc.)
- Calorii
- Proteine (g)
- Carbohidrați (g)
- Grăsimi (g)

Răspunde DOAR cu un JSON valid în următorul format, fără text suplimentar:
{
  "foods": [
    {
      "name": "Nume aliment",
      "portion": "100g",
      "calories": 200,
      "protein": 10,
      "carbs": 20,
      "fats": 5
    }
  ]
}
''';

      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      final response = await _visionModel.generateContent(content);
      final text = response.text ?? '';

      // Extract JSON from response
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch != null) {
        final jsonStr = jsonMatch.group(0)!;
        return json.decode(jsonStr) as Map<String, dynamic>;
      }

      throw Exception('Nu s-a putut extrage informația din răspuns');
    } catch (e) {
      throw Exception('Eroare la analiza imaginii: $e');
    }
  }

  /// Generate a meal plan based on user preferences and goals
  Future<String> generateMealPlan({
    required int targetCalories,
    required double targetProtein,
    required double targetCarbs,
    required double targetFats,
    required int days,
    List<String> dietaryRestrictions = const [],
    List<String> allergies = const [],
  }) async {
    try {
      final restrictionsText = dietaryRestrictions.isNotEmpty
          ? 'Restricții dietetice: ${dietaryRestrictions.join(", ")}'
          : '';
      final allergiesText = allergies.isNotEmpty
          ? 'Alergii: ${allergies.join(", ")}'
          : '';

      final prompt = '''
Generează un plan de mese pentru $days zile cu următoarele obiective nutriționale:
- Calorii zilnice: $targetCalories kcal
- Proteine: ${targetProtein.toStringAsFixed(0)}g
- Carbohidrați: ${targetCarbs.toStringAsFixed(0)}g
- Grăsimi: ${targetFats.toStringAsFixed(0)}g

$restrictionsText
$allergiesText

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

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? 'Nu s-a putut genera planul de mese';
    } catch (e) {
      throw Exception('Eroare la generarea planului de mese: $e');
    }
  }

  /// Get recipe suggestions based on available ingredients
  Future<List<Map<String, dynamic>>> suggestRecipes({
    required List<String> ingredients,
    List<String> dietaryRestrictions = const [],
    int? maxCalories, required List<String> availableIngredients, String? preferences,
  }) async {
    try {
      final restrictionsText = dietaryRestrictions.isNotEmpty
          ? 'Restricții dietetice: ${dietaryRestrictions.join(", ")}'
          : '';
      final caloriesText = maxCalories != null
          ? 'Maxim $maxCalories calorii per porție'
          : '';

      final prompt = '''
Sugerează 5 rețete românești care pot fi preparate folosind următoarele ingrediente:
${ingredients.join(", ")}

$restrictionsText
$caloriesText

Pentru fiecare rețetă, furnizează:
- Titlul rețetei
- Descrierea scurtă
- Lista completă de ingrediente cu cantități
- Pașii de preparare (numerotați)
- Timpul de preparare (în minute)
- Timpul de gătit (în minute)
- Numărul de porții
- Dificultatea (easy, medium, hard)
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
      "difficulty": "easy",
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

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final text = response.text ?? '';

      // Extract JSON from response
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch != null) {
        final jsonStr = jsonMatch.group(0)!;
        final data = json.decode(jsonStr) as Map<String, dynamic>;
        return List<Map<String, dynamic>>.from(data['recipes'] ?? []);
      }

      return [];
    } catch (e) {
      throw Exception('Eroare la generarea rețetelor: $e');
    }
  }

  /// Get nutritional analysis for a recipe or meal description
  Future<Map<String, dynamic>> analyzeNutrition(String foodDescription) async {
    try {
      final prompt = '''
Analizează următoarea descriere de aliment sau rețetă și estimează informațiile nutriționale:

$foodDescription

Răspunde DOAR cu un JSON valid în următorul format, fără text suplimentar:
{
  "name": "Nume aliment/rețetă",
  "portion": "100g sau alt tip de porție",
  "calories": 0,
  "protein": 0,
  "carbs": 0,
  "fats": 0,
  "fiber": 0,
  "sugar": 0,
  "sodium": 0
}
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final text = response.text ?? '';

      // Extract JSON from response
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch != null) {
        final jsonStr = jsonMatch.group(0)!;
        return json.decode(jsonStr) as Map<String, dynamic>;
      }

      throw Exception('Nu s-a putut analiza informația nutrițională');
    } catch (e) {
      throw Exception('Eroare la analiza nutrițională: $e');
    }
  }

  /// Get healthy meal suggestions based on user goals
  Future<String> getHealthyMealSuggestions({
    required String goalType,
    required int targetCalories,
    required String mealType,
  }) async {
    try {
      final goalText = {
        'weight_loss': 'slăbire',
        'weight_maintenance': 'menținere greutate',
        'muscle_gain': 'creștere masă musculară',
        'general_health': 'sănătate generală',
      }[goalType] ?? goalType;

      final mealTypeText = {
        'breakfast': 'micul dejun',
        'lunch': 'prânz',
        'dinner': 'cină',
        'snacks': 'gustări',
      }[mealType] ?? mealType;

      final prompt = '''
Sugerează 3 opțiuni sănătoase de $mealTypeText pentru obiectivul de $goalText.
Buget caloric per masă: aproximativ ${(targetCalories / 4).toStringAsFixed(0)} calorii.

Pentru fiecare opțiune, include:
- Numele mesei
- Lista de ingrediente
- Informații nutriționale (calorii, proteine, carbohidrați, grăsimi)
- Beneficiile pentru obiectivul menționat

Răspunde în limba română cu opțiuni specifice bucătăriei românești.
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? 'Nu s-au putut genera sugestii';
    } catch (e) {
      throw Exception('Eroare la generarea sugestiilor: $e');
    }
  }

  /// Chat with Gemini about nutrition and recipes
  Future<String> chat(String message) async {
    try {
      final prompt = '''
Ești un asistent nutriționist și expert în bucătăria românească.
Răspunde în limba română la următoarea întrebare:

$message

Oferă sfaturi practice și accesibile, folosind exemple din bucătăria românească când este posibil.
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? 'Nu am putut genera un răspuns';
    } catch (e) {
      throw Exception('Eroare în conversație: $e');
    }
  }
}
