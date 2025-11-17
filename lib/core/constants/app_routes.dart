/// Route names for navigation throughout the app
class AppRoutes {
  AppRoutes._();

  // Initial routes
  static const String splash = '/';
  static const String welcome = '/welcome';

  // Authentication
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Onboarding
  static const String onboarding = '/onboarding';
  static const String profileSetup = '/profile-setup';
  static const String goalSelection = '/goal-selection';
  static const String dietaryPreferences = '/dietary-preferences';

  // Main app navigation
  static const String mainNav = '/main';
  static const String home = '/home';
  static const String recipesTab = '/recipes';
  static const String mealPlansTab = '/meal-plans';
  static const String pantryTab = '/pantry';
  static const String profileTab = '/profile';

  // Recipes
  static const String recipesList = '/recipes/list';
  static const String recipeDetail = '/recipes/detail';
  static const String recipeSearch = '/recipes/search';
  static const String favoriteRecipes = '/recipes/favorites';

  // Meal Plans
  static const String mealPlans = '/meal-plans';
  static const String mealPlanDetail = '/meal-plans/detail';
  static const String generateMealPlan = '/meal-plans/generate';

  // Food Logging
  static const String logFood = '/log-food';
  static const String foodSearch = '/food-search';
  static const String scanFood = '/scan-food';

  // Pantry
  static const String pantry = '/pantry';
  static const String addIngredient = '/pantry/add-ingredient';
  static const String scanReceipt = '/pantry/scan-receipt';

  // Shopping List
  static const String shoppingList = '/shopping-list';

  // Profile
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String settings = '/settings';
  static const String progress = '/progress';
  static const String goals = '/goals';

  // Premium
  static const String premium = '/premium';

  // Helper method to navigate with arguments
  static String recipeDetailWithId(String id) => '$recipeDetail/$id';
  static String mealPlanDetailWithId(String id) => '$mealPlanDetail/$id';
}
