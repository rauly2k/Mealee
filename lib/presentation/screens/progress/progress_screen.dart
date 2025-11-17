import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/helpers.dart';
import '../../providers/user_provider.dart';
import '../../providers/food_log_provider.dart';
import '../../widgets/common/loading_indicator.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String _selectedPeriod = '7days';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final userProvider = context.read<UserProvider>();
    final foodLogProvider = context.read<FoodLogProvider>();

    if (userProvider.currentUser != null) {
      await foodLogProvider.loadTodayLogs(userProvider.currentUser!.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.progress),
        actions: [
          PopupMenuButton<String>(
            initialValue: _selectedPeriod,
            onSelected: (value) {
              setState(() => _selectedPeriod = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: '7days',
                child: Text('Ultimele 7 zile'),
              ),
              const PopupMenuItem(
                value: '30days',
                child: Text('Ultimele 30 de zile'),
              ),
              const PopupMenuItem(
                value: '90days',
                child: Text('Ultimele 90 de zile'),
              ),
              const PopupMenuItem(
                value: 'all',
                child: Text('Tot timpul'),
              ),
            ],
          ),
        ],
      ),
      body: Consumer2<UserProvider, FoodLogProvider>(
        builder: (context, userProvider, foodLogProvider, _) {
          if (userProvider.isLoading) {
            return const LoadingIndicator(message: 'Se încarcă progresul...');
          }

          if (userProvider.currentUser == null) {
            return const Center(
              child: Text('Nu există utilizator autentificat'),
            );
          }

          final user = userProvider.currentUser!;
          final goals = user.goals;

          return RefreshIndicator(
            onRefresh: _loadData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Greutate curentă',
                          '${user.profile?.weight.toStringAsFixed(1) ?? "N/A"} kg',
                          Icons.monitor_weight,
                          AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'IMC',
                          user.profile != null
                              ? Helpers.calculateBMI(
                                  user.profile!.weight,
                                  user.profile!.height,
                                ).toStringAsFixed(1)
                              : 'N/A',
                          Icons.straighten,
                          AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Weight progress section
                  _buildSectionHeader('Progres greutate'),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.show_chart,
                                    size: 48,
                                    color: AppColors.textLight,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Grafic în curând',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Înregistrează greutatea pentru a vedea progresul',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Navigate to weight logging
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Funcție disponibilă în curând'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Înregistrează greutatea'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Nutrition trends
                  _buildSectionHeader('Tendințe nutriționale'),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Medie zilnică - ${_getPeriodLabel()}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                          const SizedBox(height: 16),
                          _buildNutrientBar(
                            'Calorii',
                            0,
                            goals?.calorieTarget ?? 2000,
                            AppColors.calories,
                          ),
                          const SizedBox(height: 12),
                          _buildNutrientBar(
                            'Proteine',
                            0,
                            goals?.proteinTarget ?? 150,
                            AppColors.protein,
                          ),
                          const SizedBox(height: 12),
                          _buildNutrientBar(
                            'Carbohidrați',
                            0,
                            goals?.carbsTarget ?? 200,
                            AppColors.carbs,
                          ),
                          const SizedBox(height: 12),
                          _buildNutrientBar(
                            'Grăsimi',
                            0,
                            goals?.fatsTarget ?? 60,
                            AppColors.fats,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Streak and achievements
                  _buildSectionHeader('Realizări'),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildAchievementItem(
                            Icons.local_fire_department,
                            'Serie curentă',
                            '0 zile',
                            'Înregistrează mese zilnic pentru a menține seria',
                            AppColors.warning,
                          ),
                          const Divider(height: 24),
                          _buildAchievementItem(
                            Icons.emoji_events,
                            'Obiective atinse',
                            '0 zile',
                            'Zilele în care ai atins obiectivele nutriționale',
                            AppColors.success,
                          ),
                          const Divider(height: 24),
                          _buildAchievementItem(
                            Icons.restaurant_menu,
                            'Mese înregistrate',
                            '0 mese',
                            'Total mese înregistrate în aplicație',
                            AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Goal completion rate
                  _buildSectionHeader('Rata de completare'),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildCompletionCircle('Calorii', 0),
                              _buildCompletionCircle('Proteine', 0),
                              _buildCompletionCircle('Carbohidrați', 0),
                              _buildCompletionCircle('Grăsimi', 0),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Media zilnică de atingere a obiectivelor',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildNutrientBar(
    String label,
    double current,
    double target,
    Color color,
  ) {
    final percentage = target > 0 ? (current / target * 100).clamp(0, 100) : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              '${current.toStringAsFixed(0)} / ${target.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildAchievementItem(
    IconData icon,
    String title,
    String value,
    String description,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: color,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionCircle(String label, double percentage) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: percentage / 100,
                backgroundColor: AppColors.backgroundLight,
                strokeWidth: 6,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.success,
                ),
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  String _getPeriodLabel() {
    switch (_selectedPeriod) {
      case '7days':
        return 'Ultimele 7 zile';
      case '30days':
        return 'Ultimele 30 de zile';
      case '90days':
        return 'Ultimele 90 de zile';
      case 'all':
        return 'Tot timpul';
      default:
        return 'Ultimele 7 zile';
    }
  }
}
