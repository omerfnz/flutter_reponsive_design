import 'package:flutter/foundation.dart';

/// Base ViewModel class that provides common functionality
/// All ViewModels should extend this class for consistent behavior
abstract class BaseViewModel extends ChangeNotifier {
  /// Indicates if the ViewModel is currently loading
  bool _isLoading = false;

  /// Indicates if the ViewModel has encountered an error
  bool _hasError = false;

  /// Error message if an error has occurred
  String _errorMessage = '';

  /// Getter for loading state
  bool get isLoading => _isLoading;

  /// Getter for error state
  bool get hasError => _hasError;

  /// Getter for error message
  String get errorMessage => _errorMessage;

  /// Sets the loading state and notifies listeners
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Sets an error state with message and notifies listeners
  void setError(String message) {
    _hasError = true;
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  /// Clears the error state and notifies listeners
  void clearError() {
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
  }

  /// Handles exceptions in a consistent manner
  void handleException(Exception exception) {
    setError(exception.toString());
  }
}
