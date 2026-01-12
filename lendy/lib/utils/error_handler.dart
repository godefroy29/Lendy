class ErrorHandler {
  /// Converts technical error messages to user-friendly messages
  static String getUserFriendlyMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    // Network/Connection errors
    if (errorString.contains('network') || 
        errorString.contains('connection') ||
        errorString.contains('socket') ||
        errorString.contains('timeout') ||
        errorString.contains('failed host lookup')) {
      return 'Unable to connect to the server. Please check your internet connection and try again.';
    }
    
    // Authentication errors
    if (errorString.contains('unauthorized') ||
        errorString.contains('authentication') ||
        errorString.contains('invalid credentials') ||
        errorString.contains('user not found')) {
      return 'Authentication failed. Please log in again.';
    }
    
    // Permission errors
    if (errorString.contains('permission') ||
        errorString.contains('forbidden') ||
        errorString.contains('access denied')) {
      return 'You don\'t have permission to perform this action.';
    }
    
    // Not found errors
    if (errorString.contains('not found') ||
        errorString.contains('404')) {
      return 'The requested item could not be found.';
    }
    
    // Server errors
    if (errorString.contains('server error') ||
        errorString.contains('500') ||
        errorString.contains('internal server error')) {
      return 'Server error occurred. Please try again later.';
    }
    
    // Storage/Upload errors
    if (errorString.contains('storage') ||
        errorString.contains('upload') ||
        errorString.contains('file size') ||
        errorString.contains('image')) {
      return 'Failed to upload image. Please check the file size and try again.';
    }
    
    // Validation errors
    if (errorString.contains('validation') ||
        errorString.contains('invalid') ||
        errorString.contains('required')) {
      return 'Please check your input and try again.';
    }
    
    // Email already registered
    if (errorString.contains('already registered') ||
        errorString.contains('email already exists') ||
        errorString.contains('user already registered')) {
      return 'This email is already registered. Please use a different email or try logging in.';
    }
    
    // Password errors
    if (errorString.contains('password') && 
        (errorString.contains('weak') || 
         errorString.contains('short') ||
         errorString.contains('requirements'))) {
      return 'Password does not meet requirements. Please use at least 12 characters with uppercase, lowercase, numbers, and symbols.';
    }
    
    // Invalid email
    if (errorString.contains('invalid email') ||
        errorString.contains('email format')) {
      return 'Please enter a valid email address.';
    }
    
    // Default fallback
    return 'Something went wrong. Please try again.';
  }
  
  /// Gets actionable suggestion based on error type
  static String? getActionableSuggestion(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('network') || 
        errorString.contains('connection') ||
        errorString.contains('timeout')) {
      return 'Check your Wi-Fi or mobile data connection';
    }
    
    if (errorString.contains('storage') || errorString.contains('upload')) {
      return 'Try using a smaller image or check your internet connection';
    }
    
    if (errorString.contains('authentication') || errorString.contains('unauthorized')) {
      return 'Try logging out and logging back in';
    }
    
    return null;
  }
  
  /// Checks if error is recoverable (user can retry)
  static bool isRecoverable(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    // Network errors are usually recoverable
    if (errorString.contains('network') || 
        errorString.contains('connection') ||
        errorString.contains('timeout')) {
      return true;
    }
    
    // Server errors might be recoverable
    if (errorString.contains('server error') || errorString.contains('500')) {
      return true;
    }
    
    // Storage/upload errors might be recoverable
    if (errorString.contains('storage') || errorString.contains('upload')) {
      return true;
    }
    
    // Authentication errors usually require re-login
    if (errorString.contains('authentication') || errorString.contains('unauthorized')) {
      return false;
    }
    
    // Validation errors are not recoverable by retry
    if (errorString.contains('validation') || errorString.contains('invalid')) {
      return false;
    }
    
    // Default to recoverable
    return true;
  }
}
