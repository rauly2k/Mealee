import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/recipe_model.dart';
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

    final updatedList = list.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );

    await updateShoppingList(updatedList);
  }

  /// Add item to active list
  Future<bool> addItemToActiveList(String userId, ShoppingItem item) async {
    if (_activeList == null) {
      // Create new list
      final now = DateTime.now();
      final newList = ShoppingListModel(
        listId: '',
        userId: userId,
        name: 'Listă ${now.day}/${now.month}',
        items: [item],
        createdFrom: 'manual',
        createdAt: now,
        updatedAt: now,
      );
      return await createShoppingList(newList);
    }

    // Add to existing list
    final updatedItems = List<ShoppingItem>.from(_activeList!.items)..add(item);
    final updatedList = _activeList!.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );

    return await updateShoppingList(updatedList);
  }

  /// Remove item from list
  Future<bool> removeItem(String userId, String listId, String itemId) async {
    final listIndex = _shoppingLists.indexWhere((l) => l.listId == listId);
    if (listIndex == -1) return false;

    final list = _shoppingLists[listIndex];
    final updatedItems = list.items.where((i) => i.id != itemId).toList();

    final updatedList = list.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );

    return await updateShoppingList(updatedList);
  }

  /// Mark list as completed - marks all items as checked
  Future<bool> completeList(String userId, String listId) async {
    final listIndex = _shoppingLists.indexWhere((l) => l.listId == listId);
    if (listIndex == -1) return false;

    final list = _shoppingLists[listIndex];
    // Mark all items as checked
    final updatedItems = list.items.map((item) => item.copyWith(checked: true)).toList();

    final updatedList = list.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );

    return await updateShoppingList(updatedList);
  }

  /// Get items by category
  Map<String, List<ShoppingItem>> getItemsByCategory(String listId) {
    final list = _shoppingLists.where((l) => l.listId == listId).firstOrNull;
    if (list == null) return {};

    final Map<String, List<ShoppingItem>> itemsByCategory = {};
    for (final item in list.items) {
      final category = item.category ?? 'Uncategorized';
      if (!itemsByCategory.containsKey(category)) {
        itemsByCategory[category] = [];
      }
      itemsByCategory[category]!.add(item);
    }

    return itemsByCategory;
  }

  /// Add recipe ingredients to shopping list with aggregation
  Future<bool> addRecipeIngredientsToList({
    required String userId,
    required RecipeModel recipe,
    double portionMultiplier = 1.0,
  }) async {
    try {
      final uuid = const Uuid();

      // Convert recipe ingredients to shopping items
      final newItems = recipe.ingredients.map((ingredient) {
        return ShoppingItem(
          id: uuid.v4(),
          ingredient: ingredient.name,
          quantity: ingredient.quantity * portionMultiplier,
          unit: ingredient.unit,
          checked: false,
          inPantry: false,
          category: _categorizeIngredient(ingredient.name),
        );
      }).toList();

      if (_activeList == null) {
        // Create new list with recipe ingredients
        final now = DateTime.now();
        final newList = ShoppingListModel(
          listId: '',
          userId: userId,
          name: 'Listă ${now.day}/${now.month}',
          items: newItems,
          createdFrom: 'recipe',
          sourceId: recipe.recipeId,
          createdAt: now,
          updatedAt: now,
        );
        return await createShoppingList(newList);
      }

      // Aggregate with existing items
      final existingItems = List<ShoppingItem>.from(_activeList!.items);

      for (final newItem in newItems) {
        // Find if ingredient already exists (case insensitive)
        final existingIndex = existingItems.indexWhere((item) =>
            item.ingredient.toLowerCase() == newItem.ingredient.toLowerCase() &&
            item.unit.toLowerCase() == newItem.unit.toLowerCase());

        if (existingIndex != -1) {
          // Aggregate quantities
          final existingItem = existingItems[existingIndex];
          existingItems[existingIndex] = existingItem.copyWith(
            quantity: existingItem.quantity + newItem.quantity,
          );
        } else {
          // Add as new item
          existingItems.add(newItem);
        }
      }

      final updatedList = _activeList!.copyWith(
        items: existingItems,
        updatedAt: DateTime.now(),
      );

      return await updateShoppingList(updatedList);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Categorize ingredient based on name (simple categorization)
  String? _categorizeIngredient(String ingredientName) {
    final name = ingredientName.toLowerCase();

    if (name.contains('roșie') ||
        name.contains('salată') ||
        name.contains('castravete') ||
        name.contains('ardei') ||
        name.contains('ceapă') ||
        name.contains('usturoi') ||
        name.contains('cartofi') ||
        name.contains('morcov')) {
      return 'Legume';
    } else if (name.contains('pui') ||
        name.contains('carne') ||
        name.contains('porc') ||
        name.contains('vită') ||
        name.contains('pește')) {
      return 'Carne & Pește';
    } else if (name.contains('lapte') ||
        name.contains('iaurt') ||
        name.contains('brânză') ||
        name.contains('unt') ||
        name.contains('smântână')) {
      return 'Lactate';
    } else if (name.contains('mere') ||
        name.contains('banane') ||
        name.contains('portocale') ||
        name.contains('căpșuni') ||
        name.contains('zmeură')) {
      return 'Fructe';
    } else if (name.contains('pâine') ||
        name.contains('făină') ||
        name.contains('orez') ||
        name.contains('paste') ||
        name.contains('crupe')) {
      return 'Cereale & Pâine';
    } else {
      return 'Altele';
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
