import '../../data/models/recipe_model.dart';

/// Example recipes to be used throughout the app
class ExampleRecipes {
  static final RecipeModel sarmaleDeCasa = RecipeModel(
    recipeId: 'example_sarmale',
    title: 'Sarmale de casă cu smântână',
    description:
        'Sarmale tradiționale românești cu carne de porc și vită, fierte în foi de varză murată și servite cu smântână și mămăligă.',
    imageUrl:
        'https://images.unsplash.com/photo-1625937286074-9ca519d5d9df?w=800&q=80',
    prepTime: 60,
    cookTime: 180,
    totalTime: 240,
    servings: 6,
    difficulty: 'intermediate',
    ingredients: const [
      Ingredient(name: 'Varză murată', quantity: 1, unit: 'kg'),
      Ingredient(name: 'Carne de porc tocată', quantity: 500, unit: 'g'),
      Ingredient(name: 'Carne de vită tocată', quantity: 300, unit: 'g'),
      Ingredient(name: 'Orez', quantity: 200, unit: 'g'),
      Ingredient(name: 'Ceapă', quantity: 2, unit: 'buc'),
      Ingredient(name: 'Morcov', quantity: 1, unit: 'buc'),
      Ingredient(name: 'Bulion de roșii', quantity: 200, unit: 'ml'),
      Ingredient(name: 'Ulei', quantity: 3, unit: 'linguri'),
      Ingredient(name: 'Sare', quantity: 1, unit: 'linguriță'),
      Ingredient(name: 'Piper negru', quantity: 0.5, unit: 'linguriță'),
      Ingredient(name: 'Foi de dafin', quantity: 3, unit: 'buc'),
      Ingredient(name: 'Smântână', quantity: 200, unit: 'ml'),
    ],
    instructions: const [
      'Spălați frunzele de varză murată și puneți-le la înmuiat în apă rece pentru a reduce aciditatea.',
      'Tocați fin ceapa și calițil-o în ulei până devine transparentă.',
      'Amestecați carnea tocată cu orezul, ceapa călită, sare și piper.',
      'Tăiați nervurile groase de pe frunzele de varză.',
      'Puneți o lingură de compoziție pe fiecare frunză și rulați strâns.',
      'Așternuți câteva frunze de varză pe fundul unei oale mari.',
      'Aranjați sarmalele în straturi, adăugând foi de dafin și morcov tăiat rondele între straturi.',
      'Acoperiți sarmalele cu bulion de roșii și apă astfel încât să fie acoperite complet.',
      'Fierbeți la foc mic 3 ore, până când carnea este fragedă și orezul este gătit.',
      'Serviți fierbinte cu smântână și mămăligă caldă.',
    ],
    nutrition: const NutritionInfo(
      calories: 420,
      protein: 28,
      carbs: 35,
      fats: 18,
      healthScore: 72,
    ),
    tags: const [
      'tradițional',
      'românesc',
      'sărbători',
      'carne',
      'varză',
    ],
    category: 'lunch',
    cuisine: 'romanian',
    createdBy: 'admin',
    createdAt: DateTime(2024, 1, 1),
    isFavorite: false,
  );

  static final RecipeModel papanasi = RecipeModel(
    recipeId: 'example_papanasi',
    title: 'Papanași cu smântână și dulceață',
    description:
        'Desert tradițional românesc făcut din brânză de vaci, prăjiți în ulei și serviți cu smântână și dulceață de vișine.',
    imageUrl:
        'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=800&q=80',
    prepTime: 30,
    cookTime: 20,
    totalTime: 50,
    servings: 4,
    difficulty: 'beginner',
    ingredients: const [
      Ingredient(name: 'Brânză de vaci', quantity: 500, unit: 'g'),
      Ingredient(name: 'Ouă', quantity: 2, unit: 'buc'),
      Ingredient(name: 'Făină', quantity: 150, unit: 'g'),
      Ingredient(name: 'Zahăr', quantity: 50, unit: 'g'),
      Ingredient(name: 'Sare', quantity: 1, unit: 'praf'),
      Ingredient(name: 'Esență de vanilie', quantity: 1, unit: 'linguriță'),
      Ingredient(name: 'Bicarbonat de sodiu', quantity: 0.5, unit: 'linguriță'),
      Ingredient(name: 'Ulei pentru prăjit', quantity: 500, unit: 'ml'),
      Ingredient(name: 'Smântână', quantity: 200, unit: 'ml'),
      Ingredient(name: 'Dulceață de vișine', quantity: 200, unit: 'g'),
      Ingredient(name: 'Zahăr pudră', quantity: 50, unit: 'g'),
    ],
    instructions: const [
      'Pasați brânza de vaci printr-o sită sau amestecați-o bine până devine netedă.',
      'Adăugați ouăle, zahărul, sarea și esența de vanilie peste brânză.',
      'Încorporați făina și bicarbonatul, amestecând până obțineți o compoziție omogenă.',
      'Lăsați aluatul să se odihnească 15 minute.',
      'Modelați papanași: formați bile mari pentru bază și bile mici pentru vârf.',
      'Faceți o gaură în mijlocul fiecărei bile mari.',
      'Încălziți uleiul într-o tigaie adâncă la temperatura potrivită (170-180°C).',
      'Prăjiți papanașii câte 2-3 bucăți deodată, până devin aurii pe ambele părți.',
      'Scoateți-i pe un șervețel absorbant pentru a elimina excesul de ulei.',
      'Serviți calzi, pudrați cu zahăr pudră, însoțiți de smântână și dulceață.',
    ],
    nutrition: const NutritionInfo(
      calories: 520,
      protein: 18,
      carbs: 48,
      fats: 28,
      healthScore: 45,
    ),
    tags: const [
      'desert',
      'tradițional',
      'românesc',
      'prăjit',
      'brânză',
    ],
    category: 'dessert',
    cuisine: 'romanian',
    createdBy: 'admin',
    createdAt: DateTime(2024, 1, 1),
    isFavorite: false,
  );

  static final RecipeModel ciorbaDeBurta = RecipeModel(
    recipeId: 'example_ciorba_burta',
    title: 'Ciorbă de burtă',
    description:
        'Supă tradițională românească făcută din burtă de vită, servită cu smântână, usturoi și ardei iute.',
    imageUrl:
        'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=800&q=80',
    prepTime: 30,
    cookTime: 120,
    totalTime: 150,
    servings: 6,
    difficulty: 'advanced',
    ingredients: const [
      Ingredient(name: 'Burtă de vită curățată', quantity: 800, unit: 'g'),
      Ingredient(name: 'Morcov', quantity: 2, unit: 'buc'),
      Ingredient(name: 'Țelină', quantity: 1, unit: 'rădăcină'),
      Ingredient(name: 'Ceapă', quantity: 1, unit: 'buc'),
      Ingredient(name: 'Smântână grasă', quantity: 200, unit: 'ml'),
      Ingredient(name: 'Gălbenuș de ou', quantity: 3, unit: 'buc'),
      Ingredient(name: 'Usturoi', quantity: 5, unit: 'căței'),
      Ingredient(name: 'Oțet', quantity: 100, unit: 'ml'),
      Ingredient(name: 'Sare', quantity: 2, unit: 'linguriță'),
      Ingredient(name: 'Foi de dafin', quantity: 2, unit: 'buc'),
      Ingredient(name: 'Ardei iute', quantity: 1, unit: 'buc'),
    ],
    instructions: const [
      'Spălați burta și fierbeți-o într-o oală mare cu apă, schimbând apa după prima fierbere.',
      'Adăugați morcovul, țelina, ceapa, foile de dafin și sare.',
      'Fierbeți 2 ore până burta devine fragedă.',
      'Scoateți burta și tăiați-o în fâșii subțiri.',
      'Strecoați supa și păstrați legumele tăiate mărunt.',
      'Pregătiți smântâna: amestecați smântâna cu gălbenușurile.',
      'Adăugați treptat supă fierbinte peste smântână, amestecând continuu.',
      'Turnați amestecul de smântână înapoi în supă, amestecând încontinuu.',
      'Adăugați oțetul și usturoiul pisat.',
      'Serviți fierbinte cu ardei iute proaspăt.',
    ],
    nutrition: const NutritionInfo(
      calories: 280,
      protein: 24,
      carbs: 12,
      fats: 16,
      healthScore: 68,
    ),
    tags: const [
      'tradițional',
      'românesc',
      'supă',
      'ciorba',
    ],
    category: 'lunch',
    cuisine: 'romanian',
    createdBy: 'admin',
    createdAt: DateTime(2024, 1, 1),
    isFavorite: false,
  );

  static final RecipeModel tochituraMoldoveneasca = RecipeModel(
    recipeId: 'example_tochitura',
    title: 'Tochitură moldovenească',
    description:
        'Mâncare tradițională din Moldova cu carne de porc, cârnați și mămăligă, servită cu ou prăjit și ardei copt.',
    imageUrl:
        'https://images.unsplash.com/photo-1529692236671-f1f6cf9683ba?w=800&q=80',
    prepTime: 20,
    cookTime: 40,
    totalTime: 60,
    servings: 4,
    difficulty: 'intermediate',
    ingredients: const [
      Ingredient(name: 'Carne de porc (pulpă)', quantity: 600, unit: 'g'),
      Ingredient(name: 'Cârnați afumați', quantity: 300, unit: 'g'),
      Ingredient(name: 'Ceapă', quantity: 2, unit: 'buc'),
      Ingredient(name: 'Usturoi', quantity: 4, unit: 'căței'),
      Ingredient(name: 'Vin alb', quantity: 100, unit: 'ml'),
      Ingredient(name: 'Bulion de roșii', quantity: 200, unit: 'ml'),
      Ingredient(name: 'Ouă', quantity: 4, unit: 'buc'),
      Ingredient(name: 'Ulei', quantity: 3, unit: 'linguri'),
      Ingredient(name: 'Sare', quantity: 1, unit: 'linguriță'),
      Ingredient(name: 'Piper negru', quantity: 0.5, unit: 'linguriță'),
      Ingredient(name: 'Foi de dafin', quantity: 2, unit: 'buc'),
      Ingredient(name: 'Ardei capia', quantity: 2, unit: 'buc'),
    ],
    instructions: const [
      'Tăiați carnea de porc în cuburi mici și călițil-o în ulei până se rumenește.',
      'Adăugați ceapa tocată fin și călițil-o până devine aurie.',
      'Adăugați cârnații tăiați rondele și prăjiți-i ușor.',
      'Stropiți cu vin alb și lăsați să se evapore alcoolul.',
      'Adăugați bulionul de roșii, foile de dafin, sare și piper.',
      'Lăsați la foc mic 30 minute, adăugând apă dacă e necesar.',
      'Coaceți ardeii în cuptor până se înnegresc, curățațil-i și tăiați-i fâșii.',
      'Prăjiți ouăle într-o tigaie separată.',
      'La final adăugați usturoiul pisat în tocitură.',
      'Serviți fierbinte cu mămăligă, ou prăjit și ardei copt.',
    ],
    nutrition: const NutritionInfo(
      calories: 680,
      protein: 42,
      carbs: 15,
      fats: 48,
      healthScore: 58,
    ),
    tags: const [
      'tradițional',
      'românesc',
      'moldovenesc',
      'carne',
    ],
    category: 'lunch',
    cuisine: 'romanian',
    createdBy: 'admin',
    createdAt: DateTime(2024, 1, 1),
    isFavorite: false,
  );

  static final RecipeModel salataDeVinete = RecipeModel(
    recipeId: 'example_salata_vinete',
    title: 'Salată de vinete',
    description:
        'Salată tradițională românească din vinete coapte, ceapă și maioneză, perfectă ca aperitiv.',
    imageUrl:
        'https://images.unsplash.com/photo-1505253716362-afaea1d3d1af?w=800&q=80',
    prepTime: 15,
    cookTime: 30,
    totalTime: 45,
    servings: 6,
    difficulty: 'beginner',
    ingredients: const [
      Ingredient(name: 'Vinete mari', quantity: 4, unit: 'buc'),
      Ingredient(name: 'Ceapă albă', quantity: 1, unit: 'buc'),
      Ingredient(name: 'Maioneză', quantity: 150, unit: 'g'),
      Ingredient(name: 'Ulei de floarea soarelui', quantity: 100, unit: 'ml'),
      Ingredient(name: 'Sare', quantity: 1, unit: 'linguriță'),
      Ingredient(name: 'Piper negru', quantity: 0.5, unit: 'linguriță'),
      Ingredient(name: 'Suc de lămâie', quantity: 1, unit: 'lingură'),
    ],
    instructions: const [
      'Înțepați vinetele cu o furculiță în mai multe locuri.',
      'Coaceți vinetele pe grătar sau direct pe aragaz până se înmoaie complet.',
      'Lăsați vinetele să se răcească, apoi curățați-le de coajă.',
      'Scurgeți bine vinetele de lichidul în exces.',
      'Tocați fin ceapa sau dați-o pe răzătoare.',
      'Tocați vinetele cu un cuțit sau mixați-le ușor (nu complet).',
      'Adăugați treptat ulei și maioneză, amestecând continuu.',
      'Incorporați ceapa tocată, sarea, piperul și sucul de lămâie.',
      'Amestecați bine până obțineți o textură cremă.',
      'Serviți rece cu pâine prăjită sau clătite.',
    ],
    nutrition: const NutritionInfo(
      calories: 180,
      protein: 2,
      carbs: 12,
      fats: 14,
      healthScore: 55,
    ),
    tags: const [
      'tradițional',
      'românesc',
      'salată',
      'aperitiv',
      'vegetarian',
    ],
    category: 'snack',
    cuisine: 'romanian',
    createdBy: 'admin',
    createdAt: DateTime(2024, 1, 1),
    isFavorite: false,
  );

  /// Get all example recipes
  static List<RecipeModel> getAll() {
    return [
      sarmaleDeCasa,
      papanasi,
      ciorbaDeBurta,
      tochituraMoldoveneasca,
      salataDeVinete,
    ];
  }

  /// Get recipes by category
  static List<RecipeModel> getByCategory(String category) {
    return getAll().where((recipe) => recipe.category == category).toList();
  }

  /// Get a random recipe
  static RecipeModel getRandom() {
    final recipes = getAll();
    return recipes[DateTime.now().millisecond % recipes.length];
  }
}
