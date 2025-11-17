import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ShoppingListModel extends Equatable {
  final String listId;
  final String userId;
  final String name;
  final List<ShoppingItem> items;
  final String createdFrom; // 'mealPlan', 'recipe', 'manual'
  final String? sourceId; // mealPlanId or recipeId if applicable
  final DateTime createdAt;
  final DateTime updatedAt;

  const ShoppingListModel({
    required this.listId,
    required this.userId,
    required this.name,
    required this.items,
    required this.createdFrom,
    this.sourceId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShoppingListModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ShoppingListModel(
      listId: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      items: (data['items'] as List<dynamic>?)
              ?.map((i) => ShoppingItem.fromMap(i as Map<String, dynamic>))
              .toList() ??
          [],
      createdFrom: data['createdFrom'] ?? 'manual',
      sourceId: data['sourceId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'items': items.map((i) => i.toMap()).toList(),
      'createdFrom': createdFrom,
      'sourceId': sourceId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  ShoppingListModel copyWith({
    String? listId,
    String? userId,
    String? name,
    List<ShoppingItem>? items,
    String? createdFrom,
    String? sourceId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShoppingListModel(
      listId: listId ?? this.listId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      items: items ?? this.items,
      createdFrom: createdFrom ?? this.createdFrom,
      sourceId: sourceId ?? this.sourceId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get total number of items
  int get totalItems => items.length;

  /// Get number of checked items
  int get checkedItems => items.where((item) => item.checked).length;

  /// Get completion percentage
  double get completionPercentage {
    if (totalItems == 0) return 0;
    return (checkedItems / totalItems) * 100;
  }

  /// Check if all items are checked
  bool get isComplete => totalItems > 0 && checkedItems == totalItems;

  /// Backward compatibility: isCompleted is an alias for isComplete
  bool get isCompleted => isComplete;

  @override
  List<Object?> get props => [
        listId,
        userId,
        name,
        items,
        createdFrom,
        sourceId,
        createdAt,
        updatedAt,
      ];
}

class ShoppingItem extends Equatable {
  final String id;
  final String ingredient;
  final double quantity;
  final String unit;
  final bool checked;
  final bool inPantry; // Already have this in pantry
  final String? category; // 'produce', 'dairy', 'meat', 'pantry_staples', etc.
  final String? notes;

  const ShoppingItem({
    required this.id,
    required this.ingredient,
    required this.quantity,
    required this.unit,
    this.checked = false,
    this.inPantry = false,
    this.category,
    this.notes,
  });

  // Backward compatibility: isCompleted is an alias for checked
  bool get isCompleted => checked;

  // Backward compatibility: name is an alias for ingredient
  String get name => ingredient;

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      id: map['id'] ?? '',
      ingredient: map['ingredient'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      unit: map['unit'] ?? '',
      checked: map['checked'] ?? map['isCompleted'] ?? false, // Support both field names
      inPantry: map['inPantry'] ?? false,
      category: map['category'],
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ingredient': ingredient,
      'quantity': quantity,
      'unit': unit,
      'checked': checked,
      'inPantry': inPantry,
      'category': category,
      'notes': notes,
    };
  }

  ShoppingItem copyWith({
    String? id,
    String? ingredient,
    double? quantity,
    String? unit,
    bool? checked,
    bool? isCompleted, // Backward compatibility
    bool? inPantry,
    String? category,
    String? notes,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      ingredient: ingredient ?? this.ingredient,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      checked: checked ?? isCompleted ?? this.checked, // Support both parameters
      inPantry: inPantry ?? this.inPantry,
      category: category ?? this.category,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        ingredient,
        quantity,
        unit,
        checked,
        inPantry,
        category,
        notes,
      ];
}
