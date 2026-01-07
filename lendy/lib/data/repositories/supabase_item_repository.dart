import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/item_status.dart';

class SupabaseItemRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 9.2: Create Item Method
  Future<Item> createItem({
    required String userId,
    required Item item,
  }) async {
    try {
      // Convert Item to JSON for Supabase
      final itemJson = item.toJson();
      
      // Remove id, created_at, updated_at as they're auto-generated
      itemJson.remove('id');
      itemJson.remove('created_at');
      itemJson.remove('updated_at');
      
      // Ensure user_id matches the authenticated user
      itemJson['user_id'] = userId;
      
      // Convert status enum to string
      itemJson['status'] = item.status.value;
      
      // Insert into Supabase
      final response = await _supabase
          .from('items')
          .insert(itemJson)
          .select()
          .single();
      
      // Convert response back to Item entity
      return Item.fromJson(response);
    } catch (e) {
      // Re-throw to let caller handle the error
      rethrow;
    }
  }

  // 9.3: Get Items Method (with filtering)
  Future<List<Item>> getItems({
    required String userId,
    ItemStatus? status, // Filter by status, null for all
  }) async {
    try {
      // Start building query
      var query = _supabase
          .from('items')
          .select()
          .eq('user_id', userId); // Filter by user_id
      
      // Add status filter if provided
      if (status != null) {
        query = query.eq('status', status.value);
      }
      
      // Execute query with ordering
      final response = await query
          .order('due_at', ascending: true, nullsFirst: false)
          .order('lent_at', ascending: false);
      
      // Convert list of JSON to list of Items
      return (response as List)
          .map((json) => Item.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // 9.4: Get Single Item Method
  Future<Item?> getItem({
    required String userId,
    required String itemId,
  }) async {
    try {
      final response = await _supabase
          .from('items')
          .select()
          .eq('id', itemId)
          .eq('user_id', userId) // Ensure user owns this item
          .maybeSingle(); // Returns null if not found
      
      if (response == null) {
        return null;
      }
      
      return Item.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // 9.5: Update Item Method
  Future<Item> updateItem({
    required String userId,
    required String itemId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      // Add updated_at timestamp
      updates['updated_at'] = DateTime.now().toIso8601String();
      
      // If status is being updated and it's an ItemStatus enum, convert to string
      if (updates.containsKey('status') && updates['status'] is ItemStatus) {
        updates['status'] = (updates['status'] as ItemStatus).value;
      }
      
      // Update in Supabase
      final response = await _supabase
          .from('items')
          .update(updates)
          .eq('id', itemId)
          .eq('user_id', userId) // Ensure user owns this item
          .select()
          .single();
      
      return Item.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // 9.6: Mark As Returned Method
  Future<Item> markAsReturned({
    required String userId,
    required String itemId,
  }) async {
    try {
      final now = DateTime.now();
      
      final response = await _supabase
          .from('items')
          .update({
            'status': ItemStatus.returned.value,
            'returned_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          })
          .eq('id', itemId)
          .eq('user_id', userId)
          .select()
          .single();
      
      return Item.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // 9.7: Delete Item Method (Optional)
  Future<void> deleteItem({
    required String userId,
    required String itemId,
  }) async {
    try {
      await _supabase
          .from('items')
          .delete()
          .eq('id', itemId)
          .eq('user_id', userId);
    } catch (e) {
      rethrow;
    }
  }

  // 9.8: Search Items Method (Optional but Useful)
  Future<List<Item>> searchItems({
    required String userId,
    required String searchQuery,
    ItemStatus? status,
  }) async {
    try {
      var query = _supabase
          .from('items')
          .select()
          .eq('user_id', userId);
      
      // Search in title or borrower_name
      query = query.or(
        'title.ilike.%$searchQuery%,borrower_name.ilike.%$searchQuery%'
      );
      
      // Add status filter if provided
      if (status != null) {
        query = query.eq('status', status.value);
      }
      
      // Execute query with ordering
      final response = await query
          .order('lent_at', ascending: false);
      
      return (response as List)
          .map((json) => Item.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}

