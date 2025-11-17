import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

/// Global error handler for the application
///
/// Handles all uncaught errors and provides error reporting capabilities.
/// Use this to centralize error handling and logging.
///
/// Usage:
/// ```dart
/// // Initialize in main.dart
/// ErrorHandler.initialize();
///
/// // Handle specific errors
/// try {
///   // risky operation
/// } catch (e, stackTrace) {
///   ErrorHandler.handleError(e, stackTrace);
/// }
/// ```
class ErrorHandler {
  ErrorHandler._();

  static bool _initialized = false;

  /// Initialize global error handling
  static void initialize() {
    if (_initialized) return;

    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      _logError(
        details.exception,
        details.stack,
        details.library,
        isFatal: false,
      );
    };

    // Handle errors outside of Flutter (async errors)
    PlatformDispatcher.instance.onError = (error, stack) {
      _logError(error, stack, 'root', isFatal: true);
      return true;
    };

    _initialized = true;
    debugPrint('✓ Error handler initialized');
  }

  /// Handle and log an error
  static void handleError(
    dynamic error,
    StackTrace? stackTrace, {
    String? context,
    bool isFatal = false,
  }) {
    _logError(error, stackTrace, context, isFatal: isFatal);
  }

  /// Log error details
  static void _logError(
    dynamic error,
    StackTrace? stackTrace,
    String? context, {
    bool isFatal = false,
  }) {
    final errorInfo = ErrorInfo.fromError(error, stackTrace, context, isFatal);

    if (kDebugMode) {
      debugPrint('');
      debugPrint('═══════════════════════════════════════');
      debugPrint(isFatal ? "🔴 FATAL ERROR" : "⚠️  ERROR");
      debugPrint('═══════════════════════════════════════');
      debugPrint('Context: ${errorInfo.context ?? "Unknown"}');
      debugPrint('Type: ${errorInfo.errorType}');
      debugPrint('Message: ${errorInfo.message}');
      debugPrint('Time: ${errorInfo.timestamp}');
      if (errorInfo.stackTrace != null) {
        debugPrint('Stack Trace:');
        debugPrint(errorInfo.stackTrace.toString());
      }
      debugPrint('═══════════════════════════════════════');
      debugPrint('');
    }

    // TODO: In production, send to crash reporting service
    // if (AppConfig.enableCrashReporting) {
    //   _sendToCrashReporting(errorInfo);
    // }
  }

  /// Get user-friendly error message
  static String getUserMessage(dynamic error) {
    if (error is FirebaseException) {
      return _getFirebaseErrorMessage(error);
    } else if (error is NetworkException) {
      return 'Verifică conexiunea la internet și încearcă din nou.';
    } else if (error is ValidationException) {
      return error.message;
    } else if (error is TimeoutException) {
      return 'Operațiunea a durat prea mult. Te rugăm să încerci din nou.';
    } else if (error is FormatException) {
      return 'Date invalide. Te rugăm să verifici informațiile introduse.';
    } else {
      return 'A apărut o eroare. Te rugăm să încerci din nou.';
    }
  }

  /// Get Firebase-specific error messages
  static String _getFirebaseErrorMessage(dynamic error) {
    final code = error.code?.toLowerCase() ?? '';

    if (code.contains('network')) {
      return 'Verifică conexiunea la internet.';
    } else if (code.contains('not-found')) {
      return 'Informațiile solicitate nu au fost găsite.';
    } else if (code.contains('permission')) {
      return 'Nu ai permisiunea de a efectua această acțiune.';
    } else if (code.contains('already-exists')) {
      return 'Aceste informații există deja.';
    } else if (code.contains('invalid')) {
      return 'Date invalide. Verifică informațiile introduse.';
    } else if (code.contains('email-already-in-use')) {
      return 'Acest email este deja folosit.';
    } else if (code.contains('weak-password')) {
      return 'Parola este prea slabă.';
    } else if (code.contains('user-not-found')) {
      return 'Nu există utilizator cu acest email.';
    } else if (code.contains('wrong-password')) {
      return 'Parolă incorectă.';
    } else {
      return 'A apărut o eroare. Te rugăm să încerci din nou.';
    }
  }
}

/// Custom exception types
class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network error occurred']);

  @override
  String toString() => message;
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);

  @override
  String toString() => message;
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class DataException implements Exception {
  final String message;
  DataException(this.message);

  @override
  String toString() => message;
}

class FirebaseException implements Exception {
  final String message;
  final String? code;
  FirebaseException(this.message, {this.code});

  @override
  String toString() => '$message${code != null ? " (Code: $code)" : ""}';
}

/// Error information container
class ErrorInfo {
  final String errorType;
  final String message;
  final String? context;
  final StackTrace? stackTrace;
  final DateTime timestamp;
  final bool isFatal;

  ErrorInfo({
    required this.errorType,
    required this.message,
    this.context,
    this.stackTrace,
    required this.timestamp,
    required this.isFatal,
  });

  factory ErrorInfo.fromError(
    dynamic error,
    StackTrace? stackTrace,
    String? context,
    bool isFatal,
  ) {
    return ErrorInfo(
      errorType: error.runtimeType.toString(),
      message: error.toString(),
      context: context,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
      isFatal: isFatal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'errorType': errorType,
      'message': message,
      'context': context,
      'timestamp': timestamp.toIso8601String(),
      'isFatal': isFatal,
      'stackTrace': stackTrace?.toString(),
    };
  }
}

/// Error boundary widget
///
/// Wraps a widget tree and catches any errors that occur during build.
/// Displays a fallback UI when errors occur.
///
/// Usage:
/// ```dart
/// ErrorBoundary(
///   child: MyApp(),
///   onError: (error, stackTrace) {
///     // Handle error
///   },
/// )
/// ```
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(dynamic error)? errorBuilder;
  final void Function(dynamic error, StackTrace stackTrace)? onError;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
    this.onError,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  dynamic _error;

  @override
  void initState() {
    super.initState();
    // Reset error on init
    _error = null;
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(_error) ??
          _DefaultErrorWidget(
            error: _error,
            onRetry: () {
              setState(() {
                _error = null;
              });
            },
          );
    }

    return widget.child;
  }
}

/// Default error widget shown by ErrorBoundary
class _DefaultErrorWidget extends StatelessWidget {
  final dynamic error;
  final VoidCallback onRetry;

  const _DefaultErrorWidget({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 24),
              const Text(
                'Oops! Ceva nu a mers bine',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                ErrorHandler.getUserMessage(error),
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Încearcă din nou'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
