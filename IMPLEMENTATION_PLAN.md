# Mealee App - Complete Implementation Plan

## Table of Contents
1. [Project Setup](#1-project-setup)
2. [Phase 1: MVP Development (Months 1-2)](#2-phase-1-mvp-development-months-1-2)
3. [Phase 2: AI Integration (Month 3)](#3-phase-2-ai-integration-month-3)
4. [Phase 3: Advanced Features (Months 4-5)](#4-phase-3-advanced-features-months-4-5)
5. [Phase 4: Polish & Scale (Month 6+)](#5-phase-4-polish--scale-month-6)
6. [Testing Strategy](#6-testing-strategy)
7. [Deployment Guide](#7-deployment-guide)

---

## 1. Project Setup

### 1.1 Development Environment Setup

**Prerequisites:**
- Flutter SDK (latest stable version)
- Android Studio / Xcode (for mobile development)
- Visual Studio Code (recommended) with Flutter/Dart extensions
- Firebase CLI
- Git
- Google Cloud account (for Gemini API)

**Step-by-step setup:**

```bash
# 1. Install Flutter
# Follow official guide: https://flutter.dev/docs/get-started/install

# 2. Verify Flutter installation
flutter doctor

# 3. Install Firebase CLI
npm install -g firebase-tools

# 4. Login to Firebase
firebase login
```

### 1.2 Create Flutter Project

```bash
# Create new Flutter project
flutter create mealee_app
cd mealee_app

# Open in VS Code
code .
```

### 1.3 Project Structure

Create the following folder structure:

```
mealee_app/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_strings.dart
│   │   │   └── app_routes.dart
│   │   ├── theme/
│   │   │   └── app_theme.dart
│   │   ├── utils/
│   │   │   ├── validators.dart
│   │   │   ├── helpers.dart
│   │   │   └── extensions.dart
│   │   └── config/
│   │       ├── firebase_config.dart
│   │       └── env_config.dart
│   ├── data/
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   ├── recipe_model.dart
│   │   │   ├── food_log_model.dart
│   │   │   ├── meal_plan_model.dart
│   │   │   ├── pantry_item_model.dart
│   │   │   └── shopping_list_model.dart
│   │   ├── repositories/
│   │   │   ├── auth_repository.dart
│   │   │   ├── recipe_repository.dart
│   │   │   ├── user_repository.dart
│   │   │   ├── food_log_repository.dart
│   │   │   ├── meal_plan_repository.dart
│   │   │   ├── pantry_repository.dart
│   │   │   └── shopping_list_repository.dart
│   │   └── services/
│   │       ├── firebase_service.dart
│   │       ├── local_storage_service.dart
│   │       ├── gemini_service.dart
│   │       └── notification_service.dart
│   ├── presentation/
│   │   ├── screens/
│   │   │   ├── splash/
│   │   │   │   └── splash_screen.dart
│   │   │   ├── auth/
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── register_screen.dart
│   │   │   ├── onboarding/
│   │   │   │   ├── welcome_screen.dart
│   │   │   │   ├── profile_setup_screen.dart
│   │   │   │   ├── goal_selection_screen.dart
│   │   │   │   └── dietary_preferences_screen.dart
│   │   │   ├── home/
│   │   │   │   └── home_screen.dart
│   │   │   ├── recipes/
│   │   │   │   ├── recipes_list_screen.dart
│   │   │   │   ├── recipe_detail_screen.dart
│   │   │   │   └── recipe_search_screen.dart
│   │   │   ├── meal_plans/
│   │   │   │   ├── meal_plans_screen.dart
│   │   │   │   └── meal_plan_detail_screen.dart
│   │   │   ├── pantry/
│   │   │   │   ├── pantry_screen.dart
│   │   │   │   └── add_ingredient_screen.dart
│   │   │   └── profile/
│   │   │       ├── profile_screen.dart
│   │   │       ├── settings_screen.dart
│   │   │       └── progress_screen.dart
│   │   ├── widgets/
│   │   │   ├── common/
│   │   │   │   ├── custom_button.dart
│   │   │   │   ├── custom_text_field.dart
│   │   │   │   ├── loading_indicator.dart
│   │   │   │   └── error_widget.dart
│   │   │   ├── recipe/
│   │   │   │   ├── recipe_card.dart
│   │   │   │   ├── ingredient_item.dart
│   │   │   │   └── nutrition_info.dart
│   │   │   ├── food_log/
│   │   │   │   ├── meal_log_card.dart
│   │   │   │   └── nutrition_progress_bar.dart
│   │   │   └── charts/
│   │   │       ├── macro_pie_chart.dart
│   │   │       └── progress_line_chart.dart
│   │   └── providers/
│   │       ├── auth_provider.dart
│   │       ├── recipe_provider.dart
│   │       ├── user_provider.dart
│   │       ├── food_log_provider.dart
│   │       ├── meal_plan_provider.dart
│   │       ├── pantry_provider.dart
│   │       └── shopping_list_provider.dart
│   └── l10n/
│       ├── app_ro.arb (Romanian translations)
│       └── app_en.arb (English translations - future)
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
├── firebase/
│   └── firestore_rules.txt
├── test/
│   ├── unit/
│   ├── widget/
│   └── integration/
├── pubspec.yaml
└── README.md
```

### 1.4 Update pubspec.yaml

Edit `pubspec.yaml` to include all required dependencies:

```yaml
name: mealee_app
description: Romanian recipe and meal planning app
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # State Management
  provider: ^6.1.1

  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  firebase_storage: ^11.6.0

  # Google Sign-In
  google_sign_in: ^6.2.1

  # Local Storage
  sqflite: ^2.3.0
  shared_preferences: ^2.2.2
  path_provider: ^2.1.1

  # Network & API
  http: ^1.2.0
  dio: ^5.4.0

  # UI & Animations
  cupertino_icons: ^1.0.2
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  lottie: ^3.0.0

  # Forms & Validation
  email_validator: ^2.1.17

  # Image Handling
  image_picker: ^1.0.7
  image_cropper: ^5.0.1

  # Charts
  fl_chart: ^0.66.0

  # Date & Time
  intl: ^0.18.1

  # Utilities
  uuid: ^4.3.3
  equatable: ^2.0.5

  # Camera & ML (for Phase 2 & 3)
  camera: ^0.10.5+9
  google_mlkit_text_recognition: ^0.11.0
  google_mlkit_barcode_scanning: ^0.10.0

  # Notifications
  flutter_local_notifications: ^16.3.0

  # PDF Generation (for premium features)
  pdf: ^3.10.8
  printing: ^5.12.0

  # Share functionality
  share_plus: ^7.2.1

  # URL Launcher
  url_launcher: ^6.2.4

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  mockito: ^5.4.4
  build_runner: ^2.4.8

flutter:
  uses-material-design: true

  assets:
    - assets/images/
    - assets/icons/

  fonts:
    - family: Roboto
      fonts:
        - asset: fonts/Roboto-Regular.ttf
        - asset: fonts/Roboto-Bold.ttf
          weight: 700
```

### 1.5 Firebase Project Setup

**Step 1: Create Firebase Project**

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Name it "Mealee" or "mealee-app"
4. Disable Google Analytics (optional for MVP)
5. Click "Create project"

**Step 2: Add Android App**

1. In Firebase console, click "Add app" → Android
2. Android package name: `com.mealee.app` (or your choice)
3. Download `google-services.json`
4. Place it in `android/app/` directory

**Step 3: Add iOS App**

1. Click "Add app" → iOS
2. iOS bundle ID: `com.mealee.app` (match Android)
3. Download `GoogleService-Info.plist`
4. Add to iOS project via Xcode

**Step 4: Configure Android**

Edit `android/build.gradle`:

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

Edit `android/app/build.gradle`:

```gradle
apply plugin: 'com.google.gms.google-services'

defaultConfig {
    minSdkVersion 21
    targetSdkVersion 34
    multiDexEnabled true
}

dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
}
```

**Step 5: Enable Firebase Services**

In Firebase Console:
1. **Authentication**: Enable Email/Password and Google Sign-In
2. **Firestore Database**: Create database in test mode (we'll add security rules later)
3. **Storage**: Enable Firebase Storage
4. **Cloud Functions**: Set up later for AI API calls

**Step 6: Initialize Firebase in Flutter**

Edit `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize local storage
  // await LocalStorageService.init();

  runApp(
    MultiProvider(
      providers: [
        // Providers will be added here
      ],
      child: const MealeeApp(),
    ),
  );
}
```

### 1.6 Create Firebase Security Rules

Create `firebase/firestore_rules.txt`:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }

    // Users collection
    match /users/{userId} {
      allow read: if isOwner(userId);
      allow create: if isAuthenticated();
      allow update: if isOwner(userId);
      allow delete: if isOwner(userId);
    }

    // Recipes collection (public read, admin write only)
    match /recipes/{recipeId} {
      allow read: if true; // Public recipes
      allow write: if false; // Only admin can write (use admin SDK)
    }

    // Food logs
    match /foodLogs/{logId} {
      allow read, write: if isOwner(resource.data.userId);
    }

    // Meal plans
    match /mealPlans/{planId} {
      allow read, write: if isOwner(resource.data.userId);
    }

    // Pantry items
    match /pantryItems/{itemId} {
      allow read, write: if isOwner(resource.data.userId);
    }

    // Shopping lists
    match /shoppingLists/{listId} {
      allow read, write: if isOwner(resource.data.userId);
    }
  }
}
```

Apply these rules in Firebase Console → Firestore Database → Rules.

---

## 2. Phase 1: MVP Development (Months 1-2)

### 2.1 Core Data Models

**Task 1.1: Create User Model**

File: `lib/data/models/user_model.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String email;
  final String displayName;
  final UserProfile? profile;
  final UserGoals? goals;
  final UserPreferences? preferences;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.userId,
    required this.email,
    required this.displayName,
    this.profile,
    this.goals,
    this.preferences,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      userId: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      profile: data['profile'] != null
          ? UserProfile.fromMap(data['profile'])
          : null,
      goals: data['goals'] != null
          ? UserGoals.fromMap(data['goals'])
          : null,
      preferences: data['preferences'] != null
          ? UserPreferences.fromMap(data['preferences'])
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'profile': profile?.toMap(),
      'goals': goals?.toMap(),
      'preferences': preferences?.toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

class UserProfile {
  final int age;
  final String gender; // 'male', 'female', 'other'
  final double height; // in cm
  final double weight; // in kg
  final String activityLevel; // 'sedentary', 'lightly_active', 'moderately_active', 'very_active'

  UserProfile({
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.activityLevel,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      age: map['age'] ?? 0,
      gender: map['gender'] ?? 'other',
      height: (map['height'] ?? 0).toDouble(),
      weight: (map['weight'] ?? 0).toDouble(),
      activityLevel: map['activityLevel'] ?? 'sedentary',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'activityLevel': activityLevel,
    };
  }
}

class UserGoals {
  final String goalType; // 'weight_loss', 'maintenance', 'weight_gain', 'general_health'
  final double calorieTarget;
  final double proteinTarget;
  final double carbsTarget;
  final double fatsTarget;

  UserGoals({
    required this.goalType,
    required this.calorieTarget,
    required this.proteinTarget,
    required this.carbsTarget,
    required this.fatsTarget,
  });

  factory UserGoals.fromMap(Map<String, dynamic> map) {
    return UserGoals(
      goalType: map['goalType'] ?? 'general_health',
      calorieTarget: (map['calorieTarget'] ?? 2000).toDouble(),
      proteinTarget: (map['proteinTarget'] ?? 150).toDouble(),
      carbsTarget: (map['carbsTarget'] ?? 200).toDouble(),
      fatsTarget: (map['fatsTarget'] ?? 65).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'goalType': goalType,
      'calorieTarget': calorieTarget,
      'proteinTarget': proteinTarget,
      'carbsTarget': carbsTarget,
      'fatsTarget': fatsTarget,
    };
  }
}

class UserPreferences {
  final List<String> dietaryRestrictions; // ['vegan', 'gluten_free', etc.]
  final List<String> allergies; // ['nuts', 'dairy', etc.]

  UserPreferences({
    required this.dietaryRestrictions,
    required this.allergies,
  });

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      dietaryRestrictions: List<String>.from(map['dietaryRestrictions'] ?? []),
      allergies: List<String>.from(map['allergies'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dietaryRestrictions': dietaryRestrictions,
      'allergies': allergies,
    };
  }
}
```

**Task 1.2: Create Recipe Model**

File: `lib/data/models/recipe_model.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeModel {
  final String recipeId;
  final String title;
  final String description;
  final String imageUrl;
  final int prepTime; // minutes
  final int cookTime; // minutes
  final int totalTime; // minutes
  final int servings;
  final String difficulty; // 'beginner', 'intermediate', 'advanced'
  final List<Ingredient> ingredients;
  final List<String> instructions;
  final Nutrition nutrition;
  final List<String> tags;
  final String category; // 'traditional_romanian', 'international', 'healthy'
  final String cuisine;
  final String mealType; // 'breakfast', 'lunch', 'dinner', 'snack', 'dessert'
  final DateTime createdAt;

  RecipeModel({
    required this.recipeId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.prepTime,
    required this.cookTime,
    required this.totalTime,
    required this.servings,
    required this.difficulty,
    required this.ingredients,
    required this.instructions,
    required this.nutrition,
    required this.tags,
    required this.category,
    required this.cuisine,
    required this.mealType,
    required this.createdAt,
  });

  factory RecipeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecipeModel(
      recipeId: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      prepTime: data['prepTime'] ?? 0,
      cookTime: data['cookTime'] ?? 0,
      totalTime: data['totalTime'] ?? 0,
      servings: data['servings'] ?? 1,
      difficulty: data['difficulty'] ?? 'beginner',
      ingredients: (data['ingredients'] as List<dynamic>?)
              ?.map((i) => Ingredient.fromMap(i as Map<String, dynamic>))
              .toList() ??
          [],
      instructions: List<String>.from(data['instructions'] ?? []),
      nutrition: Nutrition.fromMap(data['nutrition'] ?? {}),
      tags: List<String>.from(data['tags'] ?? []),
      category: data['category'] ?? '',
      cuisine: data['cuisine'] ?? '',
      mealType: data['mealType'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'totalTime': totalTime,
      'servings': servings,
      'difficulty': difficulty,
      'ingredients': ingredients.map((i) => i.toMap()).toList(),
      'instructions': instructions,
      'nutrition': nutrition.toMap(),
      'tags': tags,
      'category': category,
      'cuisine': cuisine,
      'mealType': mealType,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class Ingredient {
  final String name;
  final double quantity;
  final String unit; // 'g', 'ml', 'bucati', 'linguri', etc.

  Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      unit: map['unit'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
    };
  }
}

class Nutrition {
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final double healthScore; // 0-100 rating

  Nutrition({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    this.healthScore = 50.0,
  });

  factory Nutrition.fromMap(Map<String, dynamic> map) {
    return Nutrition(
      calories: (map['calories'] ?? 0).toDouble(),
      protein: (map['protein'] ?? 0).toDouble(),
      carbs: (map['carbs'] ?? 0).toDouble(),
      fats: (map['fats'] ?? 0).toDouble(),
      healthScore: (map['healthScore'] ?? 50).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'healthScore': healthScore,
    };
  }
}
```

**Task 1.3: Create Food Log Model**

File: `lib/data/models/food_log_model.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'recipe_model.dart';

class FoodLogModel {
  final String logId;
  final String userId;
  final DateTime date;
  final String mealType; // 'breakfast', 'lunch', 'dinner', 'snack'
  final String source; // 'recipe', 'manual', 'photo'
  final String? recipeId;
  final ManualEntry? manualEntry;
  final String? photoUrl;
  final Nutrition nutrition;
  final DateTime createdAt;

  FoodLogModel({
    required this.logId,
    required this.userId,
    required this.date,
    required this.mealType,
    required this.source,
    this.recipeId,
    this.manualEntry,
    this.photoUrl,
    required this.nutrition,
    required this.createdAt,
  });

  factory FoodLogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FoodLogModel(
      logId: doc.id,
      userId: data['userId'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      mealType: data['mealType'] ?? '',
      source: data['source'] ?? 'manual',
      recipeId: data['recipeId'],
      manualEntry: data['manualEntry'] != null
          ? ManualEntry.fromMap(data['manualEntry'])
          : null,
      photoUrl: data['photoUrl'],
      nutrition: Nutrition.fromMap(data['nutrition'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'mealType': mealType,
      'source': source,
      'recipeId': recipeId,
      'manualEntry': manualEntry?.toMap(),
      'photoUrl': photoUrl,
      'nutrition': nutrition.toMap(),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class ManualEntry {
  final String foodName;
  final double quantity;
  final String unit;

  ManualEntry({
    required this.foodName,
    required this.quantity,
    required this.unit,
  });

  factory ManualEntry.fromMap(Map<String, dynamic> map) {
    return ManualEntry(
      foodName: map['foodName'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      unit: map['unit'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'foodName': foodName,
      'quantity': quantity,
      'unit': unit,
    };
  }
}
```

### 2.2 Authentication System

**Task 2.1: Create Auth Repository**

File: `lib/data/repositories/auth_repository.dart`

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Sign up with email and password
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(displayName);

      // Create user document in Firestore
      await _createUserDocument(
        userId: userCredential.user!.uid,
        email: email,
        displayName: displayName,
      );

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in aborted');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      // Create user document if new user
      final userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      if (!userDoc.exists) {
        await _createUserDocument(
          userId: userCredential.user!.uid,
          email: userCredential.user!.email!,
          displayName: userCredential.user!.displayName ?? 'User',
        );
      }

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      rethrow;
    }
  }

  // Create user document in Firestore
  Future<void> _createUserDocument({
    required String userId,
    required String email,
    required String displayName,
  }) async {
    final userModel = UserModel(
      userId: userId,
      email: email,
      displayName: displayName,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firestore
        .collection('users')
        .doc(userId)
        .set(userModel.toFirestore());
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }
}
```

**Task 2.2: Create Auth Provider**

File: `lib/presentation/providers/auth_provider.dart`

```dart
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider(this._authRepository) {
    _authRepository.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authRepository.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authRepository.signInWithEmail(
        email: email,
        password: password,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authRepository.signInWithGoogle();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'weak-password':
          return 'Parola este prea slabă';
        case 'email-already-in-use':
          return 'Email-ul este deja folosit';
        case 'user-not-found':
          return 'Nu există cont cu acest email';
        case 'wrong-password':
          return 'Parolă incorectă';
        case 'invalid-email':
          return 'Email invalid';
        default:
          return 'A apărut o eroare. Vă rugăm încercați din nou.';
      }
    }
    return error.toString();
  }
}
```

**Task 2.3: Create Login Screen**

File: `lib/presentation/screens/auth/login_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Autentificare'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                const Icon(
                  Icons.restaurant_menu,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 32),

                // Title
                const Text(
                  'Bine ai revenit!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Conectează-te pentru a continua',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Email field
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduceți email-ul';
                    }
                    if (!value.contains('@')) {
                      return 'Email invalid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field
                CustomTextField(
                  controller: _passwordController,
                  label: 'Parolă',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduceți parola';
                    }
                    if (value.length < 6) {
                      return 'Parola trebuie să aibă cel puțin 6 caractere';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Error message
                if (authProvider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      authProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Login button
                CustomButton(
                  text: 'Autentificare',
                  onPressed: authProvider.isLoading ? null : _handleLogin,
                  isLoading: authProvider.isLoading,
                ),
                const SizedBox(height: 16),

                // Divider
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('SAU'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),

                // Google sign in
                OutlinedButton.icon(
                  onPressed: authProvider.isLoading ? null : _handleGoogleSignIn,
                  icon: const Icon(Icons.g_mobiledata, size: 24),
                  label: const Text('Continuă cu Google'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 24),

                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Nu ai cont? '),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text('Înregistrează-te'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      await context.read<AuthProvider>().signInWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    }
  }

  void _handleGoogleSignIn() async {
    await context.read<AuthProvider>().signInWithGoogle();
  }
}
```

**Task 2.4: Create Register Screen**

File: `lib/presentation/screens/auth/register_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Înregistrare'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),

                // Title
                const Text(
                  'Creează cont nou',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Completează informațiile de mai jos',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Name field
                CustomTextField(
                  controller: _nameController,
                  label: 'Nume',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduceți numele';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email field
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduceți email-ul';
                    }
                    if (!value.contains('@')) {
                      return 'Email invalid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field
                CustomTextField(
                  controller: _passwordController,
                  label: 'Parolă',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduceți parola';
                    }
                    if (value.length < 6) {
                      return 'Parola trebuie să aibă cel puțin 6 caractere';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm password field
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirmă parola',
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirmați parola';
                    }
                    if (value != _passwordController.text) {
                      return 'Parolele nu se potrivesc';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Error message
                if (authProvider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      authProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Register button
                CustomButton(
                  text: 'Creează cont',
                  onPressed: authProvider.isLoading ? null : _handleRegister,
                  isLoading: authProvider.isLoading,
                ),
                const SizedBox(height: 16),

                // Divider
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('SAU'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),

                // Google sign in
                OutlinedButton.icon(
                  onPressed: authProvider.isLoading ? null : _handleGoogleSignIn,
                  icon: const Icon(Icons.g_mobiledata, size: 24),
                  label: const Text('Continuă cu Google'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 24),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Ai deja cont? '),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Autentifică-te'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      await context.read<AuthProvider>().signUpWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            displayName: _nameController.text.trim(),
          );

      // Navigate to onboarding if successful
      if (context.read<AuthProvider>().isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    }
  }

  void _handleGoogleSignIn() async {
    await context.read<AuthProvider>().signInWithGoogle();

    if (context.read<AuthProvider>().isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    }
  }
}
```

### 2.3 Common Widgets

**Task 3.1: Create Custom Button**

File: `lib/presentation/widgets/common/custom_button.dart`

```dart
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        foregroundColor: textColor ?? Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
```

**Task 3.2: Create Custom Text Field**

File: `lib/presentation/widgets/common/custom_text_field.dart`

```dart
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final int maxLines;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
```

### 2.4 Onboarding Flow

**Task 4.1: Create Profile Setup Screen**

File: `lib/presentation/screens/onboarding/profile_setup_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  String _selectedGender = 'male';
  String _selectedActivityLevel = 'sedentary';

  final List<Map<String, String>> _genders = [
    {'value': 'male', 'label': 'Masculin'},
    {'value': 'female', 'label': 'Feminin'},
    {'value': 'other', 'label': 'Altul'},
  ];

  final List<Map<String, String>> _activityLevels = [
    {'value': 'sedentary', 'label': 'Sedentar (puțină sau deloc exercițiu)'},
    {'value': 'lightly_active', 'label': 'Ușor activ (exercițiu 1-3 zile/săptămână)'},
    {'value': 'moderately_active', 'label': 'Moderat activ (exercițiu 3-5 zile/săptămână)'},
    {'value': 'very_active', 'label': 'Foarte activ (exercițiu 6-7 zile/săptămână)'},
  ];

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Configurează-ți profilul',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Aceste informații ne ajută să calculăm nevoile tale calorice',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Gender selection
                const Text(
                  'Gen',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...(_genders.map((gender) => RadioListTile<String>(
                  title: Text(gender['label']!),
                  value: gender['value']!,
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ))),
                const SizedBox(height: 16),

                // Age field
                CustomTextField(
                  controller: _ageController,
                  label: 'Vârstă',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduceți vârsta';
                    }
                    final age = int.tryParse(value);
                    if (age == null || age < 13 || age > 120) {
                      return 'Vârstă invalidă';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Height field
                CustomTextField(
                  controller: _heightController,
                  label: 'Înălțime (cm)',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduceți înălțimea';
                    }
                    final height = double.tryParse(value);
                    if (height == null || height < 100 || height > 250) {
                      return 'Înălțime invalidă';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Weight field
                CustomTextField(
                  controller: _weightController,
                  label: 'Greutate (kg)',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduceți greutatea';
                    }
                    final weight = double.tryParse(value);
                    if (weight == null || weight < 30 || weight > 300) {
                      return 'Greutate invalidă';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Activity level
                const Text(
                  'Nivel de activitate',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedActivityLevel,
                      isExpanded: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      items: _activityLevels.map((level) {
                        return DropdownMenuItem<String>(
                          value: level['value'],
                          child: Text(level['label']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedActivityLevel = value!;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Continue button
                CustomButton(
                  text: 'Continuă',
                  onPressed: _handleContinue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleContinue() async {
    if (_formKey.currentState!.validate()) {
      // Save profile to provider
      final userProvider = context.read<UserProvider>();
      await userProvider.updateProfile(
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        activityLevel: _selectedActivityLevel,
      );

      // Navigate to goal selection
      Navigator.pushNamed(context, '/goal-selection');
    }
  }
}
```

**Task 4.2: Create Goal Selection Screen**

File: `lib/presentation/screens/onboarding/goal_selection_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/custom_button.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({Key? key}) : super(key: key);

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  String _selectedGoal = 'maintenance';

  final List<Map<String, dynamic>> _goals = [
    {
      'value': 'weight_loss',
      'label': 'Pierdere în greutate',
      'description': 'Vreau să slăbesc',
      'icon': Icons.trending_down,
    },
    {
      'value': 'maintenance',
      'label': 'Menținere',
      'description': 'Vreau să mențin greutatea actuală',
      'icon': Icons.horizontal_rule,
    },
    {
      'value': 'weight_gain',
      'label': 'Creștere în greutate',
      'description': 'Vreau să cresc masă musculară',
      'icon': Icons.trending_up,
    },
    {
      'value': 'general_health',
      'label': 'Sănătate generală',
      'description': 'Vreau să mănânc mai sănătos',
      'icon': Icons.favorite,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Obiectiv'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Care este obiectivul tău?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Te vom ajuta să atingi obiectivul stabilit',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Goals
              Expanded(
                child: ListView.builder(
                  itemCount: _goals.length,
                  itemBuilder: (context, index) {
                    final goal = _goals[index];
                    final isSelected = _selectedGoal == goal['value'];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedGoal = goal['value'];
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: isSelected
                                ? Theme.of(context).primaryColor.withOpacity(0.1)
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                goal['icon'],
                                size: 40,
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      goal['label'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Theme.of(context).primaryColor
                                            : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      goal['description'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).primaryColor,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Continue button
              CustomButton(
                text: 'Continuă',
                onPressed: _handleContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleContinue() async {
    final userProvider = context.read<UserProvider>();
    await userProvider.setGoal(_selectedGoal);

    // Navigate to dietary preferences
    Navigator.pushNamed(context, '/dietary-preferences');
  }
}
```

### 2.5 User Repository & Provider

**Task 5.1: Create User Repository**

File: `lib/data/repositories/user_repository.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Stream user data
  Stream<UserModel?> streamUser(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
  }

  // Update user profile
  Future<void> updateProfile({
    required String userId,
    required UserProfile profile,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'profile': profile.toMap(),
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Update user goals
  Future<void> updateGoals({
    required String userId,
    required UserGoals goals,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'goals': goals.toMap(),
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Update dietary preferences
  Future<void> updatePreferences({
    required String userId,
    required UserPreferences preferences,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'preferences': preferences.toMap(),
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Calculate calorie target based on profile and goal
  double calculateCalorieTarget({
    required UserProfile profile,
    required String goalType,
  }) {
    // Mifflin-St Jeor Equation
    double bmr;
    if (profile.gender == 'male') {
      bmr = 10 * profile.weight + 6.25 * profile.height - 5 * profile.age + 5;
    } else {
      bmr = 10 * profile.weight + 6.25 * profile.height - 5 * profile.age - 161;
    }

    // Activity multiplier
    double activityMultiplier;
    switch (profile.activityLevel) {
      case 'sedentary':
        activityMultiplier = 1.2;
        break;
      case 'lightly_active':
        activityMultiplier = 1.375;
        break;
      case 'moderately_active':
        activityMultiplier = 1.55;
        break;
      case 'very_active':
        activityMultiplier = 1.725;
        break;
      default:
        activityMultiplier = 1.2;
    }

    double tdee = bmr * activityMultiplier;

    // Adjust based on goal
    switch (goalType) {
      case 'weight_loss':
        return tdee - 500; // 0.5kg loss per week
      case 'weight_gain':
        return tdee + 300; // Moderate muscle gain
      case 'maintenance':
      case 'general_health':
      default:
        return tdee;
    }
  }

  // Calculate macro targets
  Map<String, double> calculateMacros({
    required double calorieTarget,
    required String goalType,
  }) {
    double proteinPercent;
    double carbsPercent;
    double fatsPercent;

    switch (goalType) {
      case 'weight_loss':
        proteinPercent = 0.30;
        carbsPercent = 0.40;
        fatsPercent = 0.30;
        break;
      case 'weight_gain':
        proteinPercent = 0.25;
        carbsPercent = 0.50;
        fatsPercent = 0.25;
        break;
      case 'maintenance':
      case 'general_health':
      default:
        proteinPercent = 0.25;
        carbsPercent = 0.45;
        fatsPercent = 0.30;
    }

    return {
      'protein': (calorieTarget * proteinPercent) / 4, // 4 cal per gram
      'carbs': (calorieTarget * carbsPercent) / 4, // 4 cal per gram
      'fats': (calorieTarget * fatsPercent) / 9, // 9 cal per gram
    };
  }
}
```

**Task 5.2: Create User Provider**

File: `lib/presentation/providers/user_provider.dart`

```dart
import 'package:flutter/foundation.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository;
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserProvider(this._userRepository);

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load user data
  Future<void> loadUser(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentUser = await _userRepository.getUserById(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Stream user data
  void streamUser(String userId) {
    _userRepository.streamUser(userId).listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  // Update profile
  Future<void> updateProfile({
    required int age,
    required String gender,
    required double height,
    required double weight,
    required String activityLevel,
  }) async {
    if (_currentUser == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final profile = UserProfile(
        age: age,
        gender: gender,
        height: height,
        weight: weight,
        activityLevel: activityLevel,
      );

      await _userRepository.updateProfile(
        userId: _currentUser!.userId,
        profile: profile,
      );

      // Reload user
      await loadUser(_currentUser!.userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Set goal and calculate calorie/macro targets
  Future<void> setGoal(String goalType) async {
    if (_currentUser == null || _currentUser!.profile == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      // Calculate calorie target
      final calorieTarget = _userRepository.calculateCalorieTarget(
        profile: _currentUser!.profile!,
        goalType: goalType,
      );

      // Calculate macros
      final macros = _userRepository.calculateMacros(
        calorieTarget: calorieTarget,
        goalType: goalType,
      );

      final goals = UserGoals(
        goalType: goalType,
        calorieTarget: calorieTarget,
        proteinTarget: macros['protein']!,
        carbsTarget: macros['carbs']!,
        fatsTarget: macros['fats']!,
      );

      await _userRepository.updateGoals(
        userId: _currentUser!.userId,
        goals: goals,
      );

      // Reload user
      await loadUser(_currentUser!.userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Update dietary preferences
  Future<void> updatePreferences({
    required List<String> dietaryRestrictions,
    required List<String> allergies,
  }) async {
    if (_currentUser == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final preferences = UserPreferences(
        dietaryRestrictions: dietaryRestrictions,
        allergies: allergies,
      );

      await _userRepository.updatePreferences(
        userId: _currentUser!.userId,
        preferences: preferences,
      );

      // Reload user
      await loadUser(_currentUser!.userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
```

### 2.6 Recipe System

**Task 6.1: Create Recipe Repository**

File: `lib/data/repositories/recipe_repository.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe_model.dart';

class RecipeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all recipes (paginated)
  Future<List<RecipeModel>> getRecipes({
    int limit = 20,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query query = _firestore
          .collection('recipes')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => RecipeModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get recipe by ID
  Future<RecipeModel?> getRecipeById(String recipeId) async {
    try {
      final doc = await _firestore.collection('recipes').doc(recipeId).get();
      if (doc.exists) {
        return RecipeModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Search recipes
  Future<List<RecipeModel>> searchRecipes({
    String? query,
    String? category,
    String? mealType,
    String? difficulty,
    List<String>? tags,
  }) async {
    try {
      Query firestoreQuery = _firestore.collection('recipes');

      if (category != null) {
        firestoreQuery = firestoreQuery.where('category', isEqualTo: category);
      }

      if (mealType != null) {
        firestoreQuery = firestoreQuery.where('mealType', isEqualTo: mealType);
      }

      if (difficulty != null) {
        firestoreQuery = firestoreQuery.where('difficulty', isEqualTo: difficulty);
      }

      if (tags != null && tags.isNotEmpty) {
        firestoreQuery = firestoreQuery.where('tags', arrayContainsAny: tags);
      }

      final snapshot = await firestoreQuery.limit(50).get();
      List<RecipeModel> recipes = snapshot.docs
          .map((doc) => RecipeModel.fromFirestore(doc))
          .toList();

      // Filter by title/description if query provided
      if (query != null && query.isNotEmpty) {
        recipes = recipes.where((recipe) {
          return recipe.title.toLowerCase().contains(query.toLowerCase()) ||
              recipe.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }

      return recipes;
    } catch (e) {
      rethrow;
    }
  }

  // Filter by cooking time
  Future<List<RecipeModel>> getRecipesByTimeRange({
    required int maxMinutes,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('recipes')
          .where('totalTime', isLessThanOrEqualTo: maxMinutes)
          .limit(50)
          .get();

      return snapshot.docs
          .map((doc) => RecipeModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
```

**Task 6.2: Create Recipe Provider**

File: `lib/presentation/providers/recipe_provider.dart`

```dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/recipe_model.dart';
import '../../data/repositories/recipe_repository.dart';

class RecipeProvider with ChangeNotifier {
  final RecipeRepository _recipeRepository;
  List<RecipeModel> _recipes = [];
  RecipeModel? _selectedRecipe;
  bool _isLoading = false;
  String? _errorMessage;
  DocumentSnapshot? _lastDocument;

  RecipeProvider(this._recipeRepository);

  List<RecipeModel> get recipes => _recipes;
  RecipeModel? get selectedRecipe => _selectedRecipe;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load recipes
  Future<void> loadRecipes({bool loadMore = false}) async {
    try {
      _isLoading = true;
      if (!loadMore) {
        _recipes = [];
      }
      notifyListeners();

      // This is a simplified version - in real app, get lastDocument from Firestore
      final newRecipes = await _recipeRepository.getRecipes(
        startAfter: loadMore ? _lastDocument : null,
      );

      _recipes.addAll(newRecipes);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Load single recipe
  Future<void> loadRecipe(String recipeId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _selectedRecipe = await _recipeRepository.getRecipeById(recipeId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Search recipes
  Future<void> searchRecipes({
    String? query,
    String? category,
    String? mealType,
    String? difficulty,
    List<String>? tags,
  }) async {
    try {
      _isLoading = true;
      _recipes = [];
      notifyListeners();

      _recipes = await _recipeRepository.searchRecipes(
        query: query,
        category: category,
        mealType: mealType,
        difficulty: difficulty,
        tags: tags,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
```

**Task 6.3: Create Recipe Card Widget**

File: `lib/presentation/widgets/recipe/recipe_card.dart`

```dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/recipe_model.dart';

class RecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final VoidCallback onTap;

  const RecipeCard({
    Key? key,
    required this.recipe,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: recipe.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.restaurant, size: 50),
                ),
              ),
            ),

            // Recipe details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Metadata row
                  Row(
                    children: [
                      Icon(
                        Icons.timer,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe.totalTime} min',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.local_fire_department,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe.nutrition.calories.toInt()} kcal',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Difficulty badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(recipe.difficulty).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getDifficultyLabel(recipe.difficulty),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getDifficultyColor(recipe.difficulty),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getDifficultyLabel(String difficulty) {
    switch (difficulty) {
      case 'beginner':
        return 'Ușor';
      case 'intermediate':
        return 'Mediu';
      case 'advanced':
        return 'Avansat';
      default:
        return 'Necunoscut';
    }
  }
}
```

**Task 6.4: Create Recipes List Screen**

File: `lib/presentation/screens/recipes/recipes_list_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/recipe_provider.dart';
import '../../widgets/recipe/recipe_card.dart';

class RecipesListScreen extends StatefulWidget {
  const RecipesListScreen({Key? key}) : super(key: key);

  @override
  State<RecipesListScreen> createState() => _RecipesListScreenState();
}

class _RecipesListScreenState extends State<RecipesListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<RecipeProvider>().loadRecipes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rețete'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/recipe-search');
            },
          ),
        ],
      ),
      body: recipeProvider.isLoading && recipeProvider.recipes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : recipeProvider.recipes.isEmpty
              ? const Center(
                  child: Text('Nu există rețete disponibile'),
                )
              : RefreshIndicator(
                  onRefresh: () => recipeProvider.loadRecipes(),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: recipeProvider.recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipeProvider.recipes[index];
                      return RecipeCard(
                        recipe: recipe,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/recipe-detail',
                            arguments: recipe.recipeId,
                          );
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
```

### 2.7 Food Logging System

**Task 7.1: Create Food Log Repository**

File: `lib/data/repositories/food_log_repository.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_log_model.dart';

class FoodLogRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create food log
  Future<void> createFoodLog(FoodLogModel foodLog) async {
    try {
      await _firestore
          .collection('foodLogs')
          .doc(foodLog.logId)
          .set(foodLog.toFirestore());
    } catch (e) {
      rethrow;
    }
  }

  // Get food logs for a specific date
  Future<List<FoodLogModel>> getFoodLogsByDate({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await _firestore
          .collection('foodLogs')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThan: Timestamp.fromDate(endOfDay))
          .orderBy('date')
          .get();

      return snapshot.docs
          .map((doc) => FoodLogModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Delete food log
  Future<void> deleteFoodLog(String logId) async {
    try {
      await _firestore.collection('foodLogs').doc(logId).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Get nutrition summary for date
  Future<Map<String, double>> getNutritionSummary({
    required String userId,
    required DateTime date,
  }) async {
    final logs = await getFoodLogsByDate(userId: userId, date: date);

    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFats = 0;

    for (var log in logs) {
      totalCalories += log.nutrition.calories;
      totalProtein += log.nutrition.protein;
      totalCarbs += log.nutrition.carbs;
      totalFats += log.nutrition.fats;
    }

    return {
      'calories': totalCalories,
      'protein': totalProtein,
      'carbs': totalCarbs,
      'fats': totalFats,
    };
  }
}
```

### 2.8 Navigation & App Setup

**Task 8.1: Create App Theme**

File: `lib/core/theme/app_theme.dart`

```dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: const Color(0xFF4CAF50), // Green
      primarySwatch: Colors.green,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4CAF50)),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
```

**Task 8.2: Create Routes**

File: `lib/core/constants/app_routes.dart`

```dart
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String onboarding = '/onboarding';
  static const String profileSetup = '/profile-setup';
  static const String goalSelection = '/goal-selection';
  static const String dietaryPreferences = '/dietary-preferences';
  static const String home = '/home';
  static const String recipesList = '/recipes';
  static const String recipeDetail = '/recipe-detail';
  static const String recipeSearch = '/recipe-search';
  static const String mealPlans = '/meal-plans';
  static const String pantry = '/pantry';
  static const String profile = '/profile';
  static const String settings = '/settings';
}
```

**Task 8.3: Create Main App File**

File: `lib/app.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_routes.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/onboarding/profile_setup_screen.dart';
import 'presentation/screens/onboarding/goal_selection_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/recipes/recipes_list_screen.dart';
import 'presentation/providers/auth_provider.dart';

class MealeeApp extends StatelessWidget {
  const MealeeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mealee',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.isAuthenticated) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.profileSetup: (context) => const ProfileSetupScreen(),
        AppRoutes.goalSelection: (context) => const GoalSelectionScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.recipesList: (context) => const RecipesListScreen(),
      },
    );
  }
}
```

**Task 8.4: Update main.dart with all providers**

File: `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/recipe_repository.dart';
import 'data/repositories/food_log_repository.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/user_provider.dart';
import 'presentation/providers/recipe_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize repositories
  final authRepository = AuthRepository();
  final userRepository = UserRepository();
  final recipeRepository = RecipeRepository();
  final foodLogRepository = FoodLogRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(userRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => RecipeProvider(recipeRepository),
        ),
        // Add more providers as needed
      ],
      child: const MealeeApp(),
    ),
  );
}
```

### 2.9 Home Dashboard (MVP Final Component)

**Task 9.1: Create Home Screen**

File: `lib/presentation/screens/home/home_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardTab(),
    const RecipesTab(),
    const MealPlansTab(),
    const PantryTab(),
    const ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user != null) {
      context.read<UserProvider>().streamUser(authProvider.user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Acasă',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Rețete',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Plan Mese',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.kitchen),
            label: 'Cămară',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// Dashboard Tab
class DashboardTab extends StatelessWidget {
  const DashboardTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acasă'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome message
                  Text(
                    'Bună, ${user.displayName}!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hai să atingem obiectivele de astăzi',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Daily nutrition progress
                  if (user.goals != null) ...[
                    _buildNutritionCard(user),
                    const SizedBox(height: 24),
                  ],

                  // Quick actions
                  const Text(
                    'Acțiuni rapide',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          context,
                          icon: Icons.add_circle,
                          label: 'Adaugă masă',
                          onTap: () {
                            // TODO: Navigate to add food log
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildQuickActionCard(
                          context,
                          icon: Icons.camera_alt,
                          label: 'Scanează ingrediente',
                          onTap: () {
                            // TODO: Navigate to scan ingredients
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Suggested recipes
                  const Text(
                    'Rețete sugerate',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // TODO: Add recipe suggestions
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('Rețete sugerate vor apărea aici'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildNutritionCard(user) {
    final goals = user.goals!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progres zilnic',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Calories
            _buildProgressRow(
              label: 'Calorii',
              current: 0, // TODO: Get from food logs
              target: goals.calorieTarget,
              unit: 'kcal',
              color: Colors.blue,
            ),
            const SizedBox(height: 12),

            // Protein
            _buildProgressRow(
              label: 'Proteine',
              current: 0,
              target: goals.proteinTarget,
              unit: 'g',
              color: Colors.red,
            ),
            const SizedBox(height: 12),

            // Carbs
            _buildProgressRow(
              label: 'Carbohidrați',
              current: 0,
              target: goals.carbsTarget,
              unit: 'g',
              color: Colors.orange,
            ),
            const SizedBox(height: 12),

            // Fats
            _buildProgressRow(
              label: 'Grăsimi',
              current: 0,
              target: goals.fatsTarget,
              unit: 'g',
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRow({
    required String label,
    required double current,
    required double target,
    required String unit,
    required Color color,
  }) {
    final progress = current / target;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              '${current.toInt()} / ${target.toInt()} $unit',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 40,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder tabs (implement in detail later)
class RecipesTab extends StatelessWidget {
  const RecipesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RecipesListScreen();
  }
}

class MealPlansTab extends StatelessWidget {
  const MealPlansTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plan Mese')),
      body: const Center(child: Text('Meal Plans - Coming in Phase 2')),
    );
  }
}

class PantryTab extends StatelessWidget {
  const PantryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cămară')),
      body: const Center(child: Text('Pantry - Coming in Phase 3')),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Setări'),
            onTap: () {
              // TODO: Navigate to settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Ajutor'),
            onTap: () {
              // TODO: Navigate to help
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Deconectare'),
            onTap: () async {
              await authProvider.signOut();
            },
          ),
        ],
      ),
    );
  }
}
```

---

## 3. Phase 2: AI Integration (Month 3)

### 3.1 Google Gemini Setup

**Task 1: Configure Gemini API**

1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create API key
3. Add to environment config

File: `lib/core/config/env_config.dart`

```dart
class EnvConfig {
  static const String geminiApiKey = 'YOUR_GEMINI_API_KEY';
}
```

**Task 2: Create Gemini Service**

File: `lib/data/services/gemini_service.dart`

```dart
import 'package:dio/dio.dart';
import '../../core/config/env_config.dart';

class GeminiService {
  final Dio _dio = Dio();
  static const String baseUrl = 'https://generativelanguage.googleapis.com/v1beta';

  // Generate content (text-based)
  Future<String> generateContent(String prompt) async {
    try {
      final response = await _dio.post(
        '$baseUrl/models/gemini-pro:generateContent',
        queryParameters: {'key': EnvConfig.geminiApiKey},
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ]
        },
      );

      return response.data['candidates'][0]['content']['parts'][0]['text'];
    } catch (e) {
      rethrow;
    }
  }

  // Analyze image (vision)
  Future<List<String>> analyzeImage(String base64Image) async {
    try {
      final response = await _dio.post(
        '$baseUrl/models/gemini-pro-vision:generateContent',
        queryParameters: {'key': EnvConfig.geminiApiKey},
        data: {
          'contents': [
            {
              'parts': [
                {
                  'text': 'Identify all food ingredients in this image. List them one per line with their estimated quantities.'
                },
                {
                  'inline_data': {
                    'mime_type': 'image/jpeg',
                    'data': base64Image,
                  }
                }
              ]
            }
          ]
        },
      );

      final text = response.data['candidates'][0]['content']['parts'][0]['text'];
      return text.split('\n').where((line) => line.trim().isNotEmpty).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Suggest recipes based on ingredients
  Future<List<String>> suggestRecipes(List<String> ingredients) async {
    final prompt = '''
Based on these available ingredients: ${ingredients.join(', ')}

Suggest 5 recipes that can be made using primarily these ingredients.
For each recipe, provide:
1. Recipe name
2. Brief description
3. Which ingredients from the list are used

Format as JSON array with objects containing: name, description, usedIngredients
''';

    final response = await generateContent(prompt);
    // Parse response and return recipe suggestions
    return []; // TODO: Parse JSON response
  }

  // Generate meal plan
  Future<Map<String, dynamic>> generateMealPlan({
    required double calorieTarget,
    required double proteinTarget,
    required List<String> dietaryRestrictions,
    required int days,
  }) async {
    final prompt = '''
Generate a $days-day meal plan with the following requirements:
- Daily calorie target: $calorieTarget kcal
- Daily protein target: $proteinTarget g
- Dietary restrictions: ${dietaryRestrictions.join(', ')}

For each day, provide breakfast, lunch, dinner with:
- Meal name
- Estimated calories
- Estimated protein (g)

Format as JSON with structure: {days: [{day: number, meals: [{type, name, calories, protein}]}]}
''';

    final response = await generateContent(prompt);
    // Parse response and return meal plan
    return {}; // TODO: Parse JSON response
  }
}
```

### 3.2 AI Recipe Suggestions Feature

**Task 3: Create Ingredient Scanner Screen**

File: `lib/presentation/screens/ai/ingredient_scanner_screen.dart`

```dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/services/gemini_service.dart';
import '../../widgets/common/custom_button.dart';

class IngredientScannerScreen extends StatefulWidget {
  const IngredientScannerScreen({Key? key}) : super(key: key);

  @override
  State<IngredientScannerScreen> createState() => _IngredientScannerScreenState();
}

class _IngredientScannerScreenState extends State<IngredientScannerScreen> {
  final ImagePicker _picker = ImagePicker();
  final GeminiService _geminiService = GeminiService();
  final List<File> _images = [];
  final List<String> _detectedIngredients = [];
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _images.add(File(image.path));
      });
    }
  }

  Future<void> _analyzeImages() async {
    setState(() {
      _isLoading = true;
      _detectedIngredients.clear();
    });

    try {
      for (var image in _images) {
        final bytes = await image.readAsBytes();
        final base64Image = base64Encode(bytes);
        final ingredients = await _geminiService.analyzeImage(base64Image);
        _detectedIngredients.addAll(ingredients);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eroare: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _findRecipes() async {
    if (_detectedIngredients.isEmpty) return;

    // Navigate to recipe suggestions with ingredients
    // TODO: Implement recipe suggestions screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanează Ingrediente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Instructions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 48,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Fotografiază ingredientele disponibile',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Poți adăuga multiple poze pentru mai multe ingrediente',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Captured images
            if (_images.isNotEmpty) ...[
              const Text(
                'Poze capturate:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _images[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _images.removeAt(index);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Detected ingredients
            if (_detectedIngredients.isNotEmpty) ...[
              const Text(
                'Ingrediente detectate:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _detectedIngredients.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.check_circle, color: Colors.green),
                        title: Text(_detectedIngredients[index]),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ] else if (!_isLoading)
              const Spacer(),

            // Loading
            if (_isLoading)
              const Center(child: CircularProgressIndicator()),

            // Buttons
            if (!_isLoading) ...[
              CustomButton(
                text: _images.isEmpty ? 'Adaugă poză' : 'Adaugă altă poză',
                onPressed: _pickImage,
              ),
              if (_images.isNotEmpty && _detectedIngredients.isEmpty) ...[
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Analizează ingrediente',
                  onPressed: _analyzeImages,
                ),
              ],
              if (_detectedIngredients.isNotEmpty) ...[
                const SizedBox(height: 16),
                CustomButton(
                  text: 'Găsește rețete',
                  onPressed: _findRecipes,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
```

---

## 4. Phase 3: Advanced Features (Months 4-5)

### 4.1 Pantry Management

**Task 1: Create Pantry Models**

File: `lib/data/models/pantry_item_model.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class PantryItemModel {
  final String itemId;
  final String userId;
  final String ingredientName;
  final double quantity;
  final String unit;
  final DateTime addedDate;
  final String source; // 'manual' or 'receipt'

  PantryItemModel({
    required this.itemId,
    required this.userId,
    required this.ingredientName,
    required this.quantity,
    required this.unit,
    required this.addedDate,
    required this.source,
  });

  factory PantryItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PantryItemModel(
      itemId: doc.id,
      userId: data['userId'] ?? '',
      ingredientName: data['ingredientName'] ?? '',
      quantity: (data['quantity'] ?? 0).toDouble(),
      unit: data['unit'] ?? '',
      addedDate: (data['addedDate'] as Timestamp).toDate(),
      source: data['source'] ?? 'manual',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'ingredientName': ingredientName,
      'quantity': quantity,
      'unit': unit,
      'addedDate': Timestamp.fromDate(addedDate),
      'source': source,
    };
  }
}
```

### 4.2 Shopping List

**Task 2: Create Shopping List Model**

File: `lib/data/models/shopping_list_model.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingListModel {
  final String listId;
  final String userId;
  final List<ShoppingItem> items;
  final String createdFrom; // 'mealPlan' or 'manual'
  final DateTime createdAt;

  ShoppingListModel({
    required this.listId,
    required this.userId,
    required this.items,
    required this.createdFrom,
    required this.createdAt,
  });

  factory ShoppingListModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ShoppingListModel(
      listId: doc.id,
      userId: data['userId'] ?? '',
      items: (data['items'] as List<dynamic>?)
              ?.map((i) => ShoppingItem.fromMap(i as Map<String, dynamic>))
              .toList() ??
          [],
      createdFrom: data['createdFrom'] ?? 'manual',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'items': items.map((i) => i.toMap()).toList(),
      'createdFrom': createdFrom,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class ShoppingItem {
  final String ingredient;
  final double quantity;
  final String unit;
  final bool checked;
  final bool inPantry;

  ShoppingItem({
    required this.ingredient,
    required this.quantity,
    required this.unit,
    this.checked = false,
    this.inPantry = false,
  });

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      ingredient: map['ingredient'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      unit: map['unit'] ?? '',
      checked: map['checked'] ?? false,
      inPantry: map['inPantry'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ingredient': ingredient,
      'quantity': quantity,
      'unit': unit,
      'checked': checked,
      'inPantry': inPantry,
    };
  }
}
```

### 4.3 Offline Mode Implementation

**Task 3: Create Local Storage Service**

File: `lib/data/services/local_storage_service.dart`

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/recipe_model.dart';
import '../models/food_log_model.dart';

class LocalStorageService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'mealee.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create recipes table
        await db.execute('''
          CREATE TABLE recipes(
            id TEXT PRIMARY KEY,
            data TEXT,
            cached_at INTEGER
          )
        ''');

        // Create food logs table
        await db.execute('''
          CREATE TABLE food_logs(
            id TEXT PRIMARY KEY,
            data TEXT,
            synced INTEGER DEFAULT 0
          )
        ''');

        // Create meal plans table
        await db.execute('''
          CREATE TABLE meal_plans(
            id TEXT PRIMARY KEY,
            data TEXT,
            downloaded_at INTEGER
          )
        ''');
      },
    );
  }

  // Cache recipe
  static Future<void> cacheRecipe(RecipeModel recipe) async {
    final db = await database;
    await db.insert(
      'recipes',
      {
        'id': recipe.recipeId,
        'data': recipe.toFirestore().toString(), // Convert to JSON string
        'cached_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Save unsynced food log
  static Future<void> saveUnsyncedFoodLog(FoodLogModel foodLog) async {
    final db = await database;
    await db.insert(
      'food_logs',
      {
        'id': foodLog.logId,
        'data': foodLog.toFirestore().toString(),
        'synced': 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get unsynced food logs
  static Future<List<Map<String, dynamic>>> getUnsyncedFoodLogs() async {
    final db = await database;
    return await db.query(
      'food_logs',
      where: 'synced = ?',
      whereArgs: [0],
    );
  }

  // Mark food log as synced
  static Future<void> markFoodLogAsSynced(String logId) async {
    final db = await database;
    await db.update(
      'food_logs',
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [logId],
    );
  }
}
```

---

## 5. Phase 4: Polish & Scale (Month 6+)

### 5.1 Performance Optimization

**Task 1: Add Image Caching**

Already implemented via `cached_network_image` package in recipe cards.

**Task 2: Implement Pagination for Recipes**

Already set up in RecipeRepository with `startAfter` parameter.

**Task 3: Add Analytics**

Add Firebase Analytics:

```yaml
# pubspec.yaml
dependencies:
  firebase_analytics: ^10.8.0
```

File: `lib/data/services/analytics_service.dart`

```dart
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future<void> logEvent(String name, Map<String, dynamic>? parameters) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  static Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  static Future<void> logRecipeView(String recipeId) async {
    await _analytics.logEvent(
      name: 'recipe_view',
      parameters: {'recipe_id': recipeId},
    );
  }

  static Future<void> logFoodLog(String source) async {
    await _analytics.logEvent(
      name: 'food_logged',
      parameters: {'source': source},
    );
  }
}
```

### 5.2 Push Notifications

**Task 4: Configure Firebase Cloud Messaging**

```yaml
# pubspec.yaml
dependencies:
  firebase_messaging: ^14.7.10
```

File: `lib/data/services/notification_service.dart`

```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Request permission
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token
    String? token = await _messaging.getToken();
    print('FCM Token: $token');

    // Configure local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(settings);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'mealee_channel',
      'Mealee Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      details,
    );
  }

  static Future<void> scheduleReminderNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    // TODO: Implement scheduled notifications for meal reminders
  }
}
```

---

## 6. Testing Strategy

### 6.1 Unit Tests

Create test files in `test/unit/` directory.

Example: `test/unit/user_repository_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mealee_app/data/repositories/user_repository.dart';
import 'package:mealee_app/data/models/user_model.dart';

void main() {
  group('UserRepository', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = UserRepository();
    });

    test('calculateCalorieTarget returns correct value for weight loss', () {
      final profile = UserProfile(
        age: 30,
        gender: 'male',
        height: 180,
        weight: 80,
        activityLevel: 'moderately_active',
      );

      final calorieTarget = userRepository.calculateCalorieTarget(
        profile: profile,
        goalType: 'weight_loss',
      );

      expect(calorieTarget, greaterThan(1500));
      expect(calorieTarget, lessThan(3000));
    });

    test('calculateMacros returns correct distribution', () {
      final macros = userRepository.calculateMacros(
        calorieTarget: 2000,
        goalType: 'maintenance',
      );

      expect(macros['protein'], isNotNull);
      expect(macros['carbs'], isNotNull);
      expect(macros['fats'], isNotNull);

      // Check if total calories roughly match
      final totalCals = (macros['protein']! * 4) +
          (macros['carbs']! * 4) +
          (macros['fats']! * 9);

      expect(totalCals, closeTo(2000, 50));
    });
  });
}
```

### 6.2 Widget Tests

Example: `test/widget/login_screen_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mealee_app/presentation/screens/auth/login_screen.dart';
import 'package:mealee_app/presentation/providers/auth_provider.dart';

void main() {
  testWidgets('LoginScreen displays email and password fields', (WidgetTester tester) async {
    // Create mock auth provider
    final mockAuthProvider = MockAuthProvider();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AuthProvider>.value(
          value: mockAuthProvider,
          child: const LoginScreen(),
        ),
      ),
    );

    // Verify email field exists
    expect(find.byType(TextField), findsNWidgets(2));

    // Verify login button exists
    expect(find.text('Autentificare'), findsOneWidget);

    // Verify Google sign-in button exists
    expect(find.text('Continuă cu Google'), findsOneWidget);
  });
}

class MockAuthProvider extends Mock implements AuthProvider {}
```

### 6.3 Integration Tests

Example: `test/integration/auth_flow_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mealee_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete authentication flow', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Should show login screen
    expect(find.text('Bine ai revenit!'), findsOneWidget);

    // Tap register link
    await tester.tap(find.text('Înregistrează-te'));
    await tester.pumpAndSettle();

    // Should navigate to register screen
    expect(find.text('Creează cont nou'), findsOneWidget);

    // Fill in registration form
    await tester.enterText(find.byType(TextField).at(0), 'Test User');
    await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'password123');
    await tester.enterText(find.byType(TextField).at(3), 'password123');

    // Tap register button
    await tester.tap(find.text('Creează cont'));
    await tester.pumpAndSettle();

    // Should navigate to onboarding
    // Note: This requires proper Firebase test setup
  });
}
```

---

## 7. Deployment Guide

### 7.1 Android Deployment

**Step 1: Configure App Signing**

1. Generate keystore:
```bash
keytool -genkey -v -keystore ~/mealee-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias mealee
```

2. Create `android/key.properties`:
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=mealee
storeFile=~/mealee-key.jks
```

3. Update `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

**Step 2: Build Release APK/AAB**

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

**Step 3: Upload to Google Play Console**

1. Create app in Play Console
2. Upload AAB file
3. Complete store listing
4. Set up pricing & distribution
5. Submit for review

### 7.2 iOS Deployment

**Step 1: Configure Xcode**

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner → Signing & Capabilities
3. Select your team
4. Set bundle identifier: `com.mealee.app`

**Step 2: Configure App Store Connect**

1. Create app in App Store Connect
2. Fill in app information
3. Add screenshots
4. Set pricing

**Step 3: Build and Archive**

```bash
# Build iOS release
flutter build ios --release

# Or build and archive in Xcode
# Product → Archive → Distribute App
```

**Step 4: Submit to App Store**

1. Validate build
2. Upload to App Store Connect
3. Submit for review

### 7.3 Environment Variables & Secrets

**For Production:**

1. Create separate Firebase projects for dev/staging/prod
2. Use different API keys for each environment
3. Never commit API keys to Git
4. Use Flutter flavor configuration:

```dart
// lib/core/config/flavor_config.dart
enum Flavor { dev, staging, production }

class FlavorConfig {
  final Flavor flavor;
  final String apiKey;
  final String firebaseProjectId;

  FlavorConfig({
    required this.flavor,
    required this.apiKey,
    required this.firebaseProjectId,
  });

  static FlavorConfig? _instance;
  static FlavorConfig get instance => _instance!;

  static void initialize({required FlavorConfig config}) {
    _instance = config;
  }
}
```

### 7.4 Initial Recipe Data

**Upload seed recipes to Firestore:**

Create admin script: `scripts/seed_recipes.dart`

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> seedRecipes() async {
  await Firebase.initializeApp();
  final firestore = FirebaseFirestore.instance;

  final recipes = [
    {
      'title': 'Sarmale',
      'description': 'Sarmale tradiționale românești cu carne de porc și orez',
      'imageUrl': 'https://example.com/sarmale.jpg',
      'prepTime': 60,
      'cookTime': 180,
      'totalTime': 240,
      'servings': 6,
      'difficulty': 'intermediate',
      'ingredients': [
        {'name': 'Foi varză murată', 'quantity': 1, 'unit': 'kg'},
        {'name': 'Carne tocată porc', 'quantity': 500, 'unit': 'g'},
        {'name': 'Orez', 'quantity': 150, 'unit': 'g'},
        {'name': 'Ceapă', 'quantity': 2, 'unit': 'bucăți'},
        {'name': 'Bulion', 'quantity': 500, 'unit': 'ml'},
      ],
      'instructions': [
        'Călește ceapa în ulei',
        'Amestecă carnea cu orezul și ceapa',
        'Umple frunzele de varză cu amestec',
        'Pune sarmalele în oală și adaugă bulion',
        'Fierbe la foc mic 3 ore',
      ],
      'nutrition': {
        'calories': 450,
        'protein': 25,
        'carbs': 35,
        'fats': 22,
        'healthScore': 65,
      },
      'tags': ['traditional', 'romanian', 'comfort_food'],
      'category': 'traditional_romanian',
      'cuisine': 'Romanian',
      'mealType': 'lunch',
      'createdAt': FieldValue.serverTimestamp(),
    },
    // Add 49-99 more recipes here...
  ];

  for (var recipe in recipes) {
    await firestore.collection('recipes').add(recipe);
  }

  print('Seeded ${recipes.length} recipes');
}

void main() async {
  await seedRecipes();
}
```

Run: `dart scripts/seed_recipes.dart`

---

## 8. Project Milestones & Timeline

### Month 1
- ✅ Week 1: Project setup, Firebase configuration
- ✅ Week 2: Authentication system complete
- ✅ Week 3: User models & onboarding flow
- ✅ Week 4: Basic UI components & navigation

### Month 2
- ✅ Week 1: Recipe database & display
- ✅ Week 2: Food logging system
- ✅ Week 3: Home dashboard with nutrition tracking
- ✅ Week 4: Testing & bug fixes

### Month 3
- 🔄 Week 1: Gemini API integration
- 🔄 Week 2: Ingredient scanning feature
- 🔄 Week 3: AI recipe suggestions
- 🔄 Week 4: AI meal plan generation

### Month 4
- ⏳ Week 1: Pantry management
- ⏳ Week 2: Shopping list feature
- ⏳ Week 3: Offline mode implementation
- ⏳ Week 4: Progress analytics & charts

### Month 5
- ⏳ Week 1: Receipt scanning
- ⏳ Week 2: Photo-based food logging
- ⏳ Week 3: Premium subscription setup
- ⏳ Week 4: Polish & optimization

### Month 6+
- ⏳ Performance optimization
- ⏳ User feedback implementation
- ⏳ Marketing materials
- ⏳ App store submission
- ⏳ Beta testing
- ⏳ Public launch

---

## 9. Additional Resources

### Useful Documentation
- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase for Flutter](https://firebase.flutter.dev/)
- [Google Gemini API](https://ai.google.dev/docs)
- [Material Design 3](https://m3.material.io/)

### Romanian Market Considerations
- Use Romanian language throughout
- Include traditional Romanian recipes
- Price subscriptions appropriately for Romanian market
- Consider local payment methods
- Comply with Romanian data protection laws (GDPR)

### Performance Best Practices
- Use `const` constructors where possible
- Implement lazy loading for lists
- Optimize images before upload
- Cache network responses
- Use pagination for large datasets
- Minimize widget rebuilds

---

## 10. Troubleshooting Common Issues

### Firebase Connection Issues
- Verify `google-services.json` and `GoogleService-Info.plist` are correctly placed
- Check package name matches Firebase configuration
- Ensure Firebase services are enabled in console

### Build Errors
- Run `flutter clean && flutter pub get`
- Check for package version conflicts
- Update Flutter SDK: `flutter upgrade`

### Android Build Issues
- Update Android SDK in Android Studio
- Check minSdkVersion is 21+
- Enable multidex if needed

### iOS Build Issues
- Update CocoaPods: `pod repo update`
- Run `pod install` in ios directory
- Check Xcode signing configuration

---

## Conclusion

This implementation plan provides a complete roadmap for developing the Mealee app from start to finish. Each section contains:
- Exact file paths and names
- Complete code implementations
- Step-by-step instructions
- Best practices and optimization tips
- Testing strategies
- Deployment procedures

An engineer with minimal codebase context can follow this plan sequentially to build the entire application. The plan is organized by development phases to enable iterative delivery and testing.

**Next Steps:**
1. Begin with Phase 1 MVP (Months 1-2)
2. Test thoroughly with beta users
3. Gather feedback before proceeding to Phase 2
4. Iterate based on user feedback
5. Scale gradually through Phases 3-4

Good luck with the implementation!
