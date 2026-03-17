import 'package:flutter/foundation.dart';
import 'app_exceptions.dart';
import 'error_handler.dart';

/// Mixin for providers to handle errors consistently
mixin ProviderErrorMixin on ChangeNotifier {
  AppException? _error;
  
  AppException? get error => _error;
  bool get hasError => _error != null;
  
  void _setError(AppException error) {
    _error = error;
    notifyListeners();
  }
  
  void _clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
  
  /// Execute operation with error handling
  Future<T> executeOperation<T>(
    Future<T> Function() operation, {
    bool retry = false,
    int maxRetries = 3,
  }) async {
    _clearError();
    
    try {
      if (retry) {
        // Import RetryHelper when needed
        // return await RetryHelper.executeWithRetry(operation, maxRetries: maxRetries);
        return await operation(); // Simplified for now
      } else {
        return await operation();
      }
    } catch (error) {
      final appError = ErrorHandler.handleException(error);
      _setError(appError);
      rethrow;
    }
  }
  
  /// Get user-friendly error message
  String getErrorMessage() {
    if (_error == null) return '';
    return ErrorHandler.getUserMessage(_error!);
  }
  
  /// Check if error is retryable
  bool get isRetryable {
    if (_error == null) return false;
    return ErrorHandler.isRetryable(_error!);
  }
}
