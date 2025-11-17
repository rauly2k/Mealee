import '../constants/app_constants.dart';
import '../error/error_handler.dart';

/// Data sanitization and validation utilities
///
/// Provides methods to clean, validate, and sanitize user input
/// to prevent injection attacks and ensure data integrity.
class Sanitizers {
  Sanitizers._();

  // ============== STRING SANITIZATION ==============

  /// Sanitizes user input by trimming and removing dangerous characters
  static String sanitizeInput(String? input) {
    if (input == null) return '';

    // Trim whitespace
    String sanitized = input.trim();

    // Remove null bytes
    sanitized = sanitized.replaceAll('\u0000', '');

    // Remove control characters (but keep newlines and tabs for descriptions)
    sanitized = sanitized.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'), '');

    return sanitized;
  }

  /// Sanitizes text for single-line input (removes newlines)
  static String sanitizeSingleLine(String? input) {
    String sanitized = sanitizeInput(input);

    // Remove all newlines and tabs
    sanitized = sanitized.replaceAll(RegExp(r'[\r\n\t]'), ' ');

    // Remove multiple spaces
    sanitized = sanitized.replaceAll(RegExp(r'\s+'), ' ');

    return sanitized.trim();
  }

  /// Sanitizes multi-line text (preserves newlines)
  static String sanitizeMultiLine(String? input) {
    String sanitized = sanitizeInput(input);

    // Normalize line endings
    sanitized = sanitized.replaceAll('\r\n', '\n');
    sanitized = sanitized.replaceAll('\r', '\n');

    // Remove excessive newlines (max 2 consecutive)
    sanitized = sanitized.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return sanitized.trim();
  }

  /// Removes HTML tags and special characters
  static String stripHtml(String? input) {
    if (input == null) return '';

    String stripped = input;

    // Remove HTML tags
    stripped = stripped.replaceAll(RegExp(r'<[^>]*>'), '');

    // Decode common HTML entities
    stripped = stripped.replaceAll('&amp;', '&');
    stripped = stripped.replaceAll('&lt;', '<');
    stripped = stripped.replaceAll('&gt;', '>');
    stripped = stripped.replaceAll('&quot;', '"');
    stripped = stripped.replaceAll('&#39;', "'");

    return sanitizeInput(stripped);
  }

  /// Capitalizes first letter of each word
  static String capitalizeWords(String? input) {
    if (input == null || input.isEmpty) return '';

    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Capitalizes first letter only
  static String capitalizeFirst(String? input) {
    if (input == null || input.isEmpty) return '';
    return input[0].toUpperCase() + input.substring(1);
  }

  // ============== NUMERIC SANITIZATION ==============

  /// Sanitizes and parses integer value
  static int? sanitizeInt(String? input, {int? defaultValue}) {
    if (input == null || input.isEmpty) return defaultValue;

    // Remove non-numeric characters except minus sign
    final cleaned = input.replaceAll(RegExp(r'[^\d-]'), '');

    return int.tryParse(cleaned) ?? defaultValue;
  }

  /// Sanitizes and parses double value
  static double? sanitizeDouble(String? input, {double? defaultValue}) {
    if (input == null || input.isEmpty) return defaultValue;

    // Replace comma with dot for decimal
    String cleaned = input.replaceAll(',', '.');

    // Remove non-numeric characters except dot and minus
    cleaned = cleaned.replaceAll(RegExp(r'[^\d.-]'), '');

    // Ensure only one decimal point
    final parts = cleaned.split('.');
    if (parts.length > 2) {
      cleaned = '${parts[0]}.${parts.sublist(1).join('')}';
    }

    return double.tryParse(cleaned) ?? defaultValue;
  }

  /// Clamps numeric value between min and max
  static double clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  /// Rounds to specified decimal places
  static double roundTo(double value, int decimals) {
    final multiplier = decimals == 0 ? 1.0 : (decimals == 1 ? 10.0 : decimals == 2 ? 100.0 : 1000.0);
    return (value * multiplier).round() / multiplier;
  }

  // ============== EMAIL SANITIZATION ==============

  /// Sanitizes email address
  static String sanitizeEmail(String? email) {
    if (email == null) return '';

    // Trim and convert to lowercase
    String sanitized = email.trim().toLowerCase();

    // Remove dangerous characters
    sanitized = sanitized.replaceAll(RegExp(r'[<>"\;]'), '');

    return sanitized;
  }

  // ============== VALIDATION WITH SANITIZATION ==============

  /// Validates and sanitizes name
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Numele este obligatoriu';
    }

    final sanitized = sanitizeSingleLine(value);

    if (sanitized.length < AppConstants.minNameLength) {
      return 'Numele trebuie să aibă minim ${AppConstants.minNameLength} caractere';
    }

    if (sanitized.length > AppConstants.maxNameLength) {
      return 'Numele trebuie să aibă maxim ${AppConstants.maxNameLength} caractere';
    }

    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-ZăâîșțĂÂÎȘȚ\s'-]+$").hasMatch(sanitized)) {
      return 'Numele conține caractere invalide';
    }

    return null;
  }

  /// Validates and sanitizes quantity
  static String? validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Cantitatea este obligatorie';
    }

    final quantity = sanitizeDouble(value);

    if (quantity == null) {
      return 'Cantitate invalidă';
    }

    if (quantity < AppConstants.minQuantity) {
      return 'Cantitatea trebuie să fie mai mare de ${AppConstants.minQuantity}';
    }

    if (quantity > AppConstants.maxQuantity) {
      return 'Cantitatea trebuie să fie mai mică de ${AppConstants.maxQuantity}';
    }

    return null;
  }

  /// Validates and sanitizes calories
  static String? validateCalories(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Caloriile sunt obligatorii';
    }

    final calories = sanitizeInt(value);

    if (calories == null) {
      return 'Valoare invalidă';
    }

    if (calories < 0) {
      return 'Caloriile nu pot fi negative';
    }

    if (calories > 10000) {
      return 'Valoare prea mare';
    }

    return null;
  }

  /// Validates and sanitizes macronutrients
  static String? validateMacro(String? value, String macroName) {
    if (value == null || value.trim().isEmpty) {
      return '$macroName este obligatoriu';
    }

    final macro = sanitizeDouble(value);

    if (macro == null) {
      return 'Valoare invalidă';
    }

    if (macro < 0) {
      return '$macroName nu poate fi negativ';
    }

    if (macro > 1000) {
      return 'Valoare prea mare';
    }

    return null;
  }

  // ============== TEXT LENGTH VALIDATION ==============

  /// Validates text length
  static String? validateTextLength(
    String? value, {
    required int minLength,
    required int maxLength,
    String? fieldName,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? "Acest câmp"} este obligatoriu';
    }

    final sanitized = sanitizeInput(value);

    if (sanitized.length < minLength) {
      return '${fieldName ?? "Textul"} trebuie să aibă minim $minLength caractere';
    }

    if (sanitized.length > maxLength) {
      return '${fieldName ?? "Textul"} trebuie să aibă maxim $maxLength caractere';
    }

    return null;
  }

  // ============== SPECIAL CHARACTER CHECKING ==============

  /// Checks if string contains SQL injection patterns
  static bool containsSqlInjection(String input) {
    final sqlPatterns = [
      RegExp(r"(\b(SELECT|INSERT|UPDATE|DELETE|DROP|CREATE|ALTER|EXEC|EXECUTE)\b)", caseSensitive: false),
      RegExp(r"(--|;|'|""|\\*|/\\*)"),
      RegExp(r"(\bOR\b.*=|1=1)", caseSensitive: false),
    ];

    for (final pattern in sqlPatterns) {
      if (pattern.hasMatch(input)) {
        return true;
      }
    }

    return false;
  }

  /// Checks if string contains XSS patterns
  static bool containsXss(String input) {
    final xssPatterns = [
      RegExp(r"<script", caseSensitive: false),
      RegExp(r"javascript:", caseSensitive: false),
      RegExp(r"onerror=", caseSensitive: false),
      RegExp(r"onclick=", caseSensitive: false),
      RegExp(r"<iframe", caseSensitive: false),
    ];

    for (final pattern in xssPatterns) {
      if (pattern.hasMatch(input)) {
        return true;
      }
    }

    return false;
  }

  /// Validates input for security threats
  static String? validateSecurity(String? value) {
    if (value == null || value.isEmpty) return null;

    if (containsSqlInjection(value)) {
      ErrorHandler.handleError(
        ValidationException('Potential SQL injection detected'),
        StackTrace.current,
        context: 'Security Validation',
      );
      return 'Input conține caractere nepermise';
    }

    if (containsXss(value)) {
      ErrorHandler.handleError(
        ValidationException('Potential XSS detected'),
        StackTrace.current,
        context: 'Security Validation',
      );
      return 'Input conține caractere nepermise';
    }

    return null;
  }

  // ============== FILE VALIDATION ==============

  /// Validates file extension
  static bool isValidImageExtension(String filename) {
    final extension = filename.split('.').last.toLowerCase();
    return AppConstants.allowedImageFormats.contains(extension);
  }

  /// Validates file size
  static bool isValidFileSize(int sizeInBytes) {
    return sizeInBytes <= AppConstants.maxImageSizeBytes;
  }

  // ============== FORMATTING HELPERS ==============

  /// Formats phone number (Romanian format)
  static String formatPhoneNumber(String? phone) {
    if (phone == null) return '';

    // Remove non-numeric characters
    final digits = phone.replaceAll(RegExp(r'[^\d+]'), '');

    // Format Romanian phone: +40 XXX XXX XXX
    if (digits.startsWith('+40') && digits.length == 12) {
      return '+40 ${digits.substring(3, 6)} ${digits.substring(6, 9)} ${digits.substring(9)}';
    } else if (digits.startsWith('0') && digits.length == 10) {
      return '${digits.substring(0, 4)} ${digits.substring(4, 7)} ${digits.substring(7)}';
    }

    return digits;
  }

  /// Truncates text with ellipsis
  static String truncate(String text, int maxLength, {String ellipsis = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - ellipsis.length) + ellipsis;
  }

  /// Removes extra whitespace
  static String normalizeWhitespace(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}
