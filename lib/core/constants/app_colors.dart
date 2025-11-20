import 'package:flutter/material.dart';

/// App color palette inspired by Romanian culture and food
class AppColors {
  AppColors._();

  // Primary colors - warm, inviting tones
  static const Color primary = Color(0xFFFA7315); // Warm orange (updated for onboarding)
  static const Color primaryDark = Color(0xFFE66310);
  static const Color primaryLight = Color(0xFFFF8B42);

  // Secondary colors - golden yellow (wheat, cornbread)
  static const Color secondary = Color(0xFFF4A261);
  static const Color secondaryDark = Color(0xFFE76F51);
  static const Color secondaryLight = Color(0xFFF9C784);

  // Onboarding colors
  static const Color onboardingBackground = Color(0xFFFFF7F2); // Warm cream
  static const Color onboardingText = Color(0xFF030401); // Dark text

  // Auth screen colors
  static const Color inputBackground = Color(0xFFF8F8F8); // Light gray
  static const Color textDescription = Color(0xFF101211); // Description text

  // Accent colors
  static const Color accent = Color(0xFF2A9D8F); // Fresh green
  static const Color accentLight = Color(0xFF52B69A);

  // Background colors
  static const Color background = Color(0xFFFFFFFF); // White (updated for auth screens)
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Text colors
  static const Color textPrimary = Color(0xFF030401); // Almost black (updated)
  static const Color textSecondary = Color(0xFF696969); // Gray (updated for placeholders)
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Nutrition colors
  static const Color protein = Color(0xFFE63946);
  static const Color carbs = Color(0xFFF4A261);
  static const Color fats = Color(0xFF2A9D8F);
  static const Color calories = Color(0xFF8B5CF6);

  // UI element colors
  static const Color divider = Color(0xFFD6D6D6); // Gray dividers (updated)
  static const Color border = Color(0xFFD6D6D6); // Gray border (updated)
  static const Color disabled = Color(0xFF9CA3AF);
  static const Color shadow = Color(0x1A000000);

  // Page Indicator
  static const Color indicatorActive = Color(0xFFFA7315); // Orange
  static const Color indicatorInactive = Color(0xFFD1D5DB); // Gray

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
