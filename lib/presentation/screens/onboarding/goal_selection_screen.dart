import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/custom_button.dart';
import 'dietary_preferences_screen.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  String _selectedGoal = 'weight_loss';

  final List<GoalOption> _goals = [
    GoalOption(
      id: 'weight_loss',
      title: AppStrings.weightLoss,
      description: 'Scade în greutate într-un mod sănătos',
      icon: Icons.trending_down,
      color: AppColors.success,
    ),
    GoalOption(
      id: 'weight_maintenance',
      title: AppStrings.weightMaintenance,
      description: 'Menține greutatea actuală',
      icon: Icons.trending_flat,
      color: AppColors.info,
    ),
    GoalOption(
      id: 'muscle_gain',
      title: AppStrings.muscleGain,
      description: 'Crește masa musculară',
      icon: Icons.fitness_center,
      color: AppColors.warning,
    ),
    GoalOption(
      id: 'general_health',
      title: AppStrings.generalHealth,
      description: 'Îmbunătățește sănătatea generală',
      icon: Icons.favorite,
      color: AppColors.error,
    ),
  ];

  Future<void> _handleNext() async {
    final userProvider = context.read<UserProvider>();

    // Calculate and update goals based on profile and selected goal type
    final success = await userProvider.calculateAndUpdateGoals(_selectedGoal);

    if (mounted) {
      if (success) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const DietaryPreferencesScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              userProvider.errorMessage ?? 'Eroare la calcularea obiectivelor',
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
        title: const Text(AppStrings.selectGoal),
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
                      AppStrings.whatsYourGoal,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vom calcula automat caloriile și macronutrienții necesari pentru a-ți atinge obiectivul',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 32),
                    ...List.generate(
                      _goals.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildGoalOption(_goals[index]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Next button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Consumer<UserProvider>(
                builder: (context, userProvider, _) {
                  return CustomButton(
                    text: AppStrings.next,
                    onPressed: _handleNext,
                    isLoading: userProvider.isLoading,
                    width: double.infinity,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalOption(GoalOption goal) {
    final isSelected = _selectedGoal == goal.id;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedGoal = goal.id;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? goal.color.withValues(alpha: 0.1)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? goal.color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? goal.color
                    : goal.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                goal.icon,
                color: isSelected
                    ? AppColors.textOnPrimary
                    : goal.color,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? goal.color : AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    goal.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: goal.color,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}

class GoalOption {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  GoalOption({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
