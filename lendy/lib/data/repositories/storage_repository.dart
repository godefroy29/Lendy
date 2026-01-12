import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

class StorageRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String _bucketName = 'item-photos';

  // 15.4: Upload Photo Method
  Future<String> uploadPhoto({
    required String userId,
    required String itemId,
    required File imageFile,
  }) async {
    try {
      // Generate unique filename
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';
      
      // Storage path: userId/itemId/filename
      final storagePath = '$userId/$itemId/$fileName';
      
      // Read file as bytes
      final fileBytes = await imageFile.readAsBytes();
      
      // Upload to Supabase Storage
      await _supabase.storage
          .from(_bucketName)
          .uploadBinary(
            storagePath,
            fileBytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: false, // Don't overwrite existing files
            ),
          );
      
      // Get public URL
      final publicUrl = _supabase.storage
          .from(_bucketName)
          .getPublicUrl(storagePath);
      
      return publicUrl;
    } catch (e) {
      rethrow;
    }
  }

  // Handle multiple photo uploads
  Future<PhotoUploadResult> uploadPhotos({
    required String userId,
    required String itemId,
    required List<File> imageFiles,
  }) async {
    final List<String> successfulUrls = [];
    final List<PhotoUploadError> errors = [];
    
    for (int i = 0; i < imageFiles.length; i++) {
      final file = imageFiles[i];
      try {
        final url = await uploadPhoto(
          userId: userId,
          itemId: itemId,
          imageFile: file,
        );
        successfulUrls.add(url);
      } catch (e) {
        errors.add(PhotoUploadError(
          fileName: file.path.split('/').last,
          index: i,
          error: e.toString(),
        ));
      }
    }
    
    return PhotoUploadResult(
      successfulUrls: successfulUrls,
      errors: errors,
    );
  }

  // 15.5: Delete Photo Method
  Future<void> deletePhoto(String photoUrl) async {
    try {
      // Extract path from URL
      // URL format: https://project.supabase.co/storage/v1/object/public/item-photos/userId/itemId/filename
      final uri = Uri.parse(photoUrl);
      final pathSegments = uri.pathSegments;
      
      // Find the index of bucket name
      final bucketIndex = pathSegments.indexOf(_bucketName);
      if (bucketIndex == -1 || bucketIndex >= pathSegments.length - 1) {
        throw Exception('Invalid photo URL format');
      }
      
      // Reconstruct storage path
      final storagePath = pathSegments.sublist(bucketIndex + 1).join('/');
      
      // Delete from storage
      await _supabase.storage
          .from(_bucketName)
          .remove([storagePath]);
    } catch (e) {
      rethrow;
    }
  }

  // Delete multiple photos
  Future<void> deletePhotos(List<String> photoUrls) async {
    for (final url in photoUrls) {
      try {
        await deletePhoto(url);
      } catch (e) {
        // Error deleting photo - continue with other files
        // Error is silently handled to allow other deletions to proceed
      }
    }
  }
}

class PhotoUploadResult {
  final List<String> successfulUrls;
  final List<PhotoUploadError> errors;
  
  PhotoUploadResult({
    required this.successfulUrls,
    required this.errors,
  });
  
  bool get hasErrors => errors.isNotEmpty;
  bool get hasSuccess => successfulUrls.isNotEmpty;
  bool get isPartialSuccess => hasSuccess && hasErrors;
}

class PhotoUploadError {
  final String fileName;
  final int index;
  final String error;
  
  PhotoUploadError({
    required this.fileName,
    required this.index,
    required this.error,
  });
}

