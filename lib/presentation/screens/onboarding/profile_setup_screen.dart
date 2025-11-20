import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import 'activity_level_screen.dart';

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

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _handleNext() async {
    if (_formKey.currentState!.validate()) {
      // Don't save to provider yet - we'll save all data at the end
      // Just navigate to next screen with the data
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ActivityLevelScreen(
              age: int.parse(_ageController.text),
              gender: _selectedGender,
              height: double.parse(_heightController.text),
              weight: double.parse(_weightController.text),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStringsRo.personalInfoTitle),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: 0.33,
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
                        AppStringsRo.personalInfoTitle,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppStringsRo.personalInfoSubtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 32),
                      // Age
                      CustomTextField(
                        controller: _ageController,
                        labelText: AppStringsRo.labelAge,
                        hintText: 'ex: 25',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.cake_outlined,
                        validator: Validators.age,
                      ),
                      const SizedBox(height: 16),
                      // Gender selection
                      Text(
                        AppStringsRo.labelGender,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildGenderOption('male', AppStringsRo.genderMale, Icons.male),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildGenderOption('female', AppStringsRo.genderFemale, Icons.female),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Third option - full width
                      _buildGenderOptionFullWidth('prefer_not_to_say', AppStringsRo.genderPreferNotToSay),
                      const SizedBox(height: 24),
                      // Weight
                      CustomTextField(
                        controller: _weightController,
                        labelText: AppStringsRo.labelWeight,
                        hintText: 'ex: 70',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.monitor_weight_outlined,
                        validator: Validators.weight,
                      ),
                      const SizedBox(height: 16),
                      // Height
                      CustomTextField(
                        controller: _heightController,
                        labelText: AppStringsRo.labelHeight,
                        hintText: 'ex: 175',
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.height,
                        validator: Validators.height,
                      ),
                      const SizedBox(height: 32),
                      // Next button
                      Consumer<UserProvider>(
                        builder: (context, userProvider, _) {
                          return CustomButton(
                            text: AppStringsRo.btnNext,
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
          ],
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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryLight.withValues(alpha: 0.2)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
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

  Widget _buildGenderOptionFullWidth(String value, String label) {
    final isSelected = _selectedGender == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryLight.withValues(alpha: 0.2)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
