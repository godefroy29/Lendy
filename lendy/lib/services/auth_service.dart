import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  // 7.2: Sign Up Method
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      // Re-throw to let caller handle the error
      rethrow;
    }
  }

  // 7.3: Sign In Method
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      // Re-throw to let caller handle the error
      rethrow;
    }
  }

  // 7.4: Sign Out Method
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      // Re-throw to let caller handle the error
      rethrow;
    }
  }

  // 7.5: Get Current User Method
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  // 7.6: Auth State Stream
  Stream<AuthState> get authStateChanges {
    return _supabase.auth.onAuthStateChange;
  }
}

