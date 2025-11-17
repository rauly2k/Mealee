import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';
import '../../core/utils/helpers.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasProfile => _currentUser?.profile != null;
  bool get hasGoals => _currentUser?.goals != null;

  /// Load current user
  Future<void> loadCurrentUser() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentUser = await _userRepository.getCurrentUser();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Stream current user
  Stream<UserModel?> streamCurrentUser() {
    return _userRepository.streamCurrentUser();
  }

  /// Update user profile
  Future<bool> updateProfile(UserProfile profile) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (_currentUser == null) {
        throw Exception('No current user');
      }

      await _userRepository.updateProfile(_currentUser!.userId, profile);

      // Reload user
      await loadCurrentUser();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update user display name
  Future<bool> updateDisplayName(String displayName) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (_currentUser == null) {
        throw Exception('No current user');
      }

      // Update display name in Firebase Auth and Firestore
      await _userRepository.updateDisplayName(_currentUser!.userId, displayName);

      // Reload user
      await loadCurrentUser();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update user goals
  Future<bool> updateGoals(UserGoals goals) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (_currentUser == null) {
        throw Exception('No current user');
      }

      await _userRepository.updateGoals(_currentUser!.userId, goals);

      // Reload user
      await loadCurrentUser();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Calculate and update goals based on profile
  Future<bool> calculateAndUpdateGoals(String goalType) async {
    try {
      if (_currentUser?.profile == null) {
        throw Exception('Profile not set');
      }

      final profile = _currentUser!.profile!;

      // Calculate BMR
      final bmr = Helpers.calculateBMR(
        weightKg: profile.weight,
        heightCm: profile.height,
        age: profile.age,
        gender: profile.gender,
      );

      // Calculate TDEE
      final tdee = Helpers.calculateTDEE(
        bmr: bmr,
        activityLevel: profile.activityLevel,
      );

      // Calculate calorie target
      final calorieTarget = Helpers.calculateCalorieTarget(
        tdee: tdee,
        goal: goalType,
      );

      // Calculate macro targets
      final macros = Helpers.calculateMacroTargets(
        calorieTarget: calorieTarget,
        goal: goalType,
      );

      final goals = UserGoals(
        goalType: goalType,
        calorieTarget: calorieTarget,
        proteinTarget: macros['protein']!,
        carbsTarget: macros['carbs']!,
        fatsTarget: macros['fats']!,
      );

      return await updateGoals(goals);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Update user preferences
  Future<bool> updatePreferences(UserPreferences preferences) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (_currentUser == null) {
        throw Exception('No current user');
      }

      await _userRepository.updatePreferences(
        _currentUser!.userId,
        preferences,
      );

      // Reload user
      await loadCurrentUser();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update user
  Future<bool> updateUser(UserModel user) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _userRepository.updateUser(user);

      // Reload user
      await loadCurrentUser();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear user data (on logout)
  void clear() {
    _currentUser = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
