import 'package:flutter/widgets.dart';
import '../interfaces/i_content_service.dart';

/// ViewModel for managing content state and route-based content retrieval
///
/// This class extends ChangeNotifier to provide reactive state management
/// for content-related functionality. It tracks the current route and
/// provides content widgets based on the selected route.
///
/// Requirements: 2.4, 5.1, 5.2, 6.5
class ContentViewModel extends ChangeNotifier {
  final IContentService _contentService;
  String _currentRoute = '/home';

  /// Creates a ContentViewModel with the required content service
  ///
  /// [contentService] The service responsible for content retrieval
  ContentViewModel(this._contentService);

  /// Gets the current route
  String get currentRoute => _currentRoute;

  /// Gets the content widget for the current route
  ///
  /// Uses the content service to retrieve the appropriate widget
  /// for the current route. Includes error handling for invalid routes.
  Widget get currentContent =>
      _contentService.getContentForRoute(_currentRoute);

  /// Updates the current route and notifies listeners
  ///
  /// This method changes the current route and triggers content updates.
  /// It notifies listeners so the UI can react to route changes.
  ///
  /// [route] The new route to navigate to
  void updateRoute(String route) {
    if (_currentRoute != route) {
      _currentRoute = route;
      notifyListeners();
    }
  }

  /// Gets content for a specific route without changing the current route
  ///
  /// This method allows previewing content for a route without actually
  /// navigating to it. Useful for preloading or validation purposes.
  ///
  /// [route] The route to get content for
  /// Returns the widget content for the specified route
  Widget getContentForRoute(String route) {
    return _contentService.getContentForRoute(route);
  }

  /// Checks if the given route is the current route
  ///
  /// [route] The route to check
  /// Returns true if the route matches the current route, false otherwise
  bool isCurrentRoute(String route) {
    return _currentRoute == route;
  }

  /// Navigates to the home route
  ///
  /// This is a convenience method to quickly navigate to the default home route
  void navigateToHome() {
    updateRoute('/home');
  }

  /// Gets a list of valid routes that have content
  ///
  /// This method can be used to validate routes or provide navigation options.
  /// The implementation depends on the content service capabilities.
  List<String> get availableRoutes {
    // Common routes that should be available in most applications
    return ['/home', '/profile', '/settings', '/about'];
  }

  /// Validates if a route is valid
  ///
  /// [route] The route to validate
  /// Returns true if the route is valid, false otherwise
  bool isValidRoute(String route) {
    if (route.isEmpty || !route.startsWith('/')) {
      return false;
    }

    // Additional validation can be added here
    return availableRoutes.contains(route);
  }

  /// Updates route with validation
  ///
  /// This method updates the route only if it's valid, otherwise
  /// it falls back to the home route and returns false.
  ///
  /// [route] The route to navigate to
  /// Returns true if the route was valid and updated, false if fallback was used
  bool updateRouteWithValidation(String route) {
    if (isValidRoute(route)) {
      updateRoute(route);
      return true;
    } else {
      // Fallback to home route for invalid routes
      updateRoute('/home');
      return false;
    }
  }

  /// Gets the previous route if available
  ///
  /// This is a simple implementation that could be extended
  /// to maintain a route history stack
  String? _previousRoute;

  /// Navigates back to the previous route if available
  ///
  /// Returns true if navigation was successful, false if no previous route exists
  bool navigateBack() {
    if (_previousRoute != null && _previousRoute != _currentRoute) {
      final routeToNavigateTo = _previousRoute!;
      _previousRoute = _currentRoute;
      updateRoute(routeToNavigateTo);
      return true;
    }
    return false;
  }

  /// Updates route and maintains history
  ///
  /// This method updates the route while keeping track of the previous route
  /// for potential back navigation
  ///
  /// [route] The new route to navigate to
  void updateRouteWithHistory(String route) {
    if (_currentRoute != route) {
      _previousRoute = _currentRoute;
      updateRoute(route);
    }
  }

  /// Resets the content state to default
  ///
  /// This method resets the current route to home and clears history
  void reset() {
    _previousRoute = null;
    updateRoute('/home');
  }
}
