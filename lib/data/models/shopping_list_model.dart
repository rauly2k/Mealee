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
  final String ingredient;
  final double quantity;
  final String unit;
  final bool checked;
  final bool inPantry; // Already have this in pantry
  final String? category; // 'produce', 'dairy', 'meat', 'pantry_staples', etc.
  final String? notes;

  const ShoppingItem({
    required this.ingredient,
    required this.quantity,
    required this.unit,
    this.checked = false,
    this.inPantry = false,
    this.category,
    this.notes,
  });

  factory ShoppingItem.fromMap(Map<String, dynamic> map) {
    return ShoppingItem(
      ingredient: map['ingredient'] ?? '',
      quantity: (map['quantity'] ?? 0).toDouble(),
      unit: map['unit'] ?? '',
      checked: map['checked'] ?? false,
      inPantry: map['inPantry'] ?? false,
      category: map['category'],
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
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
    String? ingredient,
    double? quantity,
    String? unit,
    bool? checked,
    bool? inPantry,
    String? category,
    String? notes,
  }) {
    return ShoppingItem(
      ingredient: ingredient ?? this.ingredient,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      checked: checked ?? this.checked,
      inPantry: inPantry ?? this.inPantry,
      category: category ?? this.category,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        ingredient,
        quantity,
        unit,
        checked,
        inPantry,
        category,
        notes,
      ];
}
