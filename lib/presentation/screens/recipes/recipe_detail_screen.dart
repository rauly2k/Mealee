import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/recipe_model.dart';
import '../../providers/recipe_provider.dart';
import '../../providers/food_log_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/recipe/nutrition_info.dart';

class RecipeDetailScreen extends StatefulWidget {
  final RecipeModel recipe;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  double _portionMultiplier = 1.0;
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final adjustedNutrition = widget.recipe.nutrition.scale(_portionMultiplier);
    final adjustedServings = (widget.recipe.servings * _portionMultiplier).round();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.recipe.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Icon(Icons.restaurant, size: 64),
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Consumer<RecipeProvider>(
                builder: (context, recipeProvider, _) {
                  return IconButton(
                    icon: Icon(
                      widget.recipe.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.recipe.isFavorite
                          ? AppColors.error
                          : AppColors.textOnPrimary,
                    ),
                    onPressed: () {
                      recipeProvider.toggleFavorite(widget.recipe.recipeId);
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // TODO: Implement share
                },
              ),
            ],
          ),

          // Recipe content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and description
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.recipe.title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.recipe.description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 16),
                      // Recipe metadata
                      Row(
                        children: [
                          _buildMetadataChip(
                            icon: Icons.schedule,
                            label: Helpers.formatPrepTime(widget.recipe.totalTime),
                          ),
                          const SizedBox(width: 8),
                          _buildMetadataChip(
                            icon: Icons.restaurant,
                            label: '$adjustedServings ${AppStrings.servings}',
                          ),
                          const SizedBox(width: 8),
                          _buildMetadataChip(
                            icon: Icons.signal_cellular_alt,
                            label: _getDifficultyText(widget.recipe.difficulty),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Portion adjuster
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ajustează porțiile',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              IconButton(
                                onPressed: _portionMultiplier > 0.5
                                    ? () {
                                        setState(() {
                                          _portionMultiplier -= 0.5;
                                        });
                                      }
                                    : null,
                                icon: const Icon(Icons.remove_circle_outline),
                                color: AppColors.primary,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '${_portionMultiplier.toStringAsFixed(1)}x',
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                    ),
                                    Text(
                                      '$adjustedServings porții',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _portionMultiplier += 0.5;
                                  });
                                },
                                icon: const Icon(Icons.add_circle_outline),
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Tabs for ingredients and instructions
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTabButton(
                          0,
                          AppStrings.ingredients,
                          Icons.shopping_basket_outlined,
                        ),
                      ),
                      Expanded(
                        child: _buildTabButton(
                          1,
                          AppStrings.instructions,
                          Icons.list_alt,
                        ),
                      ),
                      Expanded(
                        child: _buildTabButton(
                          2,
                          AppStrings.nutritionInfo,
                          Icons.restaurant_menu,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Tab content
                if (_selectedTab == 0) _buildIngredientsTab(),
                if (_selectedTab == 1) _buildInstructionsTab(),
                if (_selectedTab == 2) _buildNutritionTab(adjustedNutrition),

                const SizedBox(height: 80), // Space for FAB
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showLogMealDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Înregistrează'),
      ),
    );
  }

  Widget _buildMetadataChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String label, IconData icon) {
    final isSelected = _selectedTab == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.ingredients,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),
              ...widget.recipe.ingredients.asMap().entries.map((entry) {
                final index = entry.key;
                final ingredient = entry.value;
                final adjustedQuantity = ingredient.quantity * _portionMultiplier;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${adjustedQuantity.toStringAsFixed(adjustedQuantity % 1 == 0 ? 0 : 1)} ${ingredient.unit} ${ingredient.name}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.instructions,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),
              ...widget.recipe.instructions.asMap().entries.map((entry) {
                final index = entry.key;
                final instruction = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textOnPrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            instruction,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionTab(NutritionInfo nutrition) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: NutritionInfoCard(nutrition: nutrition, compact: false,),
    );
  }

  String _getDifficultyText(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return 'Ușor';
      case 'intermediate':
        return 'Mediu';
      case 'advanced':
        return 'Avansat';
      default:
        return difficulty;
    }
  }

  void _showLogMealDialog(BuildContext context) {
    String selectedMealType = 'lunch';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Înregistrează masă',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Selectează tipul de masă:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildMealTypeChip(
                        'breakfast',
                        AppStrings.breakfast,
                        selectedMealType,
                        setModalState,
                        (value) => selectedMealType = value,
                      ),
                      _buildMealTypeChip(
                        'lunch',
                        AppStrings.lunch,
                        selectedMealType,
                        setModalState,
                        (value) => selectedMealType = value,
                      ),
                      _buildMealTypeChip(
                        'dinner',
                        AppStrings.dinner,
                        selectedMealType,
                        setModalState,
                        (value) => selectedMealType = value,
                      ),
                      _buildMealTypeChip(
                        'snacks',
                        AppStrings.snacks,
                        selectedMealType,
                        setModalState,
                        (value) => selectedMealType = value,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await _logMeal(selectedMealType);
                      },
                      child: const Text('Înregistrează'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMealTypeChip(
    String value,
    String label,
    String selectedValue,
    StateSetter setModalState,
    Function(String) onSelected,
  ) {
    final isSelected = selectedValue == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setModalState(() {
          onSelected(value);
        });
      },
      selectedColor: AppColors.primaryLight.withValues(alpha: 0.3),
      checkmarkColor: AppColors.primary,
    );
  }

  Future<void> _logMeal(String mealType) async {
    final userProvider = context.read<UserProvider>();
    final foodLogProvider = context.read<FoodLogProvider>();

    if (userProvider.currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Trebuie să fii autentificat'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    final success = await foodLogProvider.addRecipeLog(
      userId: userProvider.currentUser!.userId,
      recipeId: widget.recipe.recipeId,
      recipeName: widget.recipe.title,
      mealType: mealType,
      nutrition: widget.recipe.nutrition,
      portionMultiplier: _portionMultiplier,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Masă înregistrată cu succes!'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              foodLogProvider.errorMessage ?? 'Eroare la înregistrare',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
