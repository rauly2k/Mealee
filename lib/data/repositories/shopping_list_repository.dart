import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shopping_list_model.dart';
import '../services/firebase_service.dart';

class ShoppingListRepository {
  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Create shopping list
  Future<String> createShoppingList(ShoppingListModel list) async {
    try {
      final docRef = await _firebaseService.shoppingListsCollection.add(
        list.toFirestore(),
      );
      return docRef.id;
    } catch (e) {
      throw Exception('Eroare la crearea listei de cumpărături: $e');
    }
  }

  /// Get shopping list by ID
  Future<ShoppingListModel?> getShoppingListById(String listId) async {
    try {
      final doc =
          await _firebaseService.shoppingListsCollection.doc(listId).get();
      if (doc.exists) {
        return ShoppingListModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Eroare la încărcarea listei de cumpărături: $e');
    }
  }

  /// Get all shopping lists for a user
  Future<List<ShoppingListModel>> getUserShoppingLists(String userId) async {
    try {
      final snapshot = await _firebaseService.shoppingListsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ShoppingListModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Eroare la încărcarea listelor de cumpărături: $e');
    }
  }

  /// Stream user shopping lists
  Stream<List<ShoppingListModel>> streamUserShoppingLists(String userId) {
    return _firebaseService.shoppingListsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ShoppingListModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Update shopping list
  Future<void> updateShoppingList(ShoppingListModel list) async {
    try {
      await _firebaseService.shoppingListsCollection.doc(list.listId).update(
            list.copyWith(updatedAt: DateTime.now()).toFirestore(),
          );
    } catch (e) {
      throw Exception('Eroare la actualizarea listei de cumpărături: $e');
    }
  }

  /// Delete shopping list
  Future<void> deleteShoppingList(String listId) async {
    try {
      await _firebaseService.shoppingListsCollection.doc(listId).delete();
    } catch (e) {
      throw Exception('Eroare la ștergerea listei de cumpărături: $e');
    }
  }

  /// Toggle item checked status
  Future<void> toggleItemChecked(String listId, int itemIndex) async {
    try {
      final list = await getShoppingListById(listId);
      if (list == null) return;

      final updatedItems = List<ShoppingItem>.from(list.items);
      updatedItems[itemIndex] = updatedItems[itemIndex].copyWith(
        checked: !updatedItems[itemIndex].checked,
      );

      await updateShoppingList(list.copyWith(items: updatedItems));
    } catch (e) {
      throw Exception('Eroare la actualizarea articolului: $e');
    }
  }

  /// Add item to list
  Future<void> addItemToList(String listId, ShoppingItem item) async {
    try {
      final list = await getShoppingListById(listId);
      if (list == null) return;

      final updatedItems = List<ShoppingItem>.from(list.items)..add(item);

      await updateShoppingList(list.copyWith(items: updatedItems));
    } catch (e) {
      throw Exception('Eroare la adăugarea articolului: $e');
    }
  }

  /// Remove item from list
  Future<void> removeItemFromList(String listId, int itemIndex) async {
    try {
      final list = await getShoppingListById(listId);
      if (list == null) return;

      final updatedItems = List<ShoppingItem>.from(list.items)
        ..removeAt(itemIndex);

      await updateShoppingList(list.copyWith(items: updatedItems));
    } catch (e) {
      throw Exception('Eroare la ștergerea articolului: $e');
    }
  }

  /// Clear checked items
  Future<void> clearCheckedItems(String listId) async {
    try {
      final list = await getShoppingListById(listId);
      if (list == null) return;

      final updatedItems =
          list.items.where((item) => !item.checked).toList();

      await updateShoppingList(list.copyWith(items: updatedItems));
    } catch (e) {
      throw Exception('Eroare la ștergerea articolelor bifate: $e');
    }
  }

  /// Get active (incomplete) shopping lists
  Future<List<ShoppingListModel>> getActiveShoppingLists(String userId) async {
    try {
      final lists = await getUserShoppingLists(userId);
      return lists.where((list) => !list.isComplete).toList();
    } catch (e) {
      throw Exception('Eroare la încărcarea listelor active: $e');
    }
  }

  /// Get completed shopping lists
  Future<List<ShoppingListModel>> getCompletedShoppingLists(
      String userId) async {
    try {
      final lists = await getUserShoppingLists(userId);
      return lists.where((list) => list.isComplete).toList();
    } catch (e) {
      throw Exception('Eroare la încărcarea listelor completate: $e');
    }
  }
}
