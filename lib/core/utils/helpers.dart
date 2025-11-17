import 'package:intl/intl.dart';

class Helpers {
  Helpers._();

  /// Format date to Romanian format
  static String formatDate(DateTime date, {String pattern = 'dd MMM yyyy'}) {
    return DateFormat(pattern, 'ro_RO').format(date);
  }

  /// Format time
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  /// Format calories with kcal suffix
  static String formatCalories(double calories) {
    return '${calories.toStringAsFixed(0)} kcal';
  }

  /// Format macros (protein, carbs, fats) with g suffix
  static String formatMacros(double grams) {
    return '${grams.toStringAsFixed(1)}g';
  }

  /// Calculate BMI (Body Mass Index)
  static double calculateBMI(double weightKg, double heightCm) {
    final heightM = heightCm / 100;
    return weightKg / (heightM * heightM);
  }

  /// Calculate BMR (Basal Metabolic Rate) using Mifflin-St Jeor Equation
  static double calculateBMR({
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender, // 'male' or 'female'
  }) {
    if (gender.toLowerCase() == 'male') {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    } else {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    }
  }

  /// Calculate TDEE (Total Daily Energy Expenditure)
  static double calculateTDEE({
    required double bmr,
    required String activityLevel,
  }) {
    final multipliers = {
      'sedentary': 1.2,
      'lightly_active': 1.375,
      'moderately_active': 1.55,
      'very_active': 1.725,
      'extremely_active': 1.9,
    };

    return bmr * (multipliers[activityLevel] ?? 1.2);
  }

  /// Calculate daily calorie target based on goal
  static double calculateCalorieTarget({
    required double tdee,
    required String goal,
  }) {
    switch (goal) {
      case 'weight_loss':
        return tdee - 500; // 500 calorie deficit for ~0.5kg/week loss
      case 'weight_gain':
      case 'muscle_gain':
        return tdee + 300; // 300 calorie surplus for healthy weight gain
      case 'weight_maintenance':
      case 'general_health':
      default:
        return tdee;
    }
  }

  /// Calculate macro targets based on goal
  static Map<String, double> calculateMacroTargets({
    required double calorieTarget,
    required String goal,
  }) {
    late double proteinPercent, carbsPercent, fatsPercent;

    switch (goal) {
      case 'weight_loss':
        proteinPercent = 0.35; // 35% protein
        carbsPercent = 0.35; // 35% carbs
        fatsPercent = 0.30; // 30% fats
        break;
      case 'muscle_gain':
        proteinPercent = 0.30; // 30% protein
        carbsPercent = 0.45; // 45% carbs
        fatsPercent = 0.25; // 25% fats
        break;
      case 'keto':
        proteinPercent = 0.25; // 25% protein
        carbsPercent = 0.05; // 5% carbs
        fatsPercent = 0.70; // 70% fats
        break;
      default:
        proteinPercent = 0.30; // 30% protein
        carbsPercent = 0.40; // 40% carbs
        fatsPercent = 0.30; // 30% fats
    }

    final proteinCals = calorieTarget * proteinPercent;
    final carbsCals = calorieTarget * carbsPercent;
    final fatsCals = calorieTarget * fatsPercent;

    return {
      'protein': proteinCals / 4, // 4 calories per gram of protein
      'carbs': carbsCals / 4, // 4 calories per gram of carbs
      'fats': fatsCals / 9, // 9 calories per gram of fat
    };
  }

  /// Format preparation time
  static String formatPrepTime(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (mins == 0) {
      return '$hours ${hours == 1 ? 'oră' : 'ore'}';
    }
    return '$hours ${hours == 1 ? 'oră' : 'ore'} $mins min';
  }

  /// Get day name in Romanian
  static String getDayName(int weekday) {
    const days = [
      'Luni',
      'Marți',
      'Miercuri',
      'Joi',
      'Vineri',
      'Sâmbătă',
      'Duminică',
    ];
    return days[weekday - 1];
  }

  /// Calculate percentage of target achieved
  static double calculatePercentage(double value, double target) {
    if (target == 0) return 0;
    return (value / target) * 100;
  }

  /// Clamp percentage between 0 and 100
  static double clampPercentage(double percentage) {
    return percentage.clamp(0, 100);
  }

  /// Format percentage
  static String formatPercentage(double percentage) {
    return '${percentage.toStringAsFixed(0)}%';
  }

  /// Pluralize Romanian words (basic implementation)
  static String pluralize(int count, String singular, String plural) {
    return count == 1 ? singular : plural;
  }

  /// Truncate text with ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}
