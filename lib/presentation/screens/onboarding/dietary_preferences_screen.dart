import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/custom_button.dart';

class DietaryPreferencesScreen extends StatefulWidget {
  const DietaryPreferencesScreen({super.key});

  @override
  State<DietaryPreferencesScreen> createState() =>
      _DietaryPreferencesScreenState();
}

class _DietaryPreferencesScreenState extends State<DietaryPreferencesScreen> {
  final Set<String> _selectedRestrictions = {};
  final Set<String> _selectedAllergies = {};

  final List<String> _dietaryRestrictions = [
    'vegetarian',
    'vegan',
    'gluten_free',
    'dairy_free',
    'keto',
    'low_carb',
  ];

  final List<String> _commonAllergies = [
    'nuts',
    'dairy',
    'eggs',
    'fish',
    'shellfish',
    'soy',
    'wheat',
  ];

  final Map<String, String> _restrictionLabels = {
    'vegetarian': 'Vegetarian',
    'vegan': 'Vegan',
    'gluten_free': 'Fără gluten',
    'dairy_free': 'Fără lactate',
    'keto': 'Keto',
    'low_carb': 'Low-carb',
  };

  final Map<String, String> _allergyLabels = {
    'nuts': 'Nuci',
    'dairy': 'Lactate',
    'eggs': 'Ouă',
    'fish': 'Pește',
    'shellfish': 'Fructe de mare',
    'soy': 'Soia',
    'wheat': 'Grâu',
  };

  Future<void> _handleFinish() async {
    final preferences = UserPreferences(
      dietaryRestrictions: _selectedRestrictions.toList(),
      allergies: _selectedAllergies.toList(),
    );

    final userProvider = context.read<UserProvider>();
    final success = await userProvider.updatePreferences(preferences);

    if (mounted) {
      if (success) {
        // TODO: Navigate to main app
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profilul a fost configurat cu succes!'),
            backgroundColor: AppColors.success,
          ),
        );
        // For now, just pop back
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              userProvider.errorMessage ?? 'Eroare la salvarea preferințelor',
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
        title: const Text(AppStrings.dietaryPreferences),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.anyRestrictions,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selectează restricțiile alimentare și alergiile tale pentru recomandări personalizate',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 32),
                    // Dietary restrictions
                    Text(
                      'Restricții alimentare',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _dietaryRestrictions.map((restriction) {
                        final isSelected = _selectedRestrictions.contains(restriction);
                        return FilterChip(
                          label: Text(_restrictionLabels[restriction] ?? restriction),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedRestrictions.add(restriction);
                              } else {
                                _selectedRestrictions.remove(restriction);
                              }
                            });
                          },
                          selectedColor: AppColors.primaryLight.withValues(alpha: 0.3),
                          checkmarkColor: AppColors.primary,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    // Allergies
                    Text(
                      'Alergii alimentare',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _commonAllergies.map((allergy) {
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
                          selectedColor: AppColors.error.withValues(alpha: 0.2),
                          checkmarkColor: AppColors.error,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.info,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Poți sări acest pas și să configurezi preferințele mai târziu din setări',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Buttons
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Consumer<UserProvider>(
                    builder: (context, userProvider, _) {
                      return CustomButton(
                        text: AppStrings.finish,
                        onPressed: _handleFinish,
                        isLoading: userProvider.isLoading,
                        width: double.infinity,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomTextButton(
                    text: AppStrings.skip,
                    onPressed: () async {
                      // Save empty preferences
                      final preferences = const UserPreferences();
                      final userProvider = context.read<UserProvider>();
                      await userProvider.updatePreferences(preferences);
                      if (context.mounted) {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
