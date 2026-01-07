import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/items_provider.dart';
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
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: _searchQuery.isEmpty 
              ? const Text('Lent Items')
              : Text('Search: $_searchQuery'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Lent'),
              Tab(text: 'Returned'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Search Items'),
                    content: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Search by title or borrower name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Clear'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
            if (_searchQuery.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _searchController.clear();
                  });
                },
              ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildItemsList(ItemStatus.lent),
            _buildItemsList(ItemStatus.returned),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateItemScreen(),
              ),
            );
            // Refresh list after returning from create screen
            ref.invalidate(lentItemsProvider);
            ref.invalidate(returnedItemsProvider);
          },
          child: const Icon(Icons.add),
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
                    item.borrowerName.toLowerCase().contains(query);
              }).toList();
        
        if (filteredItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  _searchQuery.isEmpty
                      ? 'No items ${status == ItemStatus.lent ? "lent" : "returned"} yet'
                      : 'No items found',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                if (_searchQuery.isEmpty && status == ItemStatus.lent) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Tap the + button to add an item',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ],
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetailScreen(
                        itemId: filteredItems[index].id,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (status == ItemStatus.lent) {
                  ref.invalidate(lentItemsProvider);
                } else {
                  ref.invalidate(returnedItemsProvider);
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

