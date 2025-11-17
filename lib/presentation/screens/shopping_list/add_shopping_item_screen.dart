import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/shopping_list_model.dart';
import '../../providers/shopping_list_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class AddShoppingItemScreen extends StatefulWidget {
  const AddShoppingItemScreen({super.key});

  @override
  State<AddShoppingItemScreen> createState() => _AddShoppingItemScreenState();
}

class _AddShoppingItemScreenState extends State<AddShoppingItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();

  String _selectedCategory = 'Legume';
  String _selectedUnit = 'kg';
  bool _isLoading = false;

  final List<String> _categories = [
    'Legume',
    'Fructe',
    'Lactate',
    'Carne',
    'Pâine & Cereale',
    'Condimente',
    'Băuturi',
    'Altele',
  ];

  final List<String> _units = [
    'kg',
    'g',
    'l',
    'ml',
    'buc',
    'pachete',
    'conserve',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userProvider = context.read<UserProvider>();
      final shoppingListProvider = context.read<ShoppingListProvider>();

      if (userProvider.currentUser == null) {
        throw Exception('Nu există utilizator autentificat');
      }

      final item = ShoppingItem(
        id: const Uuid().v4(),
        ingredient: _nameController.text.trim(),
        quantity: double.parse(_quantityController.text),
        unit: _selectedUnit,
        category: _selectedCategory,
        checked: false,
      );

      await shoppingListProvider.addItemToActiveList(
        userProvider.currentUser!.userId,
        item,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Articolul a fost adăugat cu succes!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Eroare: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adaugă articol'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name
            CustomTextField(
              controller: _nameController,
              label: 'Nume articol',
              hint: 'ex: Roșii',
              prefixIcon: Icons.shopping_basket,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Numele este obligatoriu';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Category
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Categorie',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
            const SizedBox(height: 16),

            // Quantity and Unit
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomTextField(
                    controller: _quantityController,
                    label: 'Cantitate',
                    hint: '1',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Obligatoriu';
                      }
                      final quantity = double.tryParse(value);
                      if (quantity == null || quantity <= 0) {
                        return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedUnit,
                    decoration: const InputDecoration(
                      labelText: 'Unitate',
                      border: OutlineInputBorder(),
                    ),
                    items: _units.map((unit) {
                      return DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedUnit = value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick add suggestions
            Text(
              'Sugestii rapide',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _getQuickAddItems().map((item) {
                return ActionChip(
                  label: Text(item['name']!),
                  avatar: const Icon(Icons.add, size: 18),
                  onPressed: () {
                    _nameController.text = item['name']!;
                    _selectedCategory = item['category']!;
                    _quantityController.text = '1';
                    setState(() {});
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Info card
            Card(
              color: AppColors.info.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: AppColors.info,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Articolele sunt organizate automat pe categorii pentru un shopping mai eficient.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save button
            CustomButton(
              text: 'Adaugă în listă',
              onPressed: _isLoading ? null : _saveItem,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getQuickAddItems() {
    return [
      {'name': 'Pâine', 'category': 'Pâine & Cereale'},
      {'name': 'Lapte', 'category': 'Lactate'},
      {'name': 'Ouă', 'category': 'Lactate'},
      {'name': 'Roșii', 'category': 'Legume'},
      {'name': 'Cartofi', 'category': 'Legume'},
      {'name': 'Ceapă', 'category': 'Legume'},
      {'name': 'Mere', 'category': 'Fructe'},
      {'name': 'Banane', 'category': 'Fructe'},
      {'name': 'Pui', 'category': 'Carne'},
      {'name': 'Apă', 'category': 'Băuturi'},
    ];
  }
}
