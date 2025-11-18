import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/recipe_model.dart';
import '../../providers/recipe_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/recipe/recipe_card.dart';
import '../recipes/recipe_detail_screen.dart';

class AIRecipeGeneratorScreen extends StatefulWidget {
  const AIRecipeGeneratorScreen({super.key});

  @override
  State<AIRecipeGeneratorScreen> createState() =>
      _AIRecipeGeneratorScreenState();
}

class _AIRecipeGeneratorScreenState extends State<AIRecipeGeneratorScreen> {
  final _ingredientsController = TextEditingController();
  final _caloriesMinController = TextEditingController();
  final _caloriesMaxController = TextEditingController();
  final List<String> _selectedIngredients = [];
  final List<XFile> _selectedImages = [];

  String? _selectedFoodType;
  String? _selectedDifficulty;
  String? _selectedCuisine;
  final List<String> _selectedTags = [];

  bool _isSearching = false;
  List<RecipeModel> _results = [];

  final List<String> _foodTypes = [
    'Salată',
    'Supă',
    'Felul principal',
    'Desert',
    'Aperitiv',
    'Smoothie',
    'Mic dejun',
    'Gustare sănătoasă',
  ];

  final List<String> _difficulties = [
    'beginner',
    'intermediate',
    'advanced',
  ];

  final List<String> _cuisines = [
    'romanian',
    'italian',
    'asian',
    'mexican',
    'mediterranean',
    'american',
  ];

  final List<String> _availableTags = [
    'sănătos',
    'vegetarian',
    'vegan',
    'fără gluten',
    'low-carb',
    'high-protein',
    'rapid',
    'economic',
    'festiv',
    'tradițional',
  ];

  @override
  void dispose() {
    _ingredientsController.dispose();
    _caloriesMinController.dispose();
    _caloriesMaxController.dispose();
    super.dispose();
  }

  void _addIngredient() {
    final ingredient = _ingredientsController.text.trim();
    if (ingredient.isNotEmpty && !_selectedIngredients.contains(ingredient)) {
      setState(() {
        _selectedIngredients.add(ingredient);
        _ingredientsController.clear();
      });
    }
  }

  void _removeIngredient(String ingredient) {
    setState(() {
      _selectedIngredients.remove(ingredient);
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _searchRecipes() async {
    setState(() {
      _isSearching = true;
      _results = [];
    });

    try {
      final recipeProvider = context.read<RecipeProvider>();

      // Get all recipes with filters
      List<RecipeModel> allRecipes = await recipeProvider.searchRecipesByQuery('');

      // Apply filters
      List<RecipeModel> filtered = allRecipes.where((recipe) {
        // Filter by ingredients if provided
        if (_selectedIngredients.isNotEmpty) {
          final recipeIngredients = recipe.ingredients
              .map((i) => i.name.toLowerCase())
              .toList();
          final hasIngredients = _selectedIngredients.any((ingredient) =>
              recipeIngredients.any((ri) => ri.contains(ingredient.toLowerCase())));
          if (!hasIngredients) return false;
        }

        // Filter by calories range
        if (_caloriesMinController.text.isNotEmpty) {
          final minCal = double.tryParse(_caloriesMinController.text) ?? 0;
          if (recipe.nutrition.calories < minCal) return false;
        }
        if (_caloriesMaxController.text.isNotEmpty) {
          final maxCal = double.tryParse(_caloriesMaxController.text) ?? double.infinity;
          if (recipe.nutrition.calories > maxCal) return false;
        }

        // Filter by difficulty
        if (_selectedDifficulty != null && recipe.difficulty != _selectedDifficulty) {
          return false;
        }

        // Filter by cuisine
        if (_selectedCuisine != null && recipe.cuisine != _selectedCuisine) {
          return false;
        }

        // Filter by tags
        if (_selectedTags.isNotEmpty) {
          final hasTag = _selectedTags.any((tag) =>
              recipe.tags.any((rt) => rt.toLowerCase().contains(tag.toLowerCase())));
          if (!hasTag) return false;
        }

        return true;
      }).toList();

      // Sort by relevance (recipes with more matching ingredients first)
      if (_selectedIngredients.isNotEmpty) {
        filtered.sort((a, b) {
          final aMatches = _countMatchingIngredients(a);
          final bMatches = _countMatchingIngredients(b);
          return bMatches.compareTo(aMatches);
        });
      }

      setState(() {
        _results = filtered.take(20).toList();
      });

      if (_results.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nu am găsit rețete cu aceste criterii. Încearcă să modifici filtrele!'),
              backgroundColor: AppColors.info,
            ),
          );
        }
      }
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
        _isSearching = false;
      });
    }
  }

  int _countMatchingIngredients(RecipeModel recipe) {
    final recipeIngredients = recipe.ingredients
        .map((i) => i.name.toLowerCase())
        .toList();
    int count = 0;
    for (var ingredient in _selectedIngredients) {
      if (recipeIngredients.any((ri) => ri.contains(ingredient.toLowerCase()))) {
        count++;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generator AI Rețete'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.secondary.withValues(alpha: 0.1),
                          AppColors.accent.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: AppColors.textOnPrimary,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Găsește rețete perfecte',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.secondary,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Personalizează căutarea cu ingrediente, calorii, tipuri și mai multe',
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
                  ),
                  const SizedBox(height: 24),

                  // Ingredients Section
                  _buildSectionTitle('Ingrediente disponibile'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ingredientsController,
                          decoration: InputDecoration(
                            hintText: 'Adaugă un ingredient',
                            prefixIcon: const Icon(Icons.kitchen),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onSubmitted: (_) => _addIngredient(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: _addIngredient,
                        icon: const Icon(Icons.add),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  if (_selectedIngredients.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selectedIngredients
                          .map((ingredient) => Chip(
                                label: Text(ingredient),
                                deleteIcon: const Icon(Icons.close, size: 18),
                                onDeleted: () => _removeIngredient(ingredient),
                                backgroundColor:
                                    AppColors.secondary.withValues(alpha: 0.1),
                              ))
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Photo upload section
                  _buildSectionTitle('Fotografii ingrediente (opțional)'),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.add_photo_alternate),
                    label: const Text('Adaugă fotografii'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      foregroundColor: AppColors.textPrimary,
                    ),
                  ),
                  if (_selectedImages.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(_selectedImages[index].path),
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: IconButton(
                                    onPressed: () => _removeImage(index),
                                    icon: const Icon(Icons.close),
                                    style: IconButton.styleFrom(
                                      backgroundColor: AppColors.error,
                                      foregroundColor: AppColors.textOnPrimary,
                                      padding: const EdgeInsets.all(4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Calories Range
                  _buildSectionTitle('Interval calorii (opțional)'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _caloriesMinController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Min (kcal)',
                            prefixIcon: const Icon(Icons.trending_down),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _caloriesMaxController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Max (kcal)',
                            prefixIcon: const Icon(Icons.trending_up),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Food Type
                  _buildSectionTitle('Tip mâncare (opțional)'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _foodTypes
                        .map((type) => ChoiceChip(
                              label: Text(type),
                              selected: _selectedFoodType == type,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedFoodType = selected ? type : null;
                                });
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // Difficulty
                  _buildSectionTitle('Dificultate (opțional)'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _difficulties
                        .map((difficulty) => ChoiceChip(
                              label: Text(_getDifficultyLabel(difficulty)),
                              selected: _selectedDifficulty == difficulty,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedDifficulty =
                                      selected ? difficulty : null;
                                });
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // Cuisine
                  _buildSectionTitle('Bucătărie (opțional)'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _cuisines
                        .map((cuisine) => ChoiceChip(
                              label: Text(_getCuisineLabel(cuisine)),
                              selected: _selectedCuisine == cuisine,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCuisine = selected ? cuisine : null;
                                });
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // Tags
                  _buildSectionTitle('Preferințe (opțional)'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableTags
                        .map((tag) => FilterChip(
                              label: Text(tag),
                              selected: _selectedTags.contains(tag),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedTags.add(tag);
                                  } else {
                                    _selectedTags.remove(tag);
                                  }
                                });
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // Results Section
                  if (_results.isNotEmpty) ...[
                    const Divider(height: 32),
                    Text(
                      'Rezultate găsite: ${_results.length}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Consumer<RecipeProvider>(
                      builder: (context, recipeProvider, _) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _results.length,
                          itemBuilder: (context, index) {
                            final recipe = _results[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
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
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Search Button (sticky at bottom)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSearching ? null : _searchRecipes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isSearching
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
                    : const Icon(Icons.search),
                label: Text(
                  _isSearching ? 'Caut rețete...' : 'Caută rețete',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  String _getDifficultyLabel(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return 'Începător';
      case 'intermediate':
        return 'Intermediar';
      case 'advanced':
        return 'Avansat';
      default:
        return difficulty;
    }
  }

  String _getCuisineLabel(String cuisine) {
    switch (cuisine) {
      case 'romanian':
        return 'Românească';
      case 'italian':
        return 'Italiană';
      case 'asian':
        return 'Asiatică';
      case 'mexican':
        return 'Mexicană';
      case 'mediterranean':
        return 'Mediteraneană';
      case 'american':
        return 'Americană';
      default:
        return cuisine;
    }
  }
}
