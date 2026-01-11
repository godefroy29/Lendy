import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/items_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/item_card.dart';
import '../../domain/entities/item_status.dart';
import 'create_item_screen.dart';
import 'item_detail_screen.dart';

class ItemsListScreen extends ConsumerStatefulWidget {
  const ItemsListScreen({super.key});

  @override
  ConsumerState<ItemsListScreen> createState() => _ItemsListScreenState();
}

class _ItemsListScreenState extends ConsumerState<ItemsListScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: _searchQuery.isEmpty 
              ? const Text('Lendy')
              : Text('Search: $_searchQuery'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(112),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by Borrower, Title, or Description',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const TabBar(
                  tabs: [
                    Tab(text: 'Lent'),
                    Tab(text: 'Returned'),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                ref.read(themeModeNotifierProvider.notifier).toggleTheme();
              },
              tooltip: 'Toggle theme',
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildItemsList(ItemStatus.lent),
            _buildItemsList(ItemStatus.returned),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateItemScreen(
                  initialBorrowerName: _searchQuery.isNotEmpty ? _searchQuery : null,
                ),
              ),
            );
            // Refresh list after returning from create screen
            ref.invalidate(lentItemsProvider);
            ref.invalidate(returnedItemsProvider);
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Item'),
        ),
      ),
    );
  }

  Widget _buildItemsList(ItemStatus status) {
    final itemsAsync = status == ItemStatus.lent 
        ? ref.watch(lentItemsProvider)
        : ref.watch(returnedItemsProvider);
    
    return itemsAsync.when(
      data: (allItems) {
        // Filter items client-side
        final filteredItems = _searchQuery.isEmpty
            ? allItems
            : allItems.where((item) {
                final query = _searchQuery.toLowerCase();
                return item.title.toLowerCase().contains(query) ||
                    item.borrowerName.toLowerCase().contains(query) ||
                    (item.description != null && 
                     item.description!.toLowerCase().contains(query));
              }).toList();
        
        if (filteredItems.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _searchQuery.isEmpty
                          ? (status == ItemStatus.lent 
                              ? Icons.inventory_2_outlined 
                              : Icons.check_circle_outline)
                          : Icons.search_off,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _searchQuery.isEmpty
                        ? 'No items ${status == ItemStatus.lent ? "lent" : "returned"} yet'
                        : 'No items found',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_searchQuery.isEmpty && status == ItemStatus.lent) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Tap the + button to add an item',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          );
        }
        
        return RefreshIndicator(
          onRefresh: () async {
            if (status == ItemStatus.lent) {
              ref.invalidate(lentItemsProvider);
            } else {
              ref.invalidate(returnedItemsProvider);
            }
          },
          child: ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              return ItemCard(
                item: filteredItems[index],
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetailScreen(
                        itemId: filteredItems[index].id,
                      ),
                    ),
                  );
                  // If detail screen returned a borrower name, set search
                  if (result != null && result is String) {
                    setState(() {
                      _searchQuery = result;
                      _searchController.text = result;
                    });
                  }
                },
              );
            },
          ),
        );
      },
      loading: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading items...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer.withValues(alpha:0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  if (status == ItemStatus.lent) {
                    ref.invalidate(lentItemsProvider);
                  } else {
                    ref.invalidate(returnedItemsProvider);
                  }
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

