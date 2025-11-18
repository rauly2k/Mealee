import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/example_recipes.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/services/gemini_service.dart';
import '../../providers/user_provider.dart';
import '../../providers/food_log_provider.dart';
import '../../providers/recipe_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/recipe/nutrition_info.dart';
import '../../widgets/recipe/recipe_card.dart';
import '../food_log/food_log_screen.dart';
import '../recipes/recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _whatToEatController = TextEditingController();
  final _ingredientsController = TextEditingController();
  bool _isGeneratingRecipes = false;
  List<String> _aiSuggestions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadData();
      }
    });
  }

  @override
  void dispose() {
    _whatToEatController.dispose();
    _ingredientsController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final userProvider = context.read<UserProvider>();
    final foodLogProvider = context.read<FoodLogProvider>();
    final recipeProvider = context.read<RecipeProvider>();

    await userProvider.loadCurrentUser();

    if (userProvider.currentUser != null) {
      await foodLogProvider.loadTodayLogs(userProvider.currentUser!.userId);
      await recipeProvider.loadPopularRecipes();
    }
  }

  Future<void> _generateRecipeSuggestions() async {
    if (_ingredientsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Te rog introdu cel puțin un ingredient'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() {
      _isGeneratingRecipes = true;
      _aiSuggestions = [];
    });

    try {
      final geminiService = GeminiService();
      final suggestions = await geminiService.suggestRecipes(
        ingredients: _ingredientsController.text.split(','), availableIngredients: [],
      );

      setState(() {
        _aiSuggestions = suggestions.cast<String>();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Eroare: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isGeneratingRecipes = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Consumer3<UserProvider, FoodLogProvider, RecipeProvider>(
          builder: (context, userProvider, foodLogProvider, recipeProvider, _) {
            if (userProvider.isLoading) {
              return const LoadingIndicator(message: 'Se încarcă...');
            }

            if (userProvider.currentUser == null) {
              return const Center(
                child: Text('Nu există utilizator autentificat'),
              );
            }

            final user = userProvider.currentUser!;
            final todayNutrition = foodLogProvider.todayNutrition;
            final goals = user.goals;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome header with gradient
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bine ai venit, ${user.displayName}! 👋',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textOnPrimary,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Helpers.formatDate(DateTime.now(),
                              pattern: 'EEEE, d MMMM yyyy'),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: AppColors.textOnPrimary
                                    .withValues(alpha: 0.9),
                              ),
                        ),
                      ],
                    ),
                  ),

                  // AI Recipe Generator Section
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.secondary.withValues(alpha: 0.1),
                          AppColors.accent.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.auto_awesome,
                                  color: AppColors.textOnPrimary,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Generează Rețete AI',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.secondary,
                                          ),
                                    ),
                                    Text(
                                      'Sugestii personalizate bazate pe ingrediente',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _whatToEatController,
                            decoration: InputDecoration(
                              labelText: 'Ce ai vrea să mănânci? (opțional)',
                              hintText: 'Ex: ceva tradițional românesc',
                              prefixIcon: const Icon(Icons.restaurant_menu),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: AppColors.surface,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _ingredientsController,
                            decoration: InputDecoration(
                              labelText: 'Ce ingrediente ai? *',
                              hintText: 'Ex: pui, orez, legume',
                              prefixIcon: const Icon(Icons.kitchen),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: AppColors.surface,
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed:
                                  _isGeneratingRecipes ? null : _generateRecipeSuggestions,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondary,
                                foregroundColor: AppColors.textOnPrimary,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: _isGeneratingRecipes
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.textOnPrimary,
                                        ),
                                      ),
                                    )
                                  : const Icon(Icons.auto_awesome),
                              label: Text(
                                _isGeneratingRecipes
                                    ? 'Generez...'
                                    : 'Generează Sugestii',
                              ),
                            ),
                          ),
                          if (_aiSuggestions.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 8),
                            Text(
                              '🎯 Sugestii AI:',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            ..._aiSuggestions.map((suggestion) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColors.secondary
                                            .withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.lightbulb_outline,
                                          color: AppColors.secondary,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            suggestion,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Nutrition summary card
                  if (goals != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        AppStrings.todaysNutrition,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.trending_up,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Progresul tău astăzi',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              NutritionProgressBar(
                                label: AppStrings.calories,
                                current: todayNutrition.calories,
                                target: goals.calorieTarget,
                                color: AppColors.calories,
                              ),
                              const SizedBox(height: 12),
                              NutritionProgressBar(
                                label: AppStrings.protein,
                                current: todayNutrition.protein,
                                target: goals.proteinTarget,
                                color: AppColors.protein,
                              ),
                              const SizedBox(height: 12),
                              NutritionProgressBar(
                                label: AppStrings.carbs,
                                current: todayNutrition.carbs,
                                target: goals.carbsTarget,
                                color: AppColors.carbs,
                              ),
                              const SizedBox(height: 12),
                              NutritionProgressBar(
                                label: AppStrings.fats,
                                current: todayNutrition.fats,
                                target: goals.fatsTarget,
                                color: AppColors.fats,
                              ),
                              const SizedBox(height: 12),
                              Center(
                                child: TextButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const FoodLogScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.history, size: 18),
                                  label: const Text('Vezi jurnalul complet'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Recipe Categories
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rețete Populare',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to recipes tab
                            DefaultTabController.of(context)?.animateTo(1);
                          },
                          child: const Text('Vezi toate'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Popular Recipes Horizontal List
                  SizedBox(
                    height: 280,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: ExampleRecipes.getAll().length,
                      itemBuilder: (context, index) {
                        final recipe = ExampleRecipes.getAll()[index];
                        return Container(
                          width: 300,
                          margin: const EdgeInsets.only(right: 16),
                          child: RecipeCard(
                            recipe: recipe,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      RecipeDetailScreen(recipe: recipe),
                                ),
                              );
                            },
                            onFavorite: () {
                              recipeProvider.toggleFavorite(recipe.recipeId);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Recipe by Category
                  _buildCategorySection(
                    context,
                    'Deserturi',
                    ExampleRecipes.getByCategory('dessert'),
                    recipeProvider,
                  ),
                  const SizedBox(height: 16),

                  _buildCategorySection(
                    context,
                    'Feluri principale',
                    ExampleRecipes.getByCategory('lunch'),
                    recipeProvider,
                  ),
                  const SizedBox(height: 16),

                  _buildCategorySection(
                    context,
                    'Aperitive',
                    ExampleRecipes.getByCategory('snack'),
                    recipeProvider,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    String categoryName,
    List recipes,
    RecipeProvider recipeProvider,
  ) {
    if (recipes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            categoryName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Container(
                width: 300,
                margin: const EdgeInsets.only(right: 16),
                child: RecipeCard(
                  recipe: recipe,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailScreen(recipe: recipe),
                      ),
                    );
                  },
                  onFavorite: () {
                    recipeProvider.toggleFavorite(recipe.recipeId);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
