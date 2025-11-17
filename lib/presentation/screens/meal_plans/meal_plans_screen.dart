import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/helpers.dart';
import '../../providers/meal_plan_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import 'meal_plan_detail_screen.dart';

class MealPlansScreen extends StatefulWidget {
  const MealPlansScreen({super.key});

  @override
  State<MealPlansScreen> createState() => _MealPlansScreenState();
}

class _MealPlansScreenState extends State<MealPlansScreen> {
  @override
  void initState() {
    super.initState();
    _loadMealPlans();
  }

  Future<void> _loadMealPlans() async {
    final userProvider = context.read<UserProvider>();
    final mealPlanProvider = context.read<MealPlanProvider>();

    if (userProvider.currentUser != null) {
      await mealPlanProvider.loadMealPlans(userProvider.currentUser!.userId);
      await mealPlanProvider
          .loadCurrentWeekPlan(userProvider.currentUser!.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.mealPlans),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to create meal plan
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Generarea de planuri va fi disponibilă în curând!'),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer2<UserProvider, MealPlanProvider>(
        builder: (context, userProvider, mealPlanProvider, _) {
          if (mealPlanProvider.isLoading) {
            return const LoadingIndicator(
                message: 'Se încarcă planurile de mese...');
          }

          if (mealPlanProvider.errorMessage != null) {
            return ErrorDisplay(
              message: mealPlanProvider.errorMessage!,
              onRetry: _loadMealPlans,
            );
          }

          if (userProvider.currentUser == null) {
            return const Center(
              child: Text('Nu există utilizator autentificat'),
            );
          }

          final currentWeekPlan = mealPlanProvider.currentWeekPlan;
          final allPlans = mealPlanProvider.mealPlans;

          return RefreshIndicator(
            onRefresh: _loadMealPlans,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current week plan
                  if (currentWeekPlan != null) ...[
                    Text(
                      'Plan săptămâna aceasta',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    _buildCurrentWeekPlanCard(currentWeekPlan),
                    const SizedBox(height: 24),
                  ],

                  // All plans
                  if (allPlans.isNotEmpty) ...[
                    Text(
                      'Toate planurile',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    ...allPlans.map((plan) => _buildMealPlanCard(plan)),
                  ],

                  // Empty state
                  if (currentWeekPlan == null && allPlans.isEmpty) ...[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 80,
                              color: AppColors.textLight,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Niciun plan de mese',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Creează primul tău plan săptămânal de mese pentru a te organiza mai bine',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Navigate to create meal plan
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Generarea de planuri va fi disponibilă în curând!'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text(AppStrings.generateMealPlan),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentWeekPlanCard(plan) {
    final totalCalories = _calculateTotalCalories(plan);

    return Card(
      elevation: 4,
      color: AppColors.primary.withValues(alpha: 0.05),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MealPlanDetailScreen(mealPlan: plan),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.calendar_today,
                      color: AppColors.textOnPrimary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          '${DateFormat('d MMM', 'ro').format(plan.startDate)} - ${DateFormat('d MMM', 'ro').format(plan.endDate)}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    '${plan.days.length}',
                    'zile',
                    Icons.date_range,
                  ),
                  _buildStatItem(
                    '${_calculateTotalMeals(plan)}',
                    'mese',
                    Icons.restaurant_menu,
                  ),
                  _buildStatItem(
                    Helpers.formatCalories(totalCalories / plan.days.length),
                    'calorii/zi',
                    Icons.local_fire_department,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealPlanCard(plan) {
    final isActive = _isPlanActive(plan);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MealPlanDetailScreen(mealPlan: plan),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_month,
                  color: isActive ? AppColors.success : AppColors.textSecondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            plan.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        if (isActive)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Activ',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textOnPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${DateFormat('d MMM', 'ro').format(plan.startDate)} - ${DateFormat('d MMM', 'ro').format(plan.endDate)} • ${plan.days.length} zile',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  double _calculateTotalCalories(plan) {
    double total = 0;
    for (final day in plan.days) {
      for (final meal in day.meals) {
        total += meal.nutrition.calories;
      }
    }
    return total;
  }

  int _calculateTotalMeals(plan) {
    int total = 0;
    for (final day in plan.days) {
      total += day.meals.length as int;
    }
    return total;
  }

  bool _isPlanActive(plan) {
    final now = DateTime.now();
    return now.isAfter(plan.startDate.subtract(const Duration(days: 1))) &&
        now.isBefore(plan.endDate.add(const Duration(days: 1)));
  }
}
