import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/repositories/item_repository_providers.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/item_status.dart';
import '../../services/auth_providers.dart';

// Pagination constants
const int _itemsPerPage = 20;

// Paginated items state
class PaginatedItemsState {
  final List<Item> items;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final Object? error;

  PaginatedItemsState({
    this.items = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.currentPage = 0,
    this.error,
  });

  PaginatedItemsState copyWith({
    List<Item>? items,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    Object? error,
  }) {
    return PaginatedItemsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error,
    );
  }
}

// Provider family for paginated items state
final paginatedItemsStateProvider = StateProvider.family<PaginatedItemsState, PaginatedItemsParams>(
  (ref, params) => PaginatedItemsState(),
);

// Provider family for paginated items notifier (helper methods)
final paginatedItemsNotifierProvider = Provider.family<PaginatedItemsNotifier, PaginatedItemsParams>(
  (ref, params) {
    return PaginatedItemsNotifier(ref: ref, params: params);
  },
);

// Paginated items notifier - helper class for operations
class PaginatedItemsNotifier {
  final Ref ref;
  final PaginatedItemsParams params;

  PaginatedItemsNotifier({required this.ref, required this.params}) {
    // Load initial data
    Future.microtask(() => loadMore());
  }

  PaginatedItemsState get state => ref.read(paginatedItemsStateProvider(params));

  Future<void> loadMore() async {
    final currentState = ref.read(paginatedItemsStateProvider(params));
    if (currentState.isLoading || !currentState.hasMore) return;

    ref.read(paginatedItemsStateProvider(params).notifier).state = 
        currentState.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(itemRepositoryProvider);
      final authState = ref.read(authStateProvider);
      final user = authState.value;

      if (user == null) {
        ref.read(paginatedItemsStateProvider(params).notifier).state = 
            currentState.copyWith(isLoading: false);
        return;
      }

      final offset = currentState.currentPage * _itemsPerPage;
      List<Item> newItems;

      if (params.searchQuery != null && params.searchQuery!.isNotEmpty) {
        newItems = await repository.searchItems(
          userId: user.id,
          searchQuery: params.searchQuery!,
          status: params.status,
          limit: _itemsPerPage,
          offset: offset,
        );
      } else {
        newItems = await repository.getItems(
          userId: user.id,
          status: params.status,
          limit: _itemsPerPage,
          offset: offset,
        );
      }

      final hasMore = newItems.length == _itemsPerPage;
      final updatedState = ref.read(paginatedItemsStateProvider(params));
      ref.read(paginatedItemsStateProvider(params).notifier).state = 
          updatedState.copyWith(
            items: [...updatedState.items, ...newItems],
            isLoading: false,
            hasMore: hasMore,
            currentPage: updatedState.currentPage + 1,
          );
    } catch (e) {
      ref.read(paginatedItemsStateProvider(params).notifier).state = 
          currentState.copyWith(
            isLoading: false,
            error: e,
          );
    }
  }

  Future<void> refresh() async {
    ref.read(paginatedItemsStateProvider(params).notifier).state = PaginatedItemsState();
    await loadMore();
  }
}

class PaginatedItemsParams {
  final ItemStatus? status;
  final String? searchQuery;

  PaginatedItemsParams({this.status, this.searchQuery});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaginatedItemsParams &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          searchQuery == other.searchQuery;

  @override
  int get hashCode => status.hashCode ^ searchQuery.hashCode;
}

// Legacy providers for backward compatibility (non-paginated)
final lentItemsProvider = FutureProvider<List<Item>>((ref) async {
  final repository = ref.watch(itemRepositoryProvider);
  final authState = ref.watch(authStateProvider);
  
  final user = authState.value;
  if (user == null) {
    return [];
  }
  
  return repository.getItems(userId: user.id, status: ItemStatus.lent);
});

final returnedItemsProvider = FutureProvider<List<Item>>((ref) async {
  final repository = ref.watch(itemRepositoryProvider);
  final authState = ref.watch(authStateProvider);
  
  final user = authState.value;
  if (user == null) {
    return [];
  }
  
  return repository.getItems(userId: user.id, status: ItemStatus.returned);
});

final itemDetailProvider = FutureProvider.family<Item?, String>((ref, itemId) async {
  final repository = ref.watch(itemRepositoryProvider);
  final authState = ref.watch(authStateProvider);
  
  final user = authState.value;
  if (user == null) {
    return null;
  }
  
  return repository.getItem(userId: user.id, itemId: itemId);
});

final searchItemsProvider = FutureProvider.family<List<Item>, SearchParams>((ref, params) async {
  final repository = ref.watch(itemRepositoryProvider);
  final authState = ref.watch(authStateProvider);
  
  final user = authState.value;
  if (user == null) {
    return [];
  }
  
  if (params.query.isEmpty) {
    // If no search query, return all items for the status
    return repository.getItems(userId: user.id, status: params.status);
  }
  
  return repository.searchItems(
    userId: user.id,
    searchQuery: params.query,
    status: params.status,
  );
});

class SearchParams {
  final String query;
  final ItemStatus? status;
  
  SearchParams({required this.query, this.status});
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchParams &&
          runtimeType == other.runtimeType &&
          query == other.query &&
          status == other.status;
  
  @override
  int get hashCode => query.hashCode ^ status.hashCode;
}

