import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/custom_button.dart';
import 'health_goals_screen.dart';

class ActivityLevelScreen extends StatefulWidget {
  final int age;
  final String gender;
  final double height;
  final double weight;

  const ActivityLevelScreen({
    super.key,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
  });

  @override
  State<ActivityLevelScreen> createState() => _ActivityLevelScreenState();
}

class _ActivityLevelScreenState extends State<ActivityLevelScreen> {
  String _selectedActivityLevel = 'sedentary';

  void _handleNext() {
    // Navigate to next screen with all data
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HealthGoalsScreen(
          age: widget.age,
          gender: widget.gender,
          height: widget.height,
          weight: widget.weight,
          activityLevel: _selectedActivityLevel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStringsRo.activityLevelTitle),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: 0.66,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStringsRo.activityLevelTitle,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStringsRo.activitySubtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 32),
                    // Activity level cards
                    _buildActivityCard(
                      'sedentary',
                      AppStringsRo.sedentaryTitle,
                      AppStringsRo.sedentaryDesc,
                    ),
                    const SizedBox(height: 16),
                    _buildActivityCard(
                      'lightly_active',
                      AppStringsRo.lightActiveTitle,
                      AppStringsRo.lightActiveDesc,
                    ),
                    const SizedBox(height: 16),
                    _buildActivityCard(
                      'moderately_active',
                      AppStringsRo.moderateActiveTitle,
                      AppStringsRo.moderateActiveDesc,
                    ),
                    const SizedBox(height: 16),
                    _buildActivityCard(
                      'very_active',
                      AppStringsRo.veryActiveTitle,
                      AppStringsRo.veryActiveDesc,
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
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(String value, String title, String description) {
    final isSelected = _selectedActivityLevel == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedActivityLevel = value;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryLight.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
