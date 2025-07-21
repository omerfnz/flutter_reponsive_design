import 'package:flutter/material.dart';
import '../interfaces/i_content_service.dart';
import '../models/navigation_data.dart';

/// Implementation of IContentService for content management
///
/// This service provides route-based content retrieval with proper error
/// handling and fallback content for invalid routes. It follows SOLID
/// principles and includes comprehensive error handling.
///
/// Follows requirements: 2.4, 6.5
class ContentService implements IContentService {
  /// Default route to use when no route is specified or route is invalid
  static const String _defaultRoute = '/home';

  /// Creates a new instance of ContentService
  const ContentService();

  @override
  Widget getContentForRoute(String route) {
    try {
      // Validate the route parameter
      if (route.isEmpty) {
        debugPrint('Warning: Empty route provided, using default route');
        return _getContentForValidRoute(_defaultRoute);
      }

      // Normalize the route (ensure it starts with /)
      final normalizedRoute = _normalizeRoute(route);

      // Check if the route exists in navigation data
      if (!NavigationData.hasItemWithRoute(normalizedRoute)) {
        debugPrint(
          'Warning: Route "$normalizedRoute" not found, using fallback content',
        );
        return _getFallbackContent(normalizedRoute);
      }

      return _getContentForValidRoute(normalizedRoute);
    } catch (e) {
      debugPrint('Error getting content for route "$route": $e');
      return _getErrorContent(route, e.toString());
    }
  }

  /// Normalizes a route string to ensure it starts with /
  String _normalizeRoute(String route) {
    if (route.startsWith('/')) {
      return route;
    }
    return '/$route';
  }

  /// Gets content for a valid route that exists in navigation data
  Widget _getContentForValidRoute(String route) {
    final navigationItem = NavigationData.findByRoute(route);

    if (navigationItem == null) {
      return _getFallbackContent(route);
    }

    switch (route) {
      case '/home':
        return _buildHomeContent();
      case '/profile':
        return _buildProfileContent();
      case '/settings':
        return _buildSettingsContent();
      case '/about':
        return _buildAboutContent();
      default:
        return _getFallbackContent(route);
    }
  }

  /// Builds content for the Home route
  Widget _buildHomeContent() {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 64, color: Colors.blue),
            SizedBox(height: 16),
            Text(
              'Welcome Home',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'This is the home page content',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds content for the Profile route
  Widget _buildProfileContent() {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 64, color: Colors.green),
            SizedBox(height: 16),
            Text(
              'User Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'This is the profile page content',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds content for the Settings route
  Widget _buildSettingsContent() {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 64, color: Colors.orange),
            SizedBox(height: 16),
            Text(
              'Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'This is the settings page content',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds content for the About route
  Widget _buildAboutContent() {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info, size: 64, color: Colors.purple),
            SizedBox(height: 16),
            Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'This is the about page content',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  /// Gets fallback content for invalid or unknown routes
  Widget _getFallbackContent(String route) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning, size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            const Text(
              'Route Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'The route "$route" was not found.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // This would typically navigate to home
                debugPrint('Navigate to home from fallback content');
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }

  /// Gets error content when an exception occurs
  Widget _getErrorContent(String route, String error) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Content Error',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Error loading content for route "$route"',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Error: $error',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // This would typically retry or navigate to home
                debugPrint('Retry loading content for route: $route');
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  /// Checks if a route is supported by this content service
  bool isRouteSupported(String route) {
    if (route.isEmpty) {
      return false;
    }

    final normalizedRoute = _normalizeRoute(route);
    return NavigationData.hasItemWithRoute(normalizedRoute);
  }

  /// Gets all supported routes
  List<String> getSupportedRoutes() {
    return NavigationData.allRoutes;
  }

  /// Gets the default route
  String getDefaultRoute() {
    return _defaultRoute;
  }

  /// Gets content type description for a route
  String getContentTypeForRoute(String route) {
    if (route.isEmpty) {
      return 'Unknown';
    }

    final normalizedRoute = _normalizeRoute(route);

    switch (normalizedRoute) {
      case '/home':
        return 'Home Page';
      case '/profile':
        return 'User Profile';
      case '/settings':
        return 'Application Settings';
      case '/about':
        return 'About Information';
      default:
        return 'Unknown Content';
    }
  }

  /// Validates if a route string is properly formatted
  bool isValidRouteFormat(String route) {
    if (route.isEmpty) {
      return false;
    }

    // Route should start with / and contain only valid characters, no trailing slash
    final routeRegex = RegExp(r'^\/[a-zA-Z0-9_\-]+(?:\/[a-zA-Z0-9_\-]+)*$');
    return routeRegex.hasMatch(route);
  }

  /// Gets content summary for debugging and monitoring
  Map<String, dynamic> getContentSummary() {
    final supportedRoutes = getSupportedRoutes();

    return {
      'defaultRoute': _defaultRoute,
      'supportedRoutes': supportedRoutes,
      'totalSupportedRoutes': supportedRoutes.length,
      'contentTypes':
          supportedRoutes
              .map(
                (route) => {
                  'route': route,
                  'type': getContentTypeForRoute(route),
                },
              )
              .toList(),
    };
  }
}
