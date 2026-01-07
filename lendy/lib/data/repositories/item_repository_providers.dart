import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'supabase_item_repository.dart';
import 'storage_repository.dart';

final itemRepositoryProvider = Provider<SupabaseItemRepository>((ref) {
  return SupabaseItemRepository();
});

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  return StorageRepository();
});

