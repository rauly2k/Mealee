import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/food_log_model.dart';
import '../../../data/models/recipe_model.dart';
import '../../../data/services/gemini_service.dart';
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
  final _imagePicker = ImagePicker();

  String _selectedMealType = 'breakfast';
  bool _isLoading = false;
  bool _isAnalyzing = false;
  File? _selectedImage;

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

  Future<void> _takePicture() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        _analyzeImage();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Eroare la deschiderea camerei: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        _analyzeImage();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Eroare la selectarea imaginii: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final geminiService = GeminiService();
      final analysisResult = await geminiService.analyzeFoodFromImage(
        _selectedImage!.path,
      );

      // Parse the analysis result and populate fields
      // The result is a Map with keys: foodItems, estimatedCalories, protein, carbs, fats
      if (analysisResult.containsKey('foodItems') &&
          analysisResult['foodItems'] is List &&
          (analysisResult['foodItems'] as List).isNotEmpty) {
        final foodItems = analysisResult['foodItems'] as List;
        _foodNameController.text = foodItems.join(', ');
      }

      if (analysisResult.containsKey('estimatedCalories')) {
        _caloriesController.text =
            analysisResult['estimatedCalories'].toString();
      }

      if (analysisResult.containsKey('protein')) {
        _proteinController.text = analysisResult['protein'].toString();
      }

      if (analysisResult.containsKey('carbs')) {
        _carbsController.text = analysisResult['carbs'].toString();
      }

      if (analysisResult.containsKey('fats')) {
        _fatsController.text = analysisResult['fats'].toString();
      }

      if (analysisResult.containsKey('portion')) {
        _portionSizeController.text = analysisResult['portion'].toString();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✨ Analiza AI completă! Verifică și ajustează valorile.'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Eroare la analiză: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
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

      // Parse portion size (e.g., "100 g" -> quantity: 100, unit: "g")
      final portionSizeText = _portionSizeController.text.trim();
      double quantity = 1.0;
      String unit = 'porție';

      final parts = portionSizeText.split(' ');
      if (parts.length >= 2) {
        quantity = double.tryParse(parts[0]) ?? 1.0;
        unit = parts.sublist(1).join(' ');
      } else if (parts.length == 1) {
        quantity = double.tryParse(parts[0]) ?? 1.0;
      }

      final manualEntry = ManualEntry(
        foodName: _foodNameController.text.trim(),
        quantity: quantity,
        unit: unit,
      );

      final nutrition = NutritionInfo(
        calories: calories,
        protein: protein,
        carbs: carbs,
        fats: fats,
      );

      await foodLogProvider.addManualLog(
        userId: userProvider.currentUser!.userId,
        manualEntry: manualEntry,
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
        title: const Text('Înregistrează masă'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Photo capture section with beautiful design
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent.withValues(alpha: 0.1),
                    AppColors.secondary.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
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
                              'Analiză AI cu Cameră',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accent,
                                  ),
                            ),
                            Text(
                              'Fă o poză mesei tale pentru analiză automată',
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
                  if (_selectedImage != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImage!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_isAnalyzing)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Analizez imaginea cu AI...',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isAnalyzing ? null : _takePicture,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.accent),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Cameră'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isAnalyzing ? null : _pickFromGallery,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.accent),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Galerie'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Manual entry section
            Text(
              'Sau introdu manual:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

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
            const SizedBox(height: 24),

            // Info card
            Card(
              color: AppColors.info.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: AppColors.info,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Folosește camera pentru analiză automată AI sau introdu manual valorile de pe ambalaj.',
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
            const SizedBox(height: 16),
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
