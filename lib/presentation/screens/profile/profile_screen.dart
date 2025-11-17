import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/helpers.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import 'edit_profile_screen.dart';
import '../settings/settings_screen.dart';
import '../progress/progress_screen.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          if (userProvider.isLoading) {
            return const LoadingIndicator();
          }

          final user = userProvider.currentUser;
          if (user == null) {
            return const Center(
              child: Text('Nu există utilizator autentificat'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // User info card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            user.displayName.isNotEmpty
                                ? user.displayName[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textOnPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.displayName,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          user.email,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Profile stats
                if (user.profile != null && user.goals != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Statistici profil',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 16),
                          _buildStatRow(
                            context,
                            'Vârstă',
                            '${user.profile!.age} ani',
                          ),
                          _buildStatRow(
                            context,
                            'Înălțime',
                            '${user.profile!.height.toStringAsFixed(0)} cm',
                          ),
                          _buildStatRow(
                            context,
                            'Greutate',
                            '${user.profile!.weight.toStringAsFixed(1)} kg',
                          ),
                          _buildStatRow(
                            context,
                            'IMC',
                            Helpers.calculateBMI(
                              user.profile!.weight,
                              user.profile!.height,
                            ).toStringAsFixed(1),
                          ),
                          const Divider(height: 24),
                          _buildStatRow(
                            context,
                            'Obiectiv calorii',
                            Helpers.formatCalories(user.goals!.calorieTarget),
                          ),
                          _buildStatRow(
                            context,
                            'Obiectiv proteine',
                            Helpers.formatMacros(user.goals!.proteinTarget),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Menu options
                _buildMenuOption(
                  context,
                  icon: Icons.edit_outlined,
                  title: AppStrings.editProfile,
                  onTap: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );
                    // Reload user data if profile was updated
                    if (result == true && context.mounted) {
                      context.read<UserProvider>().loadCurrentUser();
                    }
                  },
                ),
                _buildMenuOption(
                  context,
                  icon: Icons.track_changes,
                  title: AppStrings.goals,
                  onTap: () {
                    // TODO: Navigate to goals
                  },
                ),
                _buildMenuOption(
                  context,
                  icon: Icons.show_chart,
                  title: AppStrings.progress,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ProgressScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuOption(
                  context,
                  icon: Icons.settings_outlined,
                  title: AppStrings.settings,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuOption(
                  context,
                  icon: Icons.help_outline,
                  title: AppStrings.helpSupport,
                  onTap: () {
                    // TODO: Navigate to help
                  },
                ),
                _buildMenuOption(
                  context,
                  icon: Icons.logout,
                  title: AppStrings.logout,
                  textColor: AppColors.error,
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Deconectare'),
                        content: const Text('Ești sigur că vrei să te deconectezi?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text(AppStrings.cancel),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              AppStrings.logout,
                              style: TextStyle(color: AppColors.error),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true && context.mounted) {
                      await context.read<AuthProvider>().signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: textColor ?? AppColors.textPrimary),
        title: Text(
          title,
          style: TextStyle(color: textColor),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
