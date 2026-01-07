import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/item_repository_providers.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/item_status.dart';
import '../../services/auth_providers.dart';

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

