import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/recipe_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/recipe/recipe_card.dart';

class RecipesListScreen extends StatefulWidget {
  const RecipesListScreen({super.key});

  @override
  State<RecipesListScreen> createState() => _RecipesListScreenState();
}

class _RecipesListScreenState extends State<RecipesListScreen> {
  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    await context.read<RecipeProvider>().loadPopularRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.recipes),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Navigate to search
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter bottom sheet
            },
          ),
        ],
      ),
      body: Consumer<RecipeProvider>(
        builder: (context, recipeProvider, _) {
          if (recipeProvider.isLoading) {
            return const LoadingIndicator(message: 'Se încarcă rețetele...');
          }

          if (recipeProvider.errorMessage != null) {
            return ErrorDisplay(
              message: recipeProvider.errorMessage!,
              onRetry: _loadRecipes,
            );
          }

          if (recipeProvider.recipes.isEmpty) {
            return const EmptyState(
              message: 'Nu există rețete disponibile',
              icon: Icons.restaurant_menu_outlined,
            );
          }

          return RefreshIndicator(
            onRefresh: _loadRecipes,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: recipeProvider.recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipeProvider.recipes[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: RecipeCard(
                    recipe: recipe,
                    onTap: () {
                      // TODO: Navigate to recipe detail
                    },
                    onFavorite: () {
                      recipeProvider.toggleFavorite(recipe.recipeId);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
