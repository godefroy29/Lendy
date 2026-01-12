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
      
      // Insert into Supabase - select only needed fields
      final response = await _supabase
          .from('items')
          .insert(itemJson)
          .select('id,user_id,title,description,borrower_name,borrower_contact,lent_at,due_at,reminder_at,status,returned_at,photo_urls,created_at,updated_at')
          .single();
      
      // Convert response back to Item entity
      return Item.fromJson(response);
    } catch (e) {
      // Re-throw to let caller handle the error
      rethrow;
    }
  }

  // 9.3: Get Items Method (with filtering and pagination)
  // Optimized: Select only needed fields, uses indexes on user_id and status
  // Database indexes should be created on: user_id, status, due_at (for ordering)
  Future<List<Item>> getItems({
    required String userId,
    ItemStatus? status, // Filter by status, null for all
    int? limit,
    int? offset,
  }) async {
    try {
      // Start building query - select only needed fields for better performance
      dynamic query = _supabase
          .from('items')
          .select('id,user_id,title,description,borrower_name,borrower_contact,lent_at,due_at,reminder_at,status,returned_at,photo_urls,created_at,updated_at')
          .eq('user_id', userId); // Filter by user_id (indexed)
      
      // Add status filter if provided (indexed)
      if (status != null) {
        query = query.eq('status', status.value);
      }
      
      // Execute query with ordering (due_at should be indexed for performance)
      query = query
          .order('due_at', ascending: true, nullsFirst: false)
          .order('lent_at', ascending: false);
      
      // Add pagination if provided
      // Supabase range is inclusive, so range(0, 19) returns 20 items
      if (limit != null && offset != null) {
        query = query.range(offset, offset + limit - 1);
      } else if (limit != null) {
        query = query.limit(limit);
      }
      
      final response = await query;
      
      // Convert list of JSON to list of Items
      return (response as List)
          .map((json) => Item.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // 9.4: Get Single Item Method
  // Optimized: Select only needed fields, uses indexes on id and user_id
  Future<Item?> getItem({
    required String userId,
    required String itemId,
  }) async {
    try {
      final response = await _supabase
          .from('items')
          .select('id,user_id,title,description,borrower_name,borrower_contact,lent_at,due_at,reminder_at,status,returned_at,photo_urls,created_at,updated_at')
          .eq('id', itemId) // Primary key (indexed)
          .eq('user_id', userId) // Ensure user owns this item (indexed)
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
  // Optimized: Select only needed fields after update
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
      
      // Update in Supabase - select only needed fields
      final response = await _supabase
          .from('items')
          .update(updates)
          .eq('id', itemId) // Primary key (indexed)
          .eq('user_id', userId) // Ensure user owns this item (indexed)
          .select('id,user_id,title,description,borrower_name,borrower_contact,lent_at,due_at,reminder_at,status,returned_at,photo_urls,created_at,updated_at')
          .single();
      
      return Item.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // 9.6: Mark As Returned Method
  // Optimized: Select only needed fields after update
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
          .eq('id', itemId) // Primary key (indexed)
          .eq('user_id', userId) // Indexed
          .select('id,user_id,title,description,borrower_name,borrower_contact,lent_at,due_at,reminder_at,status,returned_at,photo_urls,created_at,updated_at')
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

  // 9.8: Search Items Method (Optimized with pagination)
  // Optimized: Select only needed fields, uses indexes on user_id and status
  // Note: For better search performance, consider adding full-text search indexes
  // on title and borrower_name columns in Supabase dashboard
  Future<List<Item>> searchItems({
    required String userId,
    required String searchQuery,
    ItemStatus? status,
    int? limit,
    int? offset,
  }) async {
    try {
      // Escape search query to prevent SQL injection
      final escapedQuery = searchQuery.replaceAll('%', '\\%').replaceAll('_', '\\_');
      
      dynamic query = _supabase
          .from('items')
          .select('id,user_id,title,description,borrower_name,borrower_contact,lent_at,due_at,reminder_at,status,returned_at,photo_urls,created_at,updated_at')
          .eq('user_id', userId); // Indexed
      
      // Search in title or borrower_name (case-insensitive)
      // Using ilike for case-insensitive search
      query = query.or(
        'title.ilike.%$escapedQuery%,borrower_name.ilike.%$escapedQuery%'
      );
      
      // Add status filter if provided (indexed)
      if (status != null) {
        query = query.eq('status', status.value);
      }
      
      // Execute query with ordering
      query = query.order('lent_at', ascending: false);
      
      // Add pagination if provided
      // Supabase range is inclusive, so range(0, 19) returns 20 items
      if (limit != null && offset != null) {
        query = query.range(offset, offset + limit - 1);
      } else if (limit != null) {
        query = query.limit(limit);
      }
      
      final response = await query;
      
      return (response as List)
          .map((json) => Item.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}

