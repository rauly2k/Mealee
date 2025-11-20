import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class HealthGoalsScreen extends StatefulWidget {
  final int age;
  final String gender;
  final double height;
  final double weight;
  final String activityLevel;

  const HealthGoalsScreen({
    super.key,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.activityLevel,
  });

  @override
  State<HealthGoalsScreen> createState() => _HealthGoalsScreenState();
}

class _HealthGoalsScreenState extends State<HealthGoalsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _targetWeightController = TextEditingController();

  String _selectedGoal = 'weight_loss';
  String _selectedDietType = 'classic';
  final Set<String> _selectedAllergies = {};

  final List<String> _allergies = [
    'shellfish',
    'fish',
    'gluten',
    'dairy',
    'eggs',
    'peanut',
    'sulfite',
    'mustard',
    'peach',
    'soy',
    'sesame',
    'peppers',
    'mushrooms',
    'nightshade',
  ];

  final Map<String, String> _allergyLabels = {
    'shellfish': 'Shellfish',
    'fish': 'Fish',
    'gluten': 'Gluten',
    'dairy': 'Dairy',
    'eggs': 'Eggs',
    'peanut': 'Peanut',
    'sulfite': 'Sulfite',
    'mustard': 'Mustard',
    'peach': 'Peach',
    'soy': 'Soy',
    'sesame': 'Sesame',
    'peppers': 'Peppers',
    'mushrooms': 'Mushrooms',
    'nightshade': 'Nightshade',
  };

  @override
  void dispose() {
    _targetWeightController.dispose();
    super.dispose();
  }

  Future<void> _handleFinish() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final userProvider = context.read<UserProvider>();

    try {
      // 1. Save profile
      final profile = UserProfile(
        age: widget.age,
        gender: widget.gender,
        height: widget.height,
        weight: widget.weight,
        activityLevel: widget.activityLevel,
      );

      final profileSuccess = await userProvider.updateProfile(profile);
      if (!profileSuccess) {
        throw Exception('Failed to update profile');
      }

      // 2. Calculate and update goals with target weight
      final targetWeight = _targetWeightController.text.isNotEmpty
          ? double.parse(_targetWeightController.text)
          : null;

      final goalsSuccess = await userProvider.calculateAndUpdateGoals(
        _selectedGoal,
        targetWeight: targetWeight,
      );

      if (!goalsSuccess) {
        throw Exception('Failed to calculate goals');
      }

      // 3. Save preferences (diet type and allergies)
      final preferences = UserPreferences(
        dietType: _selectedDietType,
        allergies: _selectedAllergies.toList(),
      );

      final preferencesSuccess = await userProvider.updatePreferences(preferences);
      if (!preferencesSuccess) {
        throw Exception('Failed to update preferences');
      }

      // 4. Navigate back to first route (completing onboarding)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profilul a fost configurat cu succes!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              userProvider.errorMessage ?? 'Eroare la salvarea datelor',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStringsRo.healthGoalsTitle),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: 1.0,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStringsRo.healthGoalsTitle,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppStringsRo.goalsSubtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 32),
                      // Section 1: Health Goals
                      Text(
                        AppStringsRo.sectionGoals,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildGoalChip('weight_loss', AppStringsRo.goalWeightLoss),
                          _buildGoalChip('weight_maintenance', AppStringsRo.goalMaintenance),
                          _buildGoalChip('muscle_gain', AppStringsRo.goalMuscle),
                          _buildGoalChip('general_health', AppStringsRo.goalGeneralHealth),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Section 2: Target Weight
                      Text(
                        AppStringsRo.sectionTargetWeight,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _targetWeightController,
                        labelText: AppStringsRo.hintTargetWeight,
                        hintText: 'ex: 65',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.flag_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // Optional field
                          }
                          final weight = double.tryParse(value);
                          if (weight == null) {
                            return 'Introdu o greutate validă';
                          }
                          // Validate that target weight is realistic
                          final difference = (weight - widget.weight).abs();
                          if (difference > 50) {
                            return 'Diferența față de greutatea actuală este prea mare';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      // Section 3: Dietary Type
                      Text(
                        AppStringsRo.sectionDiet,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 12),
                      // 2-column grid
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 3,
                        children: [
                          _buildDietTypeOption('classic', AppStringsRo.dietClassic),
                          _buildDietTypeOption('low_carb', AppStringsRo.dietLowCarb),
                          _buildDietTypeOption('keto', AppStringsRo.dietKeto),
                          _buildDietTypeOption('vegan', AppStringsRo.dietVegan),
                          _buildDietTypeOption('paleo', AppStringsRo.dietPaleo),
                          _buildDietTypeOption('vegetarian', AppStringsRo.dietVegetarian),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Section 4: Allergies
                      Text(
                        AppStringsRo.sectionAllergies,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _allergies.map((allergy) {
                          final isSelected = _selectedAllergies.contains(allergy);
                          return FilterChip(
                            label: Text(_allergyLabels[allergy] ?? allergy),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedAllergies.add(allergy);
                                } else {
                                  _selectedAllergies.remove(allergy);
                                }
                              });
                            },
                            backgroundColor: Colors.white,
                            selectedColor: Colors.black,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                            checkmarkColor: Colors.white,
                            side: BorderSide(
                              color: isSelected ? Colors.black : Colors.grey.shade300,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                      // Finish button
                      Consumer<UserProvider>(
                        builder: (context, userProvider, _) {
                          return CustomButton(
                            text: AppStringsRo.btnFinish,
                            onPressed: _handleFinish,
                            isLoading: userProvider.isLoading,
                            width: double.infinity,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalChip(String value, String label) {
    final isSelected = _selectedGoal == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedGoal = value;
        });
      },
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildDietTypeOption(String value, String label) {
    final isSelected = _selectedDietType == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedDietType = value;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryLight.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              size: 20,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
