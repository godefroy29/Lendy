import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_service.dart';
import 'local_notification_service.dart';

// 7.7: AuthService Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// 7.7: Current User Provider (Stream-based)
final currentUserProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges.map((authState) => authState.session?.user);
});

// 7.8: Auth State Provider (For UI State Management)
// Using StreamProvider which automatically provides AsyncValue<User?>
// This provides loading, data, and error states automatically
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  
  // Stream that emits user whenever auth state changes
  // StreamProvider automatically wraps this in AsyncValue<User?>
  return authService.authStateChanges.map((authState) => authState.session?.user);
});

// 17.5: Local Notification Service Provider
final localNotificationServiceProvider = Provider<LocalNotificationService>((ref) {
  return LocalNotificationService();
});

