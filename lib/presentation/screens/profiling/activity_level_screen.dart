import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/profile_data.dart';
import '../../widgets/auth/custom_auth_button.dart';
import 'health_goals_screen.dart';

/// Page 2/3 of user profiling flow
/// Collects: Activity Level (single selection)
class ActivityLevelScreen extends StatefulWidget {
  final int age;
  final String gender;
  final double weight;
  final double height;

  const ActivityLevelScreen({
    super.key,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
  });

  @override
  State<ActivityLevelScreen> createState() => _ActivityLevelScreenState();
}

class _ActivityLevelScreenState extends State<ActivityLevelScreen> {
  String _selectedActivityLevel = 'sedentary';

  void _handleNext() {
    // Pass all collected data to next screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HealthGoalsScreen(
          age: widget.age,
          gender: widget.gender,
          weight: widget.weight,
          height: widget.height,
          activityLevel: _selectedActivityLevel,
        ),
      ),
    );
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
                      'Activity Level',
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
                      'Choose your typical activity level to help us calculate your daily calorie needs.',
                      style: GoogleFonts.dmSans(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Activity level options
                    ...ProfileData.activityLevels.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildActivityLevelOption(
                          entry.key,
                          entry.value['label']!,
                          entry.value['description']!,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Next Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: CustomAuthButton(
                text: 'Next',
                onPressed: _handleNext,
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
            'Page 2/3',
            style: GoogleFonts.poppins(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 2 / 3,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLevelOption(
      String value, String label, String description) {
    final isSelected = _selectedActivityLevel == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedActivityLevel = value;
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
                    style: GoogleFonts.poppins(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
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
}
