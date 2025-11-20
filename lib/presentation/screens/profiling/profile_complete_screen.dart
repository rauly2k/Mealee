import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/auth/custom_auth_button.dart';
import '../main_navigation.dart';

/// Confirmation screen shown after completing profile setup
/// Shows success message with logo, checkmark, and Get Started button
class ProfileCompleteScreen extends StatelessWidget {
  const ProfileCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Logo placeholder
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 80,
                    height: 80,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to text logo if image is missing
                      return Text(
                        'M',
                        style: GoogleFonts.poppins(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Success checkmark
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 48,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 32),

              // Success title
              Text(
                'Your profile is all set!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 16),

              // Success message
              Text(
                'We\'ve personalized your experience based on your preferences. You\'re ready to start your healthy eating journey!',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),

              const Spacer(),

              // Get Started Button
              CustomAuthButton(
                text: 'Get Started',
                onPressed: () {
                  // Navigate to main app and remove all previous routes
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const MainNavigation(),
                    ),
                    (route) => false,
                  );
                },
                type: AuthButtonType.primary,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
