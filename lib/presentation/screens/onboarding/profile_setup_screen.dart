import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import 'goal_selection_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  String _selectedGender = 'male';
  String _selectedActivityLevel = 'sedentary';

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _handleNext() async {
    if (_formKey.currentState!.validate()) {
      final profile = UserProfile(
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        activityLevel: _selectedActivityLevel,
      );

      final userProvider = context.read<UserProvider>();
      final success = await userProvider.updateProfile(profile);

      if (mounted) {
        if (success) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const GoalSelectionScreen(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                userProvider.errorMessage ?? 'Eroare la salvarea profilului',
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.setupProfile),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.tellUsAboutYou,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vom folosi aceste informații pentru a calcula obiectivele tale nutriționale',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 32),
                // Gender selection
                Text(
                  AppStrings.gender,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildGenderOption('male', AppStrings.male, Icons.male),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGenderOption('female', AppStrings.female, Icons.female),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Age
                CustomTextField(
                  controller: _ageController,
                  labelText: AppStrings.age,
                  hintText: 'ex: 25',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.cake_outlined,
                  validator: Validators.age,
                ),
                const SizedBox(height: 16),
                // Height
                CustomTextField(
                  controller: _heightController,
                  labelText: '${AppStrings.height} (cm)',
                  hintText: 'ex: 175',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.height,
                  validator: Validators.height,
                ),
                const SizedBox(height: 16),
                // Weight
                CustomTextField(
                  controller: _weightController,
                  labelText: '${AppStrings.weight} (kg)',
                  hintText: 'ex: 70',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.monitor_weight_outlined,
                  validator: Validators.weight,
                ),
                const SizedBox(height: 24),
                // Activity level
                Text(
                  AppStrings.activityLevel,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                _buildActivityLevelOption(
                  'sedentary',
                  AppStrings.sedentary,
                  'Puțin sau deloc exerciții',
                ),
                _buildActivityLevelOption(
                  'lightly_active',
                  AppStrings.lightlyActive,
                  'Exerciții ușoare 1-3 zile/săptămână',
                ),
                _buildActivityLevelOption(
                  'moderately_active',
                  AppStrings.moderatelyActive,
                  'Exerciții moderate 3-5 zile/săptămână',
                ),
                _buildActivityLevelOption(
                  'very_active',
                  AppStrings.veryActive,
                  'Exerciții intense 6-7 zile/săptămână',
                ),
                const SizedBox(height: 32),
                // Next button
                Consumer<UserProvider>(
                  builder: (context, userProvider, _) {
                    return CustomButton(
                      text: AppStrings.next,
                      onPressed: _handleNext,
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
    );
  }

  Widget _buildGenderOption(String value, String label, IconData icon) {
    final isSelected = _selectedGender == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryLight.withOpacity(0.2)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityLevelOption(String value, String label, String description) {
    final isSelected = _selectedActivityLevel == value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedActivityLevel = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryLight.withOpacity(0.2)
                : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Radio<String>(
                value: value,
                groupValue: _selectedActivityLevel,
                onChanged: (newValue) {
                  setState(() {
                    _selectedActivityLevel = newValue!;
                  });
                },
                activeColor: AppColors.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
