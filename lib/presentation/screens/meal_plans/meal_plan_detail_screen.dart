import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/meal_plan_model.dart';
import '../../widgets/recipe/nutrition_info.dart';
import '../recipes/recipe_detail_screen.dart';

class MealPlanDetailScreen extends StatefulWidget {
  final MealPlanModel mealPlan;

  const MealPlanDetailScreen({
    super.key,
    required this.mealPlan,
  });

  @override
  State<MealPlanDetailScreen> createState() => _MealPlanDetailScreenState();
}

class _MealPlanDetailScreenState extends State<MealPlanDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentDayIndex = 0;

  @override
  void initState() {
    super.initState();
    // Find today's index in the meal plan
    _currentDayIndex = _findTodayIndex();
    _tabController = TabController(
      length: widget.mealPlan.days.length,
      vsync: this,
      initialIndex: _currentDayIndex,
    );
  }

  int _findTodayIndex() {
    final today = DateTime.now();
    final daysDiff = today.difference(widget.mealPlan.startDate).inDays;
    if (daysDiff >= 0 && daysDiff < widget.mealPlan.days.length) {
      return daysDiff;
    }
    return 0;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mealPlan.name),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: widget.mealPlan.days.asMap().entries.map((entry) {
            final index = entry.key;
            final day = entry.value;
            final date = widget.mealPlan.startDate.add(Duration(days: index));
            final isToday = _isToday(date);

            return Tab(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    day.dayName,
                    style: TextStyle(
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isToday ? AppColors.primary : null,
                    ),
                  ),
                  Text(
                    DateFormat('d MMM', 'ro').format(date),
                    style: TextStyle(
                      fontSize: 11,
                      color: isToday
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: widget.mealPlan.days.map((day) {
          return _buildDayView(day);
        }).toList(),
      ),
    );
  }

  Widget _buildDayView(DayMealPlan day) {
    final dayCalories = _calculateDayCalories(day);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day summary card
          Card(
            color: AppColors.primary.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day.dayName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${day.meals.length} mese',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Helpers.formatCalories(dayCalories),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.calories,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total calorii',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Day notes
          if (day.notes.isNotEmpty) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.note_outlined,
                      color: AppColors.info,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        day.notes,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Meals
          ...day.meals.map((meal) => _buildMealCard(meal)),
        ],
      ),
    );
  }

  Widget _buildMealCard(MealInfo meal) {
    final mealTypeInfo = _getMealTypeInfo(meal.mealType);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Meal header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: mealTypeInfo['color'].withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  mealTypeInfo['icon'],
                  color: mealTypeInfo['color'],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  mealTypeInfo['label'],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: mealTypeInfo['color'],
                  ),
                ),
                if (meal.time.isNotEmpty) ...[
                  const Spacer(),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    meal.time,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Recipe/Food info
          InkWell(
            onTap: meal.recipeId != null
                ? () {
                    // TODO: Navigate to recipe detail
                    // Need to fetch recipe first
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (meal.imageUrl != null && meal.imageUrl!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            meal.imageUrl!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,
                                height: 60,
                                color: AppColors.backgroundLight,
                                child: const Icon(Icons.restaurant_menu),
                              );
                            },
                          ),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meal.recipeName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            if (meal.servings > 0) ...[
                              const SizedBox(height: 4),
                              Text(
                                '${meal.servings} ${meal.servings == 1 ? "porție" : "porții"}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (meal.recipeId != null)
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.textSecondary,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Nutrition info
                  NutritionInfoCard(
                    nutrition: meal.nutrition,
                    compact: true,
                  ),

                  // Notes
                  if (meal.notes.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.note_outlined,
                            size: 16,
                            color: AppColors.info,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              meal.notes,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getMealTypeInfo(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return {
          'label': 'Micul dejun',
          'icon': Icons.free_breakfast,
          'color': AppColors.warning,
        };
      case 'lunch':
        return {
          'label': 'Prânz',
          'icon': Icons.lunch_dining,
          'color': AppColors.success,
        };
      case 'dinner':
        return {
          'label': 'Cină',
          'icon': Icons.dinner_dining,
          'color': AppColors.primary,
        };
      case 'snacks':
        return {
          'label': 'Gustări',
          'icon': Icons.cookie,
          'color': AppColors.secondary,
        };
      default:
        return {
          'label': mealType,
          'icon': Icons.restaurant,
          'color': AppColors.accent,
        };
    }
  }

  double _calculateDayCalories(DayMealPlan day) {
    return day.meals.fold<double>(
      0,
      (sum, meal) => sum + meal.nutrition.calories,
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
