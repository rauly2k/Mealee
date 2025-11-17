import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/shopping_list_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import 'add_shopping_item_screen.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  @override
  void initState() {
    super.initState();
    _loadShoppingLists();
  }

  Future<void> _loadShoppingLists() async {
    final userProvider = context.read<UserProvider>();
    final shoppingListProvider = context.read<ShoppingListProvider>();

    if (userProvider.currentUser != null) {
      await shoppingListProvider.loadShoppingLists(userProvider.currentUser!.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listă cumpărături'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              _showCompletedLists();
            },
          ),
        ],
      ),
      body: Consumer2<UserProvider, ShoppingListProvider>(
        builder: (context, userProvider, shoppingListProvider, _) {
          if (shoppingListProvider.isLoading) {
            return const LoadingIndicator(message: 'Se încarcă lista...');
          }

          if (shoppingListProvider.errorMessage != null) {
            return ErrorDisplay(
              message: shoppingListProvider.errorMessage!,
              onRetry: _loadShoppingLists,
            );
          }

          if (userProvider.currentUser == null) {
            return const Center(
              child: Text('Nu există utilizator autentificat'),
            );
          }

          final activeList = shoppingListProvider.activeList;

          if (activeList == null) {
            return _buildEmptyState(userProvider.currentUser!.userId);
          }

          final itemsByCategory = shoppingListProvider.getItemsByCategory(activeList.listId);
          final completedCount = activeList.items.where((i) => i.isCompleted).length;
          final totalCount = activeList.items.length;

          return RefreshIndicator(
            onRefresh: _loadShoppingLists,
            child: Column(
              children: [
                // Progress card
                Container(
                  margin: const EdgeInsets.all(16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                activeList.name,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              if (totalCount > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: completedCount == totalCount
                                        ? AppColors.success
                                        : AppColors.primary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '$completedCount/$totalCount',
                                    style: const TextStyle(
                                      color: AppColors.textOnPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: totalCount > 0 ? completedCount / totalCount : 0,
                            backgroundColor: AppColors.backgroundLight,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              completedCount == totalCount
                                  ? AppColors.success
                                  : AppColors.primary,
                            ),
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          if (completedCount == totalCount && totalCount > 0) ...[
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '✓ Toate articolele sunt bifate!',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _completeList(
                                    userProvider.currentUser!.userId,
                                    activeList.listId,
                                  ),
                                  child: const Text('Finalizează'),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                // Items list
                Expanded(
                  child: activeList.items.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 64,
                                color: AppColors.textLight,
                              ),
                              const SizedBox(height: 16),
                              const Text('Lista este goală'),
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                onPressed: () => _addItem(userProvider.currentUser!.userId),
                                icon: const Icon(Icons.add),
                                label: const Text('Adaugă articol'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: itemsByCategory.length,
                          itemBuilder: (context, index) {
                            final category = itemsByCategory.keys.elementAt(index);
                            final items = itemsByCategory[category]!;
                            return _buildCategorySection(
                              category,
                              items,
                              userProvider.currentUser!.userId,
                              activeList.listId,
                            );
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
          final userProvider = context.read<UserProvider>();
          if (userProvider.currentUser != null) {
            await _addItem(userProvider.currentUser!.userId);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(String userId) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              'Nicio listă de cumpărături',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Creează prima ta listă de cumpărături',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _addItem(userId),
              icon: const Icon(Icons.add),
              label: const Text('Adaugă articol'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(
    String category,
    List items,
    String userId,
    String listId,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            category,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ...items.map((item) => _buildShoppingItem(item, userId, listId)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildShoppingItem(item, String userId, String listId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(
          value: item.isCompleted,
          onChanged: (value) async {
            await context.read<ShoppingListProvider>().toggleItemCompletion(
                  userId,
                  listId,
                  item.id,
                );
          },
          activeColor: AppColors.success,
        ),
        title: Text(
          item.name,
          style: TextStyle(
            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
            color: item.isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          '${item.quantity} ${item.unit}',
          style: TextStyle(
            color: item.isCompleted ? AppColors.textSecondary : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: AppColors.error),
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Șterge articol'),
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
              await context.read<ShoppingListProvider>().removeItem(
                    userId,
                    listId,
                    item.id,
                  );
            }
          },
        ),
      ),
    );
  }

  Future<void> _addItem(String userId) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const AddShoppingItemScreen(),
      ),
    );
    if (result == true && mounted) {
      _loadShoppingLists();
    }
  }

  Future<void> _completeList(String userId, String listId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalizează lista'),
        content: const Text(
          'Ești sigur că vrei să finalizezi această listă? Va fi mutată în istoric.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Anulează'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Finalizează'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<ShoppingListProvider>().completeList(userId, listId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lista a fost finalizată cu succes!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  void _showCompletedLists() {
    final shoppingListProvider = context.read<ShoppingListProvider>();
    final completedLists = shoppingListProvider.shoppingLists
        .where((list) => list.isCompleted)
        .toList();

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Liste finalizate',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: completedLists.isEmpty
                  ? const Center(
                      child: Text('Nicio listă finalizată'),
                    )
                  : ListView.builder(
                      itemCount: completedLists.length,
                      itemBuilder: (context, index) {
                        final list = completedLists[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                            ),
                            title: Text(list.name),
                            subtitle: Text('${list.items.length} articole'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              // TODO: View completed list details
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
