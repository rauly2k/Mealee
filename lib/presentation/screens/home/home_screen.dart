import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/helpers.dart';
import '../../providers/user_provider.dart';
import '../../providers/food_log_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/recipe/nutrition_info.dart';
import '../food_log/manual_food_entry_screen.dart';
import '../food_log/food_log_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Schedule data loading after the first frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadData();
      }
    });
  }

  Future<void> _loadData() async {
    final userProvider = context.read<UserProvider>();
    final foodLogProvider = context.read<FoodLogProvider>();

    await userProvider.loadCurrentUser();

    if (userProvider.currentUser != null) {
      await foodLogProvider.loadTodayLogs(userProvider.currentUser!.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Consumer2<UserProvider, FoodLogProvider>(
          builder: (context, userProvider, foodLogProvider, _) {
            if (userProvider.isLoading || foodLogProvider.isLoading) {
              return const LoadingIndicator(message: 'Se încarcă...');
            }

            if (userProvider.currentUser == null) {
              return const Center(
                child: Text('Nu există utilizator autentificat'),
              );
            }

            final user = userProvider.currentUser!;
            final todayNutrition = foodLogProvider.todayNutrition;
            final goals = user.goals;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome message
                  Text(
                    'Bine ai venit, ${user.displayName}!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Helpers.formatDate(DateTime.now(), pattern: 'EEEE, d MMMM yyyy'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 24),

                  // Nutrition summary card
                  if (goals != null) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.todaysNutrition,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            // Calories
                            NutritionProgressBar(
                              label: AppStrings.calories,
                              current: todayNutrition.calories,
                              target: goals.calorieTarget,
                              color: AppColors.calories,
                            ),
                            const SizedBox(height: 16),
                            // Protein
                            NutritionProgressBar(
                              label: AppStrings.protein,
                              current: todayNutrition.protein,
                              target: goals.proteinTarget,
                              color: AppColors.protein,
                            ),
                            const SizedBox(height: 16),
                            // Carbs
                            NutritionProgressBar(
                              label: AppStrings.carbs,
                              current: todayNutrition.carbs,
                              target: goals.carbsTarget,
                              color: AppColors.carbs,
                            ),
                            const SizedBox(height: 16),
                            // Fats
                            NutritionProgressBar(
                              label: AppStrings.fats,
                              current: todayNutrition.fats,
                              target: goals.fatsTarget,
                              color: AppColors.fats,
                            ),
                            const SizedBox(height: 12),
                            // View full log button
                            Center(
                              child: TextButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const FoodLogScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.history, size: 18),
                                label: const Text('Vezi jurnalul complet'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Quick actions
                  Text(
                    AppStrings.quickActions,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickAction(
                          context,
                          icon: Icons.add_circle_outline,
                          label: AppStrings.logMeal,
                          color: AppColors.primary,
                          onTap: () async {
                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ManualFoodEntryScreen(),
                              ),
                            );
                            // Reload data if a log was added
                            if (result == true && context.mounted) {
                              _loadData();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickAction(
                          context,
                          icon: Icons.camera_alt_outlined,
                          label: AppStrings.scanIngredient,
                          color: AppColors.secondary,
                          onTap: () {
                            // TODO: Navigate to scan ingredient
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickAction(
                          context,
                          icon: Icons.restaurant_menu,
                          label: 'Găsește rețete',
                          color: AppColors.accent,
                          onTap: () {
                            // TODO: Navigate to recipes
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickAction(
                          context,
                          icon: Icons.shopping_cart_outlined,
                          label: 'Listă cumpărături',
                          color: AppColors.warning,
                          onTap: () {
                            // TODO: Navigate to shopping list
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Today's meal plan (placeholder)
                  Text(
                    AppStrings.todaysMealPlan,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 48,
                              color: AppColors.textLight,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Nu ai un plan de mese pentru azi',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                // TODO: Navigate to create meal plan
                              },
                              child: const Text('Creează plan de mese'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
