import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class UserRepository {
  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Create a new user document
  Future<void> createUser(UserModel user) async {
    try {
      await _firebaseService.usersCollection
          .doc(user.userId)
          .set(user.toFirestore());
    } catch (e) {
      throw Exception('Eroare la crearea utilizatorului: $e');
    }
  }

  /// Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firebaseService.usersCollection.doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Eroare la încărcarea utilizatorului: $e');
    }
  }

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    final userId = _firebaseService.currentUserId;
    if (userId == null) return null;
    return getUserById(userId);
  }

  /// Stream current user
  Stream<UserModel?> streamCurrentUser() {
    final userId = _firebaseService.currentUserId;
    if (userId == null) {
      return Stream.value(null);
    }

    return _firebaseService.usersCollection
        .doc(userId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    });
  }

  /// Update user
  Future<void> updateUser(UserModel user) async {
    try {
      await _firebaseService.usersCollection.doc(user.userId).update(
            user.copyWith(updatedAt: DateTime.now()).toFirestore(),
          );
    } catch (e) {
      throw Exception('Eroare la actualizarea utilizatorului: $e');
    }
  }

  /// Update user profile
  Future<void> updateProfile(String userId, UserProfile profile) async {
    try {
      await _firebaseService.usersCollection.doc(userId).update({
        'profile': profile.toMap(),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Eroare la actualizarea profilului: $e');
    }
  }

  /// Update user display name
  Future<void> updateDisplayName(String userId, String displayName) async {
    try {
      await _firebaseService.usersCollection.doc(userId).update({
        'displayName': displayName,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
      // Also update in Firebase Auth if available
      final currentUser = _firebaseService.auth.currentUser;
      if (currentUser != null && currentUser.uid == userId) {
        await currentUser.updateDisplayName(displayName);
      }
    } catch (e) {
      throw Exception('Eroare la actualizarea numelui: $e');
    }
  }

  /// Update user goals
  Future<void> updateGoals(String userId, UserGoals goals) async {
    try {
      await _firebaseService.usersCollection.doc(userId).update({
        'goals': goals.toMap(),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Eroare la actualizarea obiectivelor: $e');
    }
  }

  /// Update user preferences
  Future<void> updatePreferences(
      String userId, UserPreferences preferences) async {
    try {
      await _firebaseService.usersCollection.doc(userId).update({
        'preferences': preferences.toMap(),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Eroare la actualizarea preferințelor: $e');
    }
  }

  /// Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await _firebaseService.usersCollection.doc(userId).delete();
    } catch (e) {
      throw Exception('Eroare la ștergerea utilizatorului: $e');
    }
  }
}
