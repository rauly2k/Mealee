import '../models/pantry_item_model.dart';
import '../services/firebase_service.dart';

class PantryRepository {
  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Add item to pantry
  Future<String> addPantryItem(PantryItemModel item) async {
    try {
      final docRef = await _firebaseService.pantryItemsCollection.add(
        item.toFirestore(),
      );
      return docRef.id;
    } catch (e) {
      throw Exception('Eroare la adăugarea ingredientului: $e');
    }
  }

  /// Get all pantry items for a user
  Future<List<PantryItemModel>> getUserPantryItems(String userId) async {
    try {
      final snapshot = await _firebaseService.pantryItemsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('addedDate', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => PantryItemModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Eroare la încărcarea ingredientelor: $e');
    }
  }

  /// Stream pantry items
  Stream<List<PantryItemModel>> streamUserPantryItems(String userId) {
    return _firebaseService.pantryItemsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('addedDate', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PantryItemModel.fromFirestore(doc))
          .toList();
    });
  }

  /// Get pantry items by category
  Future<List<PantryItemModel>> getPantryItemsByCategory(
    String userId,
    String category,
  ) async {
    try {
      final snapshot = await _firebaseService.pantryItemsCollection
          .where('userId', isEqualTo: userId)
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs
          .map((doc) => PantryItemModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Eroare la încărcarea ingredientelor: $e');
    }
  }

  /// Update pantry item
  Future<void> updatePantryItem(PantryItemModel item) async {
    try {
      await _firebaseService.pantryItemsCollection
          .doc(item.pantryItemId)
          .update(item.toFirestore());
    } catch (e) {
      throw Exception('Eroare la actualizarea ingredientului: $e');
    }
  }

  /// Delete pantry item
  Future<void> deletePantryItem(String itemId) async {
    try {
      await _firebaseService.pantryItemsCollection.doc(itemId).delete();
    } catch (e) {
      throw Exception('Eroare la ștergerea ingredientului: $e');
    }
  }

  /// Update item quantity
  Future<void> updateItemQuantity(String itemId, double newQuantity) async {
    try {
      if (newQuantity <= 0) {
        // If quantity is 0 or less, delete the item
        await deletePantryItem(itemId);
      } else {
        await _firebaseService.pantryItemsCollection.doc(itemId).update({
          'quantity': newQuantity,
        });
      }
    } catch (e) {
      throw Exception('Eroare la actualizarea cantității: $e');
    }
  }

  /// Check if ingredient is in pantry
  Future<bool> hasIngredient(String userId, String ingredientName) async {
    try {
      final snapshot = await _firebaseService.pantryItemsCollection
          .where('userId', isEqualTo: userId)
          .where('ingredientName', isEqualTo: ingredientName)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get expiring items (expiring within specified days)
  Future<List<PantryItemModel>> getExpiringItems(
    String userId, {
    int daysThreshold = 3,
  }) async {
    try {
      final items = await getUserPantryItems(userId);
      final now = DateTime.now();
      final thresholdDate = now.add(Duration(days: daysThreshold));

      return items.where((item) {
        if (item.expiryDate == null) return false;
        return item.expiryDate!.isBefore(thresholdDate) &&
            item.expiryDate!.isAfter(now);
      }).toList();
    } catch (e) {
      throw Exception('Eroare la încărcarea produselor care expiră: $e');
    }
  }

  /// Get expired items
  Future<List<PantryItemModel>> getExpiredItems(String userId) async {
    try {
      final items = await getUserPantryItems(userId);
      return items.where((item) => item.isExpired).toList();
    } catch (e) {
      throw Exception('Eroare la încărcarea produselor expirate: $e');
    }
  }

  /// Clear all pantry items (for user)
  Future<void> clearPantry(String userId) async {
    try {
      final snapshot = await _firebaseService.pantryItemsCollection
          .where('userId', isEqualTo: userId)
          .get();

      final batch = _firebaseService.firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Eroare la golirea cămării: $e');
    }
  }
}
