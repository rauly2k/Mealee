import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/food_log_model.dart';
import '../../providers/food_log_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/recipe/nutrition_info.dart';
import 'manual_food_entry_screen.dart';

class FoodLogScreen extends StatefulWidget {
  const FoodLogScreen({super.key});

  @override
  State<FoodLogScreen> createState() => _FoodLogScreenState();
}

class _FoodLogScreenState extends State<FoodLogScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final userProvider = context.read<UserProvider>();
    final foodLogProvider = context.read<FoodLogProvider>();

    if (userProvider.currentUser != null) {
      await foodLogProvider.loadLogsByDate(
        userProvider.currentUser!.userId,
        _selectedDate,
      );
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
      _loadLogs();
    }
  }

  Future<void> _deleteLog(String logId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Șterge înregistrare'),
        content: const Text('Ești sigur că vrei să ștergi această înregistrare?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Șterge',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final foodLogProvider = context.read<FoodLogProvider>();
      await foodLogProvider.deleteLog(logId);
      _loadLogs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jurnal alimentar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
        ],
      ),
      body: Consumer2<UserProvider, FoodLogProvider>(
        builder: (context, userProvider, foodLogProvider, _) {
          if (foodLogProvider.isLoading) {
            return const LoadingIndicator(message: 'Se încarcă jurnalul...');
          }

          if (foodLogProvider.errorMessage != null) {
            return ErrorDisplay(
              message: foodLogProvider.errorMessage!,
              onRetry: _loadLogs,
            );
          }

          if (userProvider.currentUser == null) {
            return const Center(
              child: Text('Nu există utilizator autentificat'),
            );
          }

          final user = userProvider.currentUser!;
          final goals = user.goals;
          final logs = foodLogProvider.todayLogs;
          final nutrition = foodLogProvider.todayNutrition;

          return RefreshIndicator(
            onRefresh: _loadLogs,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date selector
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.event, color: AppColors.primary),
                      title: Text(
                        _isToday(_selectedDate)
                            ? 'Astăzi'
                            : DateFormat('EEEE, d MMMM yyyy', 'ro')
                                .format(_selectedDate),
                      ),
                      trailing: const Icon(Icons.arrow_drop_down),
                      onTap: _selectDate,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nutrition summary
                  if (goals != null) ...[
                    NutritionInfoCard(nutrition: nutrition, compact: false,),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            NutritionProgressBar(
                              label: AppStrings.calories,
                              current: nutrition.calories,
                              target: goals.calorieTarget,
                              color: AppColors.calories,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildMacroProgress(
                                    'P',
                                    nutrition.protein,
                                    goals.proteinTarget,
                                    AppColors.protein,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildMacroProgress(
                                    'C',
                                    nutrition.carbs,
                                    goals.carbsTarget,
                                    AppColors.carbs,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildMacroProgress(
                                    'G',
                                    nutrition.fats,
                                    goals.fatsTarget,
                                    AppColors.fats,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Meals by type
                  _buildMealSection('Micul dejun', 'breakfast', logs),
                  const SizedBox(height: 16),
                  _buildMealSection('Prânz', 'lunch', logs),
                  const SizedBox(height: 16),
                  _buildMealSection('Cină', 'dinner', logs),
                  const SizedBox(height: 16),
                  _buildMealSection('Gustări', 'snacks', logs),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ManualFoodEntryScreen(),
            ),
          );
          if (result == true && mounted) {
            _loadLogs();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMealSection(
    String title,
    String mealType,
    List<FoodLogModel> allLogs,
  ) {
    final mealLogs = allLogs.where((log) => log.mealType == mealType).toList();
    final mealCalories = mealLogs.fold<double>(
      0,
      (sum, log) => sum + log.nutrition.calories,
    );

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: Text(
              Helpers.formatCalories(mealCalories),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.calories,
              ),
            ),
          ),
          if (mealLogs.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Nicio înregistrare',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            )
          else
            ...mealLogs.map((log) => _buildLogItem(log)),
        ],
      ),
    );
  }

  Widget _buildLogItem(FoodLogModel log) {
    String displayName = '';
    String details = '';

    if (log.recipeId != null) {
      displayName = log.recipeName ?? 'Rețetă';
      if (log.portionMultiplier != 1.0) {
        details = 'Porții: ${log.portionMultiplier.toStringAsFixed(1)}x';
      }
    } else if (log.manualEntry != null) {
      displayName = log.manualEntry!.foodName;
      details = log.manualEntry!.portionSize;
    } else if (log.photoUrl != null) {
      displayName = 'Fotografie aliment';
      details = 'Detectat automat';
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: Icon(
          log.recipeId != null
              ? Icons.restaurant_menu
              : log.photoUrl != null
                  ? Icons.photo_camera
                  : Icons.edit,
          color: AppColors.primary,
          size: 20,
        ),
      ),
      title: Text(displayName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (details.isNotEmpty) Text(details),
          Text(
            '${Helpers.formatCalories(log.nutrition.calories)} • P: ${log.nutrition.protein.toStringAsFixed(0)}g • C: ${log.nutrition.carbs.toStringAsFixed(0)}g • G: ${log.nutrition.fats.toStringAsFixed(0)}g',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: AppColors.error),
        onPressed: () => _deleteLog(log.logId),
      ),
    );
  }

  Widget _buildMacroProgress(
    String label,
    double current,
    double target,
    Color color,
  ) {
    final percentage = target > 0 ? (current / target * 100).clamp(0, 100) : 0;
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${current.toStringAsFixed(0)}g',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: color.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
