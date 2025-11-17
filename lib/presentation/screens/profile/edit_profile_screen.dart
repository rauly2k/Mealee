import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  String _selectedGender = 'male';
  String _selectedActivityLevel = 'moderate';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final userProvider = context.read<UserProvider>();
    final user = userProvider.currentUser;

    if (user != null) {
      _displayNameController.text = user.displayName;

      if (user.profile != null) {
        _ageController.text = user.profile!.age.toString();
        _heightController.text = user.profile!.height.toStringAsFixed(0);
        _weightController.text = user.profile!.weight.toStringAsFixed(1);
        _selectedGender = user.profile!.gender;
        _selectedActivityLevel = user.profile!.activityLevel;
      }
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userProvider = context.read<UserProvider>();
      final currentUser = userProvider.currentUser;

      if (currentUser == null) {
        throw Exception('Nu există utilizator autentificat');
      }

      // Update display name
      await userProvider.updateDisplayName(_displayNameController.text.trim());

      // Update profile
      final updatedProfile = UserProfile(
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        activityLevel: _selectedActivityLevel,
      );

      await userProvider.updateProfile(updatedProfile);

      // Recalculate goals based on new profile
      if (currentUser.goals != null) {
        await userProvider.calculateAndUpdateGoals(currentUser.goals!.goalType);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profilul a fost actualizat cu succes!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
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
        title: const Text(AppStrings.editProfile),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Display name
            CustomTextField(
              controller: _displayNameController,
              label: 'Nume',
              hint: 'Numele tău',
              prefixIcon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Numele este obligatoriu';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Profile information header
            Text(
              'Informații profil',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),

            // Age
            CustomTextField(
              controller: _ageController,
              label: 'Vârstă',
              hint: '25',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: Validators.age,
            ),
            const SizedBox(height: 16),

            // Gender selector
            Text(
              'Gen',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildGenderButton('male', 'Masculin', Icons.male),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildGenderButton('female', 'Feminin', Icons.female),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Height
            CustomTextField(
              controller: _heightController,
              label: 'Înălțime (cm)',
              hint: '170',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
              ],
              validator: Validators.height,
            ),
            const SizedBox(height: 16),

            // Weight
            CustomTextField(
              controller: _weightController,
              label: 'Greutate (kg)',
              hint: '70.5',
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
              ],
              validator: Validators.weight,
            ),
            const SizedBox(height: 24),

            // Activity level
            Text(
              'Nivel de activitate',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            _buildActivityLevelSelector(),
            const SizedBox(height: 32),

            // Info card
            Card(
              color: AppColors.info.withOpacity(0.1),
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
                        'Modificarea acestor date va recalcula obiectivele tale nutriționale.',
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
              text: AppStrings.save,
              onPressed: _isLoading ? null : _saveProfile,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderButton(String value, String label, IconData icon) {
    final isSelected = _selectedGender == value;
    return InkWell(
      onTap: () {
        setState(() => _selectedGender = value);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
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
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityLevelSelector() {
    final activities = {
      'sedentary': {
        'label': 'Sedentar',
        'description': 'Puțină sau deloc exerciții',
      },
      'light': {
        'label': 'Ușor activ',
        'description': 'Exerciții ușoare 1-3 zile/săptămână',
      },
      'moderate': {
        'label': 'Moderat activ',
        'description': 'Exerciții moderate 3-5 zile/săptămână',
      },
      'very': {
        'label': 'Foarte activ',
        'description': 'Exerciții intense 6-7 zile/săptămână',
      },
      'extra': {
        'label': 'Extrem de activ',
        'description': 'Exerciții fizice foarte intense zilnic',
      },
    };

    return Column(
      children: activities.entries.map((entry) {
        final isSelected = _selectedActivityLevel == entry.key;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.1)
                : AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: RadioListTile<String>(
            value: entry.key,
            groupValue: _selectedActivityLevel,
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedActivityLevel = value);
              }
            },
            title: Text(
              entry.value['label']!,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              entry.value['description']!,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            activeColor: AppColors.primary,
          ),
        );
      }).toList(),
    );
  }
}
