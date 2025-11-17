import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/food_log_model.dart';
import '../../../data/models/recipe_model.dart';
import '../../providers/food_log_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class ManualFoodEntryScreen extends StatefulWidget {
  final String? initialMealType;

  const ManualFoodEntryScreen({
    super.key,
    this.initialMealType,
  });

  @override
  State<ManualFoodEntryScreen> createState() => _ManualFoodEntryScreenState();
}

class _ManualFoodEntryScreenState extends State<ManualFoodEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _foodNameController = TextEditingController();
  final _portionSizeController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatsController = TextEditingController();

  String _selectedMealType = 'breakfast';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialMealType != null) {
      _selectedMealType = widget.initialMealType!;
    }
  }

  @override
  void dispose() {
    _foodNameController.dispose();
    _portionSizeController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userProvider = context.read<UserProvider>();
      final foodLogProvider = context.read<FoodLogProvider>();

      if (userProvider.currentUser == null) {
        throw Exception('Nu există utilizator autentificat');
      }

      final calories = double.parse(_caloriesController.text);
      final protein = double.parse(_proteinController.text);
      final carbs = double.parse(_carbsController.text);
      final fats = double.parse(_fatsController.text);

      final manualEntry = ManualEntry(
        foodName: _foodNameController.text.trim(),
        portionSize: _portionSizeController.text.trim(),
        calories: calories,
        protein: protein,
        carbs: carbs,
        fats: fats,
      );

      final nutrition = NutritionInfo(
        calories: calories,
        protein: protein,
        carbs: carbs,
        fats: fats,
      );

      await foodLogProvider.addManualLog(
        userId: userProvider.currentUser!.userId,
        entry: manualEntry,
        mealType: _selectedMealType,
        nutrition: nutrition,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alimentul a fost înregistrat cu succes!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop(true);
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
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adaugă aliment manual'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Food name
            CustomTextField(
              controller: _foodNameController,
              label: 'Nume aliment',
              hint: 'ex: Piept de pui la grătar',
              prefixIcon: Icons.fastfood,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Numele alimentului este obligatoriu';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Portion size
            CustomTextField(
              controller: _portionSizeController,
              label: 'Porție',
              hint: 'ex: 150g, 1 bucată, 200ml',
              prefixIcon: Icons.scale,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Porția este obligatorie';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Meal type selector
            Text(
              'Tipul mesei',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            _buildMealTypeSelector(),
            const SizedBox(height: 24),

            // Nutrition information header
            Text(
              'Informații nutriționale',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),

            // Calories
            CustomTextField(
              controller: _caloriesController,
              label: 'Calorii',
              hint: '0',
              prefixIcon: Icons.local_fire_department,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Caloriile sunt obligatorii';
                }
                final calories = double.tryParse(value);
                if (calories == null || calories < 0) {
                  return 'Caloriile trebuie să fie un număr pozitiv';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Macronutrients grid
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _proteinController,
                    label: 'Proteine (g)',
                    hint: '0',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,1}')),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Obligatoriu';
                      }
                      final protein = double.tryParse(value);
                      if (protein == null || protein < 0) {
                        return 'Număr pozitiv';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: _carbsController,
                    label: 'Carbohidrați (g)',
                    hint: '0',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,1}')),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Obligatoriu';
                      }
                      final carbs = double.tryParse(value);
                      if (carbs == null || carbs < 0) {
                        return 'Număr pozitiv';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: _fatsController,
              label: 'Grăsimi (g)',
              hint: '0',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Grăsimile sunt obligatorii';
                }
                final fats = double.tryParse(value);
                if (fats == null || fats < 0) {
                  return 'Grăsimile trebuie să fie un număr pozitiv';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            // Info card
            Card(
              color: AppColors.info.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.info,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Poți găsi informațiile nutriționale pe ambalajul alimentelor sau în aplicații dedicate.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save button
            CustomButton(
              text: 'Salvează',
              onPressed: _isLoading ? null : _saveEntry,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTypeSelector() {
    final mealTypes = {
      'breakfast': {'label': 'Micul dejun', 'icon': Icons.free_breakfast},
      'lunch': {'label': 'Prânz', 'icon': Icons.lunch_dining},
      'dinner': {'label': 'Cină', 'icon': Icons.dinner_dining},
      'snacks': {'label': 'Gustări', 'icon': Icons.cookie},
    };

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: mealTypes.entries.map((entry) {
        final isSelected = _selectedMealType == entry.key;
        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                entry.value['icon'] as IconData,
                size: 18,
                color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
              ),
              const SizedBox(width: 6),
              Text(entry.value['label'] as String),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() => _selectedMealType = entry.key);
            }
          },
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
          ),
        );
      }).toList(),
    );
  }
}
