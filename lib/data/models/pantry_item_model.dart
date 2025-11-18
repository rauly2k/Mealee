import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PantryItemModel extends Equatable {
  final String pantryItemId;
  final String userId;
  final String ingredientName;
  final double quantity;
  final String unit; // 'g', 'kg', 'ml', 'l', 'buc', etc.
  final DateTime addedDate;
  final String source; // 'manual' or 'receipt'
  final DateTime? expiryDate;
  final String? category; // 'produce', 'dairy', 'meat', 'pantry_staples', etc.

  const PantryItemModel({
    required this.pantryItemId,
    required this.userId,
    required this.ingredientName,
    required this.quantity,
    required this.unit,
    required this.addedDate,
    required this.source,
    this.expiryDate,
    this.category,
  });

  factory PantryItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PantryItemModel(
      pantryItemId: doc.id,
      userId: data['userId'] ?? '',
      ingredientName: data['ingredientName'] ?? '',
      quantity: (data['quantity'] ?? 0).toDouble(),
      unit: data['unit'] ?? 'g',
      addedDate: (data['addedDate'] as Timestamp).toDate(),
      source: data['source'] ?? 'manual',
      expiryDate: data['expiryDate'] != null
          ? (data['expiryDate'] as Timestamp).toDate()
          : null,
      category: data['category'],
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
      'expiryDate':
          expiryDate != null ? Timestamp.fromDate(expiryDate!) : null,
      'category': category,
    };
  }

  PantryItemModel copyWith({
    String? pantryItemId,
    String? userId,
    String? ingredientName,
    double? quantity,
    String? unit,
    DateTime? addedDate,
    String? source,
    DateTime? expiryDate,
    String? category,
  }) {
    return PantryItemModel(
      pantryItemId: pantryItemId ?? this.pantryItemId,
      userId: userId ?? this.userId,
      ingredientName: ingredientName ?? this.ingredientName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      addedDate: addedDate ?? this.addedDate,
      source: source ?? this.source,
      expiryDate: expiryDate ?? this.expiryDate,
      category: category ?? this.category,
    );
  }

  /// Check if item is expired
  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  /// Check if item is expiring soon (within 3 days)
  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final threeDaysFromNow = DateTime.now().add(const Duration(days: 3));
    return expiryDate!.isBefore(threeDaysFromNow) && !isExpired;
  }

  // Backward compatibility getters
  String get itemId => pantryItemId;
  String get name => ingredientName;
  DateTime get addedAt => addedDate;

  @override
  List<Object?> get props => [
        pantryItemId,
        userId,
        ingredientName,
        quantity,
        unit,
        addedDate,
        source,
        expiryDate,
        category,
      ];
}
