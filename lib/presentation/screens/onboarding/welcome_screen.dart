import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/services/local_storage_service.dart';
import '../auth/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // App logo
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.restaurant_menu,
                  size: 80,
                  color: AppColors.textOnPrimary,
                ),
              ),
              const SizedBox(height: 32),
              // Welcome text
              Text(
                AppStrings.welcome,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.welcomeMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const Spacer(),
              // Features list
              _buildFeatureItem(
                context,
                icon: Icons.menu_book,
                title: 'Rețete românești',
                description: 'Rețete tradiționale și internaționale',
              ),
              const SizedBox(height: 16),
              _buildFeatureItem(
                context,
                icon: Icons.track_changes,
                title: 'Urmărire nutriție',
                description: 'Monitorizează-ți caloriile și macronutrienții',
              ),
              const SizedBox(height: 16),
              _buildFeatureItem(
                context,
                icon: Icons.calendar_today,
                title: 'Planuri de mese',
                description: 'Planifică-ți mesele pentru întreaga săptămână',
              ),
              const Spacer(),
              // Get started button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Mark onboarding as completed
                    await LocalStorageService.instance
                        .setOnboardingCompleted(true);

                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen()),
                      );
                    }
                  },
                  child: const Text(AppStrings.getStarted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
