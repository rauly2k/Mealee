import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Central Firebase service providing access to Firebase instances
class FirebaseService {
  FirebaseService._();

  static final FirebaseService instance = FirebaseService._();

  // Firebase instances
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Collection references
  CollectionReference get usersCollection => firestore.collection('users');
  CollectionReference get recipesCollection => firestore.collection('recipes');
  CollectionReference get foodLogsCollection =>
      firestore.collection('foodLogs');
  CollectionReference get mealPlansCollection =>
      firestore.collection('mealPlans');
  CollectionReference get pantryItemsCollection =>
      firestore.collection('pantryItems');
  CollectionReference get shoppingListsCollection =>
      firestore.collection('shoppingLists');

  // Get current user
  User? get currentUser => auth.currentUser;
  String? get currentUserId => auth.currentUser?.uid;

  // Check if user is logged in
  bool get isLoggedIn => auth.currentUser != null;

  // Auth state stream
  Stream<User?> get authStateChanges => auth.authStateChanges();
}
