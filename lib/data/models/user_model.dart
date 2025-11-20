import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String userId;
  final String email;
  final String displayName;
  final UserProfile? profile;
  final UserGoals? goals;
  final UserPreferences? preferences;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
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
      goals: data['goals'] != null ? UserGoals.fromMap(data['goals']) : null,
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

  UserModel copyWith({
    String? userId,
    String? email,
    String? displayName,
    UserProfile? profile,
    UserGoals? goals,
    UserPreferences? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      profile: profile ?? this.profile,
      goals: goals ?? this.goals,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        email,
        displayName,
        profile,
        goals,
        preferences,
        createdAt,
        updatedAt,
      ];
}

class UserProfile extends Equatable {
  final int age;
  final String gender; // 'male', 'female', 'other'
  final double height; // in cm
  final double weight; // in kg
  final String activityLevel;

  const UserProfile({
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

  UserProfile copyWith({
    int? age,
    String? gender,
    double? height,
    double? weight,
    String? activityLevel,
  }) {
    return UserProfile(
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }

  @override
  List<Object?> get props => [age, gender, height, weight, activityLevel];
}

class UserGoals extends Equatable {
  final String goalType; // 'weight_loss', 'weight_gain', 'maintenance', etc.
  final double calorieTarget;
  final double proteinTarget;
  final double carbsTarget;
  final double fatsTarget;
  final double? targetWeight; // Optional target weight in kg

  const UserGoals({
    required this.goalType,
    required this.calorieTarget,
    required this.proteinTarget,
    required this.carbsTarget,
    required this.fatsTarget,
    this.targetWeight,
  });

  factory UserGoals.fromMap(Map<String, dynamic> map) {
    return UserGoals(
      goalType: map['goalType'] ?? 'general_health',
      calorieTarget: (map['calorieTarget'] ?? 2000).toDouble(),
      proteinTarget: (map['proteinTarget'] ?? 150).toDouble(),
      carbsTarget: (map['carbsTarget'] ?? 200).toDouble(),
      fatsTarget: (map['fatsTarget'] ?? 65).toDouble(),
      targetWeight: map['targetWeight'] != null
          ? (map['targetWeight'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'goalType': goalType,
      'calorieTarget': calorieTarget,
      'proteinTarget': proteinTarget,
      'carbsTarget': carbsTarget,
      'fatsTarget': fatsTarget,
      'targetWeight': targetWeight,
    };
  }

  UserGoals copyWith({
    String? goalType,
    double? calorieTarget,
    double? proteinTarget,
    double? carbsTarget,
    double? fatsTarget,
    double? targetWeight,
  }) {
    return UserGoals(
      goalType: goalType ?? this.goalType,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      proteinTarget: proteinTarget ?? this.proteinTarget,
      carbsTarget: carbsTarget ?? this.carbsTarget,
      fatsTarget: fatsTarget ?? this.fatsTarget,
      targetWeight: targetWeight ?? this.targetWeight,
    );
  }

  @override
  List<Object?> get props => [
        goalType,
        calorieTarget,
        proteinTarget,
        carbsTarget,
        fatsTarget,
        targetWeight,
      ];
}

class UserPreferences extends Equatable {
  final List<String> dietaryRestrictions;
  final List<String> allergies;
  final List<String> dislikedIngredients;
  final String? dietType; // Diet type preference (classic, keto, vegan, etc.)
  final List<String> preferredFoods; // Preferred foods list

  const UserPreferences({
    this.dietaryRestrictions = const [],
    this.allergies = const [],
    this.dislikedIngredients = const [],
    this.dietType,
    this.preferredFoods = const [],
  });

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      dietaryRestrictions:
          List<String>.from(map['dietaryRestrictions'] ?? []),
      allergies: List<String>.from(map['allergies'] ?? []),
      dislikedIngredients:
          List<String>.from(map['dislikedIngredients'] ?? []),
      dietType: map['dietType'],
      preferredFoods: List<String>.from(map['preferredFoods'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dietaryRestrictions': dietaryRestrictions,
      'allergies': allergies,
      'dislikedIngredients': dislikedIngredients,
      'dietType': dietType,
      'preferredFoods': preferredFoods,
    };
  }

  UserPreferences copyWith({
    List<String>? dietaryRestrictions,
    List<String>? allergies,
    List<String>? dislikedIngredients,
    String? dietType,
    List<String>? preferredFoods,
  }) {
    return UserPreferences(
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      allergies: allergies ?? this.allergies,
      dislikedIngredients: dislikedIngredients ?? this.dislikedIngredients,
      dietType: dietType ?? this.dietType,
      preferredFoods: preferredFoods ?? this.preferredFoods,
    );
  }

  @override
  List<Object?> get props => [
        dietaryRestrictions,
        allergies,
        dislikedIngredients,
        dietType,
        preferredFoods,
      ];
}
