import 'package:email_validator/email_validator.dart';

class Validators {
  Validators._();

  /// Validates email format
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email-ul este obligatoriu';
    }
    if (!EmailValidator.validate(value)) {
      return 'Email invalid';
    }
    return null;
  }

  /// Validates password (minimum 6 characters)
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Parola este obligatorie';
    }
    if (value.length < 6) {
      return 'Parola trebuie să aibă minim 6 caractere';
    }
    return null;
  }

  /// Validates if two passwords match
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirmarea parolei este obligatorie';
    }
    if (value != password) {
      return 'Parolele nu se potrivesc';
    }
    return null;
  }

  /// Validates required field
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null
          ? '$fieldName este obligatoriu'
          : 'Acest câmp este obligatoriu';
    }
    return null;
  }

  /// Validates numeric value
  static String? numeric(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return required(value, fieldName: fieldName);
    }
    if (double.tryParse(value) == null) {
      return 'Introduceți o valoare numerică validă';
    }
    return null;
  }

  /// Validates numeric range
  static String? numericRange(
    String? value, {
    required double min,
    required double max,
    String? fieldName,
  }) {
    final numericError = numeric(value, fieldName: fieldName);
    if (numericError != null) return numericError;

    final numValue = double.parse(value!);
    if (numValue < min || numValue > max) {
      return 'Valoarea trebuie să fie între $min și $max';
    }
    return null;
  }

  /// Validates age (between 13 and 120)
  static String? age(String? value) {
    return numericRange(
      value,
      min: 13,
      max: 120,
      fieldName: 'Vârsta',
    );
  }

  /// Validates height in cm (between 100 and 250)
  static String? height(String? value) {
    return numericRange(
      value,
      min: 100,
      max: 250,
      fieldName: 'Înălțimea',
    );
  }

  /// Validates weight in kg (between 30 and 300)
  static String? weight(String? value) {
    return numericRange(
      value,
      min: 30,
      max: 300,
      fieldName: 'Greutatea',
    );
  }
}
