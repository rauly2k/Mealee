import 'package:flutter/material.dart';
import '../../data/models/shopping_list_model.dart';
import '../../data/repositories/shopping_list_repository.dart';

class ShoppingListProvider with ChangeNotifier {
  final ShoppingListRepository _shoppingListRepository = ShoppingListRepository();

  List<ShoppingListModel> _shoppingLists = [];
  ShoppingListModel? _activeList;
  bool _isLoading = false;
  String? _errorMessage;

  List<ShoppingListModel> get shoppingLists => _shoppingLists;
  ShoppingListModel? get activeList => _activeList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load all shopping lists for a user
  Future<void> loadShoppingLists(String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _shoppingLists = await _shoppingListRepository.getShoppingListsByUserId(userId);

      // Find active list (not completed)
      _activeList = _shoppingLists.where((list) => !list.isCompleted).firstOrNull;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create new shopping list
  Future<bool> createShoppingList(ShoppingListModel list) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _shoppingListRepository.createShoppingList(list);
      await loadShoppingLists(list.userId);

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

  /// Update shopping list
  Future<bool> updateShoppingList(ShoppingListModel list) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _shoppingListRepository.updateShoppingList(list);
      await loadShoppingLists(list.userId);

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

  /// Delete shopping list
  Future<bool> deleteShoppingList(String userId, String listId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _shoppingListRepository.deleteShoppingList(listId);
      await loadShoppingLists(userId);

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

  /// Toggle item completion
  Future<void> toggleItemCompletion(String userId, String listId, String itemId) async {
    // Find the list
    final listIndex = _shoppingLists.indexWhere((l) => l.listId == listId);
    if (listIndex == -1) return;

    final list = _shoppingLists[listIndex];
    final itemIndex = list.items.indexWhere((i) => i.id == itemId);
    if (itemIndex == -1) return;

    // Toggle the item
    final updatedItem = list.items[itemIndex].copyWith(
      isCompleted: !list.items[itemIndex].isCompleted,
    );

    final updatedItems = List<ShoppingItem>.from(list.items);
    updatedItems[itemIndex] = updatedItem;

    final updatedList = ShoppingListModel(
      listId: list.listId,
      userId: list.userId,
      name: list.name,
      items: updatedItems,
      isCompleted: list.isCompleted,
      createdAt: list.createdAt,
    );

    await updateShoppingList(updatedList);
  }

  /// Add item to active list
  Future<bool> addItemToActiveList(String userId, ShoppingItem item) async {
    if (_activeList == null) {
      // Create new list
      final newList = ShoppingListModel(
        listId: '',
        userId: userId,
        name: 'Listă ${DateTime.now().day}/${DateTime.now().month}',
        items: [item],
        isCompleted: false,
        createdAt: DateTime.now(),
      );
      return await createShoppingList(newList);
    }

    // Add to existing list
    final updatedItems = List<ShoppingItem>.from(_activeList!.items)..add(item);
    final updatedList = ShoppingListModel(
      listId: _activeList!.listId,
      userId: _activeList!.userId,
      name: _activeList!.name,
      items: updatedItems,
      isCompleted: false,
      createdAt: _activeList!.createdAt,
    );

    return await updateShoppingList(updatedList);
  }

  /// Remove item from list
  Future<bool> removeItem(String userId, String listId, String itemId) async {
    final listIndex = _shoppingLists.indexWhere((l) => l.listId == listId);
    if (listIndex == -1) return false;

    final list = _shoppingLists[listIndex];
    final updatedItems = list.items.where((i) => i.id != itemId).toList();

    final updatedList = ShoppingListModel(
      listId: list.listId,
      userId: list.userId,
      name: list.name,
      items: updatedItems,
      isCompleted: list.isCompleted,
      createdAt: list.createdAt,
    );

    return await updateShoppingList(updatedList);
  }

  /// Mark list as completed
  Future<bool> completeList(String userId, String listId) async {
    final listIndex = _shoppingLists.indexWhere((l) => l.listId == listId);
    if (listIndex == -1) return false;

    final list = _shoppingLists[listIndex];
    final updatedList = ShoppingListModel(
      listId: list.listId,
      userId: list.userId,
      name: list.name,
      items: list.items,
      isCompleted: true,
      createdAt: list.createdAt,
    );

    return await updateShoppingList(updatedList);
  }

  /// Get items by category
  Map<String, List<ShoppingItem>> getItemsByCategory(String listId) {
    final list = _shoppingLists.where((l) => l.listId == listId).firstOrNull;
    if (list == null) return {};

    final Map<String, List<ShoppingItem>> itemsByCategory = {};
    for (final item in list.items) {
      if (!itemsByCategory.containsKey(item.category)) {
        itemsByCategory[item.category] = [];
      }
      itemsByCategory[item.category]!.add(item);
    }

    return itemsByCategory;
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
