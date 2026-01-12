import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../providers/items_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/item_card.dart';
import '../widgets/item_card_skeleton.dart';
import '../../domain/entities/item_status.dart';
import '../../utils/error_handler.dart';
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
  String _appVersion = 'Loading...';
  Timer? _debounceTimer;
  final Map<ItemStatus, ScrollController> _scrollControllers = {
    ItemStatus.lent: ScrollController(),
    ItemStatus.returned: ScrollController(),
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);
    _loadAppVersion();
    
    // Add scroll listeners for infinite scroll
    _scrollControllers[ItemStatus.lent]!.addListener(() => _onScroll(ItemStatus.lent));
    _scrollControllers[ItemStatus.returned]!.addListener(() => _onScroll(ItemStatus.returned));
  }
  
  void _onScroll(ItemStatus status) {
    final controller = _scrollControllers[status]!;
    if (controller.position.pixels >= controller.position.maxScrollExtent - 200) {
      // Load more when within 200px of bottom
      final params = PaginatedItemsParams(
        status: status,
        searchQuery: _searchQuery.isEmpty ? null : _searchQuery.trim(),
      );
      ref.read(paginatedItemsNotifierProvider(params)).loadMore();
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _searchQuery = query;
        });
        // Reset pagination when search query changes
        ref.invalidate(paginatedItemsStateProvider);
      }
    });
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _tabController.dispose();
    _scrollControllers[ItemStatus.lent]!.dispose();
    _scrollControllers[ItemStatus.returned]!.dispose();
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
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              tooltip: 'Menu',
              onSelected: (value) {
                if (value == 'theme') {
                  ref.read(themeModeNotifierProvider.notifier).toggleTheme();
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'theme',
                  child: Row(
                    children: [
                      Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                      const SizedBox(width: 12),
                      Text(isDark ? 'Light Mode' : 'Dark Mode'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  enabled: false,
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Version: $_appVersion',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
            final lentParams = PaginatedItemsParams(status: ItemStatus.lent);
            final returnedParams = PaginatedItemsParams(status: ItemStatus.returned);
            ref.read(paginatedItemsNotifierProvider(lentParams)).refresh();
            ref.read(paginatedItemsNotifierProvider(returnedParams)).refresh();
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Item'),
        ),
      ),
    );
  }

  Widget _buildItemsList(ItemStatus status) {
    // Use paginated provider
    final params = PaginatedItemsParams(
      status: status,
      searchQuery: _searchQuery.isEmpty ? null : _searchQuery.trim(),
    );
    final paginatedState = ref.watch(paginatedItemsStateProvider(params));
    final notifier = ref.read(paginatedItemsNotifierProvider(params));
    
    final items = paginatedState.items;
    final isLoading = paginatedState.isLoading;
    final hasMore = paginatedState.hasMore;
    final error = paginatedState.error;
    
    // Show error state
    if (error != null && items.isEmpty) {
      return Center(
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
                ErrorHandler.getUserFriendlyMessage(error),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              if (ErrorHandler.getActionableSuggestion(error) != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          ErrorHandler.getActionableSuggestion(error)!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  notifier.refresh();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    
    // Show empty state
    if (items.isEmpty && !isLoading) {
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
    
    // Show loading state (initial load)
    if (items.isEmpty && isLoading) {
      return ListView.builder(
        controller: _scrollControllers[status],
        itemCount: 5, // Show 5 skeleton cards
        itemBuilder: (context, index) => const ItemCardSkeleton(),
      );
    }
    
    return RefreshIndicator(
      onRefresh: () async {
        await notifier.refresh();
      },
      child: ListView.builder(
        controller: _scrollControllers[status],
        itemCount: items.length + (hasMore ? 1 : 0), // Add 1 for loading indicator
        itemBuilder: (context, index) {
          // Show loading indicator at the bottom when loading more
          if (index == items.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          
          return ItemCard(
            item: items[index],
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetailScreen(
                    itemId: items[index].id,
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
              // Refresh after returning from detail (in case item was updated/deleted)
              await notifier.refresh();
            },
          );
        },
      ),
    );
  }
}

