import 'package:flutter/material.dart';
import '../../data/models/pantry_item_model.dart';
import '../../data/repositories/pantry_repository.dart';

class PantryProvider with ChangeNotifier {
  final PantryRepository _pantryRepository = PantryRepository();

  List<PantryItemModel> _pantryItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<PantryItemModel> get pantryItems => _pantryItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load all pantry items for a user
  Future<void> loadPantryItems(String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _pantryItems = await _pantryRepository.getPantryItemsByUserId(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add pantry item
  Future<bool> addPantryItem(PantryItemModel item) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _pantryRepository.createPantryItem(item);
      await loadPantryItems(item.userId);

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

  /// Update pantry item
  Future<bool> updatePantryItem(PantryItemModel item) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _pantryRepository.updatePantryItem(item);
      await loadPantryItems(item.userId);

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

  /// Delete pantry item
  Future<bool> deletePantryItem(String userId, String itemId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _pantryRepository.deletePantryItem(itemId);
      await loadPantryItems(userId);

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

  /// Get expiring items (within days)
  List<PantryItemModel> getExpiringItems(int days) {
    return _pantryItems.where((item) {
      if (item.expiryDate == null) return false;
      final daysUntilExpiry = item.expiryDate!.difference(DateTime.now()).inDays;
      return daysUntilExpiry <= days && daysUntilExpiry >= 0;
    }).toList();
  }

  /// Get expired items
  List<PantryItemModel> getExpiredItems() {
    return _pantryItems.where((item) {
      if (item.expiryDate == null) return false;
      return item.expiryDate!.isBefore(DateTime.now());
    }).toList();
  }

  /// Get items by category
  List<PantryItemModel> getItemsByCategory(String category) {
    return _pantryItems.where((item) => item.category == category).toList();
  }

  /// Get all categories
  List<String> getCategories() {
    final categories = _pantryItems.map((item) => item.category).toSet().toList();
    categories.sort();
    return categories;
  }

  /// Search items
  List<PantryItemModel> searchItems(String query) {
    final lowerQuery = query.toLowerCase();
    return _pantryItems.where((item) {
      return item.name.toLowerCase().contains(lowerQuery) ||
          item.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
