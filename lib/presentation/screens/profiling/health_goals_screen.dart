import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/profile_data.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../widgets/auth/custom_auth_button.dart';
import '../../widgets/auth/custom_auth_text_field.dart';
import 'profile_complete_screen.dart';

/// Page 3/3 of user profiling flow
/// Collects: Health Goal, Target Weight, Diet Type, Allergies, Preferred Foods
class HealthGoalsScreen extends StatefulWidget {
  final int age;
  final String gender;
  final double weight;
  final double height;
  final String activityLevel;

  const HealthGoalsScreen({
    super.key,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.activityLevel,
  });

  @override
  State<HealthGoalsScreen> createState() => _HealthGoalsScreenState();
}

class _HealthGoalsScreenState extends State<HealthGoalsScreen> {
  final _targetWeightController = TextEditingController();
  String _selectedGoal = 'weight_loss';
  String _selectedDietType = 'classic';
  final Set<String> _selectedAllergies = {};
  final Set<String> _selectedPreferredFoods = {};

  bool _isLoading = false;

  @override
  void dispose() {
    _targetWeightController.dispose();
    super.dispose();
  }

  Future<void> _handleFinish() async {
    setState(() => _isLoading = true);

    try {
      final userProvider = context.read<UserProvider>();

      // Create UserProfile
      final profile = UserProfile(
        age: widget.age,
        gender: widget.gender,
        height: widget.height,
        weight: widget.weight,
        activityLevel: widget.activityLevel,
      );

      // Create UserPreferences
      final preferences = UserPreferences(
        dietType: _selectedDietType,
        allergies: _selectedAllergies.toList(),
        preferredFoods: _selectedPreferredFoods.toList(),
      );

      // Parse target weight
      final targetWeight = _targetWeightController.text.trim().isNotEmpty
          ? double.tryParse(_targetWeightController.text)
          : null;

      // Update profile
      await userProvider.updateProfile(profile);

      // Update preferences
      await userProvider.updatePreferences(preferences);

      // Calculate and update goals with target weight
      await userProvider.calculateAndUpdateGoals(
        _selectedGoal,
        targetWeight: targetWeight,
      );

      if (mounted) {
        setState(() => _isLoading = false);

        // Navigate to confirmation screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ProfileCompleteScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            _buildProgressBar(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Health Goals',
                      style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      'Set your health goals and preferences to get personalized meal recommendations.',
                      style: GoogleFonts.dmSans(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Health Goal Selection
                    _buildSectionTitle('Select Your Goal'),
                    const SizedBox(height: 16),
                    ...ProfileData.healthGoals.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildGoalCard(
                          entry.key,
                          entry.value['label']!,
                          entry.value['description']!,
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    // Target Weight (Optional)
                    _buildSectionTitle('Target Weight (Optional)'),
                    const SizedBox(height: 12),
                    CustomAuthTextField(
                      controller: _targetWeightController,
                      hintText: 'Target weight in kg',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return null;
                        final weight = double.tryParse(value);
                        if (weight == null) return 'Please enter a valid number';
                        if (weight < ProfileData.minTargetWeight ||
                            weight > ProfileData.maxTargetWeight) {
                          return 'Weight must be between ${ProfileData.minTargetWeight} and ${ProfileData.maxTargetWeight} kg';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Diet Type
                    _buildSectionTitle('Diet Type'),
                    const SizedBox(height: 12),
                    _buildDietTypeDropdown(),

                    const SizedBox(height: 24),

                    // Allergies
                    _buildSectionTitle('Allergies (Select all that apply)'),
                    const SizedBox(height: 12),
                    _buildChipGroup(
                      ProfileData.allergies,
                      _selectedAllergies,
                      AppColors.error,
                    ),

                    const SizedBox(height: 24),

                    // Preferred Foods
                    _buildSectionTitle('Preferred Foods'),
                    const SizedBox(height: 12),
                    ...ProfileData.preferredFoodsGrouped.entries.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildPreferredFoodCategory(
                          ProfileData.preferredFoodCategories[category.key]!,
                          category.value,
                        ),
                      );
                    }),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Finish Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: CustomAuthButton(
                text: 'Finish',
                onPressed: _handleFinish,
                isLoading: _isLoading,
                type: AuthButtonType.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Page 3/3',
            style: GoogleFonts.poppins(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 1.0,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildGoalCard(String value, String label, String description) {
    final isSelected = _selectedGoal == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedGoal = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
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
              groupValue: _selectedGoal,
              onChanged: (newValue) {
                setState(() {
                  _selectedGoal = newValue!;
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
                    style: GoogleFonts.poppins(
                      color:
                          isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.dmSans(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietTypeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: DropdownButton<String>(
        value: _selectedDietType,
        isExpanded: true,
        underline: const SizedBox(),
        style: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        items: ProfileData.dietTypes.entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  entry.value['label']!,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  entry.value['description']!,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _selectedDietType = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildChipGroup(
    Map<String, String> items,
    Set<String> selectedItems,
    Color accentColor,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.entries.map((entry) {
        final isSelected = selectedItems.contains(entry.key);
        return FilterChip(
          label: Text(entry.value),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                selectedItems.add(entry.key);
              } else {
                selectedItems.remove(entry.key);
              }
            });
          },
          selectedColor: accentColor.withOpacity(0.2),
          checkmarkColor: accentColor,
          backgroundColor: AppColors.surfaceVariant,
          labelStyle: GoogleFonts.poppins(
            color: isSelected ? accentColor : AppColors.textPrimary,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPreferredFoodCategory(
      String categoryLabel, Map<String, String> foods) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          categoryLabel,
          style: GoogleFonts.poppins(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        _buildChipGroup(
          foods,
          _selectedPreferredFoods,
          AppColors.primary,
        ),
      ],
    );
  }
}
