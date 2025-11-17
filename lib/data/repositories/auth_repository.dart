import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/firebase_service.dart';
import '../models/user_model.dart';
import 'user_repository.dart';

class AuthRepository {
  final FirebaseService _firebaseService = FirebaseService.instance;
  final UserRepository _userRepository = UserRepository();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _firebaseService.currentUser;
  String? get currentUserId => _firebaseService.currentUserId;
  bool get isLoggedIn => _firebaseService.isLoggedIn;

  // Auth state stream
  Stream<User?> get authStateChanges => _firebaseService.authStateChanges;

  /// Sign in with email and password
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseService.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Register with email and password
  Future<User?> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      // Create user account
      final credential =
          await _firebaseService.auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        // Update display name
        await user.updateDisplayName(displayName);

        // Create user document in Firestore
        final userModel = UserModel(
          userId: user.uid,
          email: email,
          displayName: displayName,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _userRepository.createUser(userModel);
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the Google Sign In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential =
          await _firebaseService.auth.signInWithCredential(credential);

      final user = userCredential.user;

      // Check if this is a new user and create Firestore document
      if (user != null && userCredential.additionalUserInfo?.isNewUser == true) {
        final userModel = UserModel(
          userId: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _userRepository.createUser(userModel);
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Eroare la autentificarea cu Google: $e');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseService.auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw Exception('Eroare la deconectare: $e');
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseService.auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('Nu există utilizator autentificat');

      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Update email
  Future<void> updateEmail(String newEmail) async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('Nu există utilizator autentificat');

      await user.updateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user == null) throw Exception('Nu există utilizator autentificat');

      // Delete user document from Firestore
      await _userRepository.deleteUser(user.uid);

      // Delete Firebase Auth account
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Nu există un cont cu acest email.';
      case 'wrong-password':
        return 'Parolă incorectă.';
      case 'email-already-in-use':
        return 'Acest email este deja folosit.';
      case 'invalid-email':
        return 'Email invalid.';
      case 'weak-password':
        return 'Parola este prea slabă.';
      case 'operation-not-allowed':
        return 'Operațiune nepermisă.';
      case 'user-disabled':
        return 'Acest cont a fost dezactivat.';
      case 'too-many-requests':
        return 'Prea multe încercări. Încearcă din nou mai târziu.';
      case 'requires-recent-login':
        return 'Această operațiune necesită o autentificare recentă.';
      default:
        return 'Eroare de autentificare: ${e.message}';
    }
  }
}
