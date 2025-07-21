import 'package:flutter/material.dart';

/// Centralized error handling utility class for the responsive template
///
/// This class provides methods for handling different types of errors that can
/// occur in the application, including responsive layout errors, navigation
/// errors, and content loading errors. It follows SOLID principles and provides
/// consistent error handling across the application.
///
/// Follows requirements: 6.5, 5.2
class ErrorHandler {
  /// Private constructor to prevent instantiation
  ErrorHandler._();

  /// Handles responsive layout errors with fallback behavior
  ///
  /// [error] The error message or exception
  /// [screenWidth] The screen width that caused the error (optional)
  static void handleResponsiveError(String error, [double? screenWidth]) {
    final errorMessage =
        screenWidth != null
            ? 'Responsive Error (width: $screenWidth): $error'
            : 'Responsive Error: $error';

    debugPrint(errorMessage);

    // Log to crash reporting service in production
    _logToCrashReporting('ResponsiveError', errorMessage, {
      'screenWidth': screenWidth?.toString() ?? 'unknown',
      'errorType': 'responsive',
    });
  }

  /// Handles navigation errors with fallback to home route
  ///
  /// [route] The route that caused the error
  /// [error] The error message or exception
  /// [navigateToHome] Callback to navigate to home route (optional)
  static void handleNavigationError(
    String route,
    String error, [
    VoidCallback? navigateToHome,
  ]) {
    final errorMessage = 'Navigation Error for route "$route": $error';
    debugPrint(errorMessage);

    // Log to crash reporting service in production
    _logToCrashReporting('NavigationError', errorMessage, {
      'route': route,
      'errorType': 'navigation',
    });

    // Attempt to navigate to home if callback is provided
    if (navigateToHome != null) {
      try {
        navigateToHome();
        debugPrint('Successfully navigated to home after navigation error');
      } catch (fallbackError) {
        debugPrint('Failed to navigate to home: $fallbackError');
        _logToCrashReporting(
          'NavigationFallbackError',
          fallbackError.toString(),
          {
            'originalRoute': route,
            'originalError': error,
            'errorType': 'navigation_fallback',
          },
        );
      }
    }
  }

  /// Handles content loading errors with fallback content
  ///
  /// [route] The route for which content loading failed
  /// [error] The error message or exception
  static void handleContentError(String route, String error) {
    final errorMessage = 'Content Error for route "$route": $error';
    debugPrint(errorMessage);

    // Log to crash reporting service in production
    _logToCrashReporting('ContentError', errorMessage, {
      'route': route,
      'errorType': 'content',
    });
  }

  /// Handles service initialization errors
  ///
  /// [serviceName] The name of the service that failed to initialize
  /// [error] The error message or exception
  static void handleServiceError(String serviceName, String error) {
    final errorMessage = 'Service Error in $serviceName: $error';
    debugPrint(errorMessage);

    // Log to crash reporting service in production
    _logToCrashReporting('ServiceError', errorMessage, {
      'serviceName': serviceName,
      'errorType': 'service',
    });
  }

  /// Handles ViewModel errors with state recovery
  ///
  /// [viewModelName] The name of the ViewModel that encountered an error
  /// [error] The error message or exception
  /// [resetState] Callback to reset the ViewModel state (optional)
  static void handleViewModelError(
    String viewModelName,
    String error, [
    VoidCallback? resetState,
  ]) {
    final errorMessage = 'ViewModel Error in $viewModelName: $error';
    debugPrint(errorMessage);

    // Log to crash reporting service in production
    _logToCrashReporting('ViewModelError', errorMessage, {
      'viewModelName': viewModelName,
      'errorType': 'viewmodel',
    });

    // Attempt to reset state if callback is provided
    if (resetState != null) {
      try {
        resetState();
        debugPrint('Successfully reset state for $viewModelName');
      } catch (resetError) {
        debugPrint('Failed to reset state for $viewModelName: $resetError');
        _logToCrashReporting('ViewModelResetError', resetError.toString(), {
          'viewModelName': viewModelName,
          'originalError': error,
          'errorType': 'viewmodel_reset',
        });
      }
    }
  }

  /// Handles general application errors
  ///
  /// [error] The error message or exception
  /// [context] Additional context information (optional)
  static void handleGeneralError(
    String error, [
    Map<String, dynamic>? context,
  ]) {
    final errorMessage = 'General Error: $error';
    debugPrint(errorMessage);

    // Log to crash reporting service in production
    _logToCrashReporting('GeneralError', errorMessage, {
      'errorType': 'general',
      ...?context,
    });
  }

  /// Builds a user-friendly error widget for display
  ///
  /// [message] The error message to display
  /// [onRetry] Optional callback for retry functionality
  /// [icon] Optional icon to display (defaults to error icon)
  /// [showDetails] Whether to show detailed error information
  static Widget buildErrorWidget(
    String message, {
    VoidCallback? onRetry,
    IconData? icon,
    bool showDetails = false,
    String? details,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon ?? Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            if (showDetails && details != null) ...[
              const SizedBox(height: 8),
              Text(
                details,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds a loading error widget specifically for content loading failures
  ///
  /// [route] The route that failed to load
  /// [onRetry] Optional callback for retry functionality
  /// [onGoHome] Optional callback to navigate to home
  static Widget buildContentErrorWidget(
    String route, {
    VoidCallback? onRetry,
    VoidCallback? onGoHome,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_outlined,
              size: 64,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            const Text(
              'Content Not Available',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Unable to load content for "$route"',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (onRetry != null) ...[
                  ElevatedButton(
                    onPressed: onRetry,
                    child: const Text('Retry'),
                  ),
                  const SizedBox(width: 8),
                ],
                if (onGoHome != null)
                  OutlinedButton(
                    onPressed: onGoHome,
                    child: const Text('Go Home'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a network error widget for connectivity issues
  ///
  /// [onRetry] Optional callback for retry functionality
  static Widget buildNetworkErrorWidget({VoidCallback? onRetry}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Please check your internet connection and try again.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds a responsive layout fallback widget
  ///
  /// [screenWidth] The screen width that caused the issue
  static Widget buildResponsiveFallbackWidget(double screenWidth) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.devices, size: 64, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'Layout Adjustment',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Optimizing layout for screen width: ${screenWidth.toStringAsFixed(0)}px',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Logs errors to crash reporting service (placeholder for production implementation)
  ///
  /// [errorType] The type of error
  /// [message] The error message
  /// [context] Additional context information
  static void _logToCrashReporting(
    String errorType,
    String message,
    Map<String, dynamic> context,
  ) {
    // In a production app, this would integrate with services like:
    // - Firebase Crashlytics
    // - Sentry
    // - Bugsnag
    // - Custom logging service

    // For now, we'll just log to debug console with structured format
    debugPrint('=== ERROR REPORT ===');
    debugPrint('Type: $errorType');
    debugPrint('Message: $message');
    debugPrint('Context: $context');
    debugPrint('Timestamp: ${DateTime.now().toIso8601String()}');
    debugPrint('==================');
  }

  /// Gets error statistics for monitoring and debugging
  ///
  /// This would typically integrate with analytics services in production
  static Map<String, dynamic> getErrorStatistics() {
    // In production, this would return actual error statistics
    // from your logging/monitoring service
    return {
      'totalErrors': 0,
      'errorTypes': <String, int>{},
      'lastError': null,
      'errorRate': 0.0,
    };
  }

  /// Checks if error reporting is enabled
  ///
  /// This allows for conditional error reporting based on app configuration
  static bool get isErrorReportingEnabled {
    // In production, this would check app configuration or user preferences
    return true;
  }

  /// Sets up global error handling for the application
  ///
  /// This should be called in main.dart to catch unhandled errors
  static void setupGlobalErrorHandling() {
    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      handleGeneralError(details.exception.toString(), {
        'stack': details.stack.toString(),
        'library': details.library,
        'context': details.context?.toString(),
      });
    };

    // Handle errors outside of Flutter framework
    // This would be implemented differently based on the platform
    // For now, we'll just set up the structure
  }
}
