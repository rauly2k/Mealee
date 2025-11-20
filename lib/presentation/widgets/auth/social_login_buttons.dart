import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;

  const SocialLoginButtons({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Google Sign-In Button
        Expanded(
          child: Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              border: Border.all(
                width: 1,
                color: AppColors.border,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: InkWell(
              onTap: onGooglePressed,
              borderRadius: BorderRadius.circular(14),
              child: Center(
                child: Image.asset(
                  'assets/icons/google_icon.png',
                  width: 20,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to Material Icon if image not found
                    return const Icon(
                      Icons.g_mobiledata,
                      size: 24,
                      color: AppColors.textPrimary,
                    );
                  },
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 20),

        // Apple Sign-In Button
        Expanded(
          child: Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              border: Border.all(
                width: 1,
                color: AppColors.border,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: InkWell(
              onTap: onApplePressed,
              borderRadius: BorderRadius.circular(14),
              child: Center(
                child: Image.asset(
                  'assets/icons/apple_icon.png',
                  width: 20,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to Material Icon if image not found
                    return const Icon(
                      Icons.apple,
                      size: 24,
                      color: AppColors.textPrimary,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
