import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/pantry_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import 'add_pantry_item_screen.dart';

class PantryScreen extends StatefulWidget {
  const PantryScreen({super.key});

  @override
  State<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends State<PantryScreen> {
  String _selectedFilter = 'all';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadPantryItems();
  }

  Future<void> _loadPantryItems() async {
    final userProvider = context.read<UserProvider>();
    final pantryProvider = context.read<PantryProvider>();

    if (userProvider.currentUser != null) {
      await pantryProvider.loadPantryItems(userProvider.currentUser!.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.pantry),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PantrySearchDelegate(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              // TODO: Navigate to shopping list
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Listă cumpărături disponibilă în curând!'),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer2<UserProvider, PantryProvider>(
        builder: (context, userProvider, pantryProvider, _) {
          if (pantryProvider.isLoading) {
            return const LoadingIndicator(message: 'Se încarcă cămara...');
          }

          if (pantryProvider.errorMessage != null) {
            return ErrorDisplay(
              message: pantryProvider.errorMessage!,
              onRetry: _loadPantryItems,
            );
          }

          if (userProvider.currentUser == null) {
            return const Center(
              child: Text('Nu există utilizator autentificat'),
            );
          }

          final items = _getFilteredItems(pantryProvider);
          final expiringItems = pantryProvider.getExpiringItems(7);
          final expiredItems = pantryProvider.getExpiredItems();

          if (pantryProvider.pantryItems.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: _loadPantryItems,
            child: Column(
              children: [
                // Expiry warnings
                if (expiredItems.isNotEmpty || expiringItems.isNotEmpty) ...[
                  _buildExpiryWarnings(expiredItems, expiringItems),
                ],

                // Filter chips
                _buildFilterChips(),

                // Items list
                Expanded(
                  child: items.isEmpty
                      ? const Center(
                          child: Text('Niciun element găsit'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return _buildPantryItem(item, userProvider.currentUser!.userId);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddPantryItemScreen(),
            ),
          );
          if (result == true && mounted) {
            _loadPantryItems();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.kitchen_outlined,
              size: 80,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.myPantry,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.addSomeIngredients,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AddPantryItemScreen(),
                  ),
                );
                if (result == true && mounted) {
                  _loadPantryItems();
                }
              },
              icon: const Icon(Icons.add),
              label: const Text(AppStrings.addIngredient),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiryWarnings(expiredItems, expiringItems) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (expiredItems.isNotEmpty)
            Card(
              color: AppColors.error.withOpacity(0.1),
              child: ListTile(
                leading: const Icon(Icons.warning, color: AppColors.error),
                title: Text(
                  '${expiredItems.length} ${expiredItems.length == 1 ? "ingredient expirat" : "ingrediente expirate"}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
                trailing: TextButton(
                  onPressed: () {
                    setState(() => _selectedFilter = 'expired');
                  },
                  child: const Text('Vezi'),
                ),
              ),
            ),
          if (expiringItems.isNotEmpty && expiredItems.isNotEmpty)
            const SizedBox(height: 8),
          if (expiringItems.isNotEmpty)
            Card(
              color: AppColors.warning.withOpacity(0.1),
              child: ListTile(
                leading: const Icon(Icons.access_time, color: AppColors.warning),
                title: Text(
                  '${expiringItems.length} ${expiringItems.length == 1 ? "ingredient expiră" : "ingrediente expiră"} în 7 zile',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.warning,
                  ),
                ),
                trailing: TextButton(
                  onPressed: () {
                    setState(() => _selectedFilter = 'expiring');
                  },
                  child: const Text('Vezi'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip('Toate', 'all'),
          _buildFilterChip('Expirate', 'expired'),
          _buildFilterChip('Expiră curând', 'expiring'),
          _buildFilterChip('Fresh', 'fresh'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedFilter = selected ? value : 'all');
        },
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildPantryItem(item, String userId) {
    final isExpired = item.isExpired();
    final isExpiring = item.isExpiringSoon(7);
    final expiryColor = isExpired
        ? AppColors.error
        : isExpiring
            ? AppColors.warning
            : AppColors.success;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: expiryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getCategoryIcon(item.category),
            color: expiryColor,
          ),
        ),
        title: Text(
          item.name,
          style: TextStyle(
            decoration: isExpired ? TextDecoration.lineThrough : null,
            color: isExpired ? AppColors.textSecondary : AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${item.quantity} ${item.unit} • ${item.category}'),
            if (item.expiryDate != null)
              Text(
                isExpired
                    ? 'Expirat la ${DateFormat('d MMM yyyy', 'ro').format(item.expiryDate!)}'
                    : 'Expiră la ${DateFormat('d MMM yyyy', 'ro').format(item.expiryDate!)}',
                style: TextStyle(
                  color: expiryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 20),
                  SizedBox(width: 12),
                  Text('Editează'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                  SizedBox(width: 12),
                  Text('Șterge', style: TextStyle(color: AppColors.error)),
                ],
              ),
            ),
          ],
          onSelected: (value) async {
            if (value == 'delete') {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Șterge ingredient'),
                  content: Text('Ești sigur că vrei să ștergi ${item.name}?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Anulează'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        'Șterge',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              );

              if (confirmed == true && mounted) {
                await context.read<PantryProvider>().deletePantryItem(userId, item.itemId);
              }
            }
          },
        ),
      ),
    );
  }

  List _getFilteredItems(pantryProvider) {
    switch (_selectedFilter) {
      case 'expired':
        return pantryProvider.getExpiredItems();
      case 'expiring':
        return pantryProvider.getExpiringItems(7);
      case 'fresh':
        final all = pantryProvider.pantryItems;
        final expired = pantryProvider.getExpiredItems();
        final expiring = pantryProvider.getExpiringItems(7);
        return all
            .where((item) =>
                !expired.contains(item) && !expiring.contains(item))
            .toList();
      default:
        return pantryProvider.pantryItems;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fructe':
        return Icons.apple;
      case 'legume':
        return Icons.eco;
      case 'lactate':
        return Icons.breakfast_dining;
      case 'carne':
        return Icons.set_meal;
      case 'cereale':
        return Icons.grain;
      case 'condimente':
        return Icons.opacity;
      default:
        return Icons.kitchen;
    }
  }
}

class PantrySearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final pantryProvider = context.watch<PantryProvider>();
    final results = pantryProvider.searchItems(query);

    if (results.isEmpty) {
      return const Center(
        child: Text('Nu s-au găsit rezultate'),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          title: Text(item.name),
          subtitle: Text('${item.quantity} ${item.unit} • ${item.category}'),
          trailing: item.expiryDate != null
              ? Text(
                  DateFormat('d MMM', 'ro').format(item.expiryDate!),
                  style: const TextStyle(fontSize: 12),
                )
              : null,
          onTap: () {
            close(context, item);
          },
        );
      },
    );
  }
}
