import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Connectivity service for monitoring network status
///
/// Provides real-time network status updates and offline detection.
///
/// Usage:
/// ```dart
/// // Initialize in main.dart or app startup
/// ConnectivityService.instance.initialize();
///
/// // Listen to connectivity changes
/// ConnectivityService.instance.connectivityStream.listen((isOnline) {
///   print('Online: $isOnline');
/// });
///
/// // Check current status
/// final isOnline = await ConnectivityService.instance.isConnected;
/// ```
class ConnectivityService {
  ConnectivityService._();
  static final ConnectivityService instance = ConnectivityService._();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectivityController = StreamController<bool>.broadcast();

  bool _isOnline = true;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Stream of connectivity status changes
  Stream<bool> get connectivityStream => _connectivityController.stream;

  /// Current connectivity status
  bool get isOnline => _isOnline;

  /// Opposite of isOnline for convenience
  bool get isOffline => !_isOnline;

  /// Initialize connectivity monitoring
  void initialize() {
    // Check initial connectivity
    _checkConnectivity();

    // Listen for connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });

    debugPrint('✓ Connectivity service initialized');
  }

  /// Dispose of resources
  void dispose() {
    _subscription?.cancel();
    _connectivityController.close();
  }

  /// Check current connectivity
  Future<void> _checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      _updateConnectionStatus([ConnectivityResult.none]);
    }
  }

  /// Update connection status based on connectivity results
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final wasOnline = _isOnline;

    // Check if any of the results indicate connectivity
    _isOnline = results.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet);

    // Notify listeners if status changed
    if (wasOnline != _isOnline) {
      debugPrint('Connectivity changed: ${_isOnline ? "Online" : "Offline"}');
      _connectivityController.add(_isOnline);
    }
  }

  /// Check if device has internet connection
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return results.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet);
  }

  /// Get current connectivity type
  Future<String> getConnectionType() async {
    final results = await _connectivity.checkConnectivity();

    if (results.contains(ConnectivityResult.wifi)) {
      return 'WiFi';
    } else if (results.contains(ConnectivityResult.mobile)) {
      return 'Date mobile';
    } else if (results.contains(ConnectivityResult.ethernet)) {
      return 'Ethernet';
    } else {
      return 'Offline';
    }
  }
}

/// Widget that displays connectivity status banner
///
/// Shows a banner at the top of the screen when offline.
///
/// Usage:
/// ```dart
/// ConnectivityBanner(
///   child: YourAppContent(),
/// )
/// ```
class ConnectivityBanner extends StatefulWidget {
  final Widget child;

  const ConnectivityBanner({
    super.key,
    required this.child,
  });

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner> {
  bool _isOnline = true;
  StreamSubscription<bool>? _subscription;

  @override
  void initState() {
    super.initState();
    _isOnline = ConnectivityService.instance.isOnline;
    _subscription = ConnectivityService.instance.connectivityStream.listen((isOnline) {
      setState(() => _isOnline = isOnline);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!_isOnline)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.red.shade700,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Nicio conexiune la internet',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        Expanded(child: widget.child),
      ],
    );
  }
}

/// Widget that shows different content based on connectivity
///
/// Usage:
/// ```dart
/// ConnectivityBuilder(
///   onlineBuilder: (context) => OnlineContent(),
///   offlineBuilder: (context) => OfflineMessage(),
/// )
/// ```
class ConnectivityBuilder extends StatefulWidget {
  final Widget Function(BuildContext context) onlineBuilder;
  final Widget Function(BuildContext context)? offlineBuilder;

  const ConnectivityBuilder({
    super.key,
    required this.onlineBuilder,
    this.offlineBuilder,
  });

  @override
  State<ConnectivityBuilder> createState() => _ConnectivityBuilderState();
}

class _ConnectivityBuilderState extends State<ConnectivityBuilder> {
  bool _isOnline = true;
  StreamSubscription<bool>? _subscription;

  @override
  void initState() {
    super.initState();
    _isOnline = ConnectivityService.instance.isOnline;
    _subscription = ConnectivityService.instance.connectivityStream.listen((isOnline) {
      setState(() => _isOnline = isOnline);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isOnline) {
      return widget.onlineBuilder(context);
    } else {
      return widget.offlineBuilder?.call(context) ?? _defaultOfflineWidget(context);
    }
  }

  Widget _defaultOfflineWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            const Text(
              'Nicio conexiune la internet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Verifică conexiunea și încearcă din nou',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                // Force check connectivity
                final isConnected = await ConnectivityService.instance.isConnected;
                if (isConnected && mounted) {
                  setState(() {});
                }
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reîncearcă'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mixin for widgets that need connectivity awareness
///
/// Usage:
/// ```dart
/// class MyScreen extends StatefulWidget {
///   // ...
/// }
///
/// class _MyScreenState extends State<MyScreen> with ConnectivityAware {
///   @override
///   void initState() {
///     super.initState();
///     initConnectivity();
///   }
///
///   @override
///   void onConnectivityChanged(bool isOnline) {
///     // Handle connectivity change
///     if (isOnline) {
///       // Sync data, refresh, etc.
///     }
///   }
/// }
/// ```
mixin ConnectivityAware<T extends StatefulWidget> on State<T> {
  StreamSubscription<bool>? _connectivitySubscription;
  bool _isOnline = true;

  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;

  void initConnectivity() {
    _isOnline = ConnectivityService.instance.isOnline;
    _connectivitySubscription = ConnectivityService.instance.connectivityStream.listen((isOnline) {
      if (mounted) {
        setState(() => _isOnline = isOnline);
        onConnectivityChanged(isOnline);
      }
    });
  }

  void disposeConnectivity() {
    _connectivitySubscription?.cancel();
  }

  @override
  void dispose() {
    disposeConnectivity();
    super.dispose();
  }

  /// Override this method to handle connectivity changes
  void onConnectivityChanged(bool isOnline) {
    // Override in child classes
  }

  /// Show offline snackbar
  void showOfflineSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.white),
            SizedBox(width: 12),
            Text('Nicio conexiune la internet'),
          ],
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  /// Show back online snackbar
  void showOnlineSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.wifi, color: Colors.white),
            const SizedBox(width: 12),
            const Text('Conexiune restabilită'),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
