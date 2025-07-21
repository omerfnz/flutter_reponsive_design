import 'package:flutter/material.dart';
import '../interfaces/i_navigation_service.dart';
import '../models/navigation_item.dart';
import '../models/navigation_data.dart';

/// Implementation of INavigationService for navigation management
///
/// This service provides methods for managing navigation items and handling
/// navigation logic. It follows SOLID principles and includes proper error
/// handling for invalid routes.
///
/// Follows requirements: 4.1, 4.2, 6.5
class NavigationService implements INavigationService {
  /// Optional navigation context for programmatic navigation
  final GlobalKey<NavigatorState>? _navigatorKey;

  /// Callback function for handling navigation events
  final Function(NavigationItem)? _onNavigationChanged;

  /// Creates a new instance of NavigationService
  ///
  /// [navigatorKey] Optional navigator key for programmatic navigation
  /// [onNavigationChanged] Optional callback for navigation events
  const NavigationService({
    GlobalKey<NavigatorState>? navigatorKey,
    Function(NavigationItem)? onNavigationChanged,
  }) : _navigatorKey = navigatorKey,
       _onNavigationChanged = onNavigationChanged;

  @override
  List<NavigationItem> getNavigationItems() {
    try {
      final items = NavigationData.items;

      // Validate all items before returning
      if (!NavigationData.validateAllItems()) {
        final errors = NavigationData.getAllValidationErrors();
        debugPrint(
          'Warning: Some navigation items have validation errors: $errors',
        );
      }

      // Check for duplicates
      final duplicateIds = NavigationData.findDuplicateIds();
      final duplicateRoutes = NavigationData.findDuplicateRoutes();

      if (duplicateIds.isNotEmpty) {
        throw StateError('Duplicate navigation item IDs found: $duplicateIds');
      }

      if (duplicateRoutes.isNotEmpty) {
        throw StateError(
          'Duplicate navigation item routes found: $duplicateRoutes',
        );
      }

      return items;
    } catch (e) {
      debugPrint('Error getting navigation items: $e');
      // Return a fallback list with just the home item
      return [NavigationData.defaultItem];
    }
  }

  @override
  void navigateToItem(NavigationItem item) {
    // Validate the navigation item
    if (!item.isValid()) {
      final errors = item.getValidationErrors();
      throw ArgumentError('Invalid navigation item: ${errors.join(', ')}');
    }

    // Check if the item exists in our navigation data
    if (!NavigationData.hasItemWithRoute(item.route)) {
      throw ArgumentError(
        'Navigation item with route "${item.route}" not found in navigation data',
      );
    }

    try {
      // Perform the navigation
      _performNavigation(item);

      // Notify listeners if callback is provided
      _onNavigationChanged?.call(item);
    } catch (e) {
      _handleNavigationError(item, e);
      // Re-throw the error after handling for debugging purposes
      rethrow;
    }
  }

  /// Performs the actual navigation logic
  void _performNavigation(NavigationItem item) {
    if (_navigatorKey?.currentState != null) {
      // Use programmatic navigation if navigator key is available
      _navigatorKey!.currentState!.pushNamed(item.route);
    } else {
      // Log the navigation for debugging purposes
      debugPrint('Navigating to: ${item.title} (${item.route})');
    }
  }

  /// Handles navigation errors with appropriate fallback behavior
  void _handleNavigationError(NavigationItem item, dynamic error) {
    debugPrint('Navigation error for item ${item.id}: $error');

    // Try to navigate to home as fallback
    try {
      final homeItem = NavigationData.defaultItem;
      if (homeItem.id != item.id) {
        // Avoid infinite recursion
        debugPrint('Falling back to home navigation');
        _performNavigation(homeItem);
        _onNavigationChanged?.call(homeItem);
      }
    } catch (fallbackError) {
      debugPrint('Fallback navigation also failed: $fallbackError');
    }
  }

  /// Finds a navigation item by its ID
  ///
  /// Returns null if no item with the given ID is found
  NavigationItem? findItemById(String id) {
    if (id.isEmpty) {
      throw ArgumentError('Item ID cannot be empty');
    }

    return NavigationData.findById(id);
  }

  /// Finds a navigation item by its route
  ///
  /// Returns null if no item with the given route is found
  NavigationItem? findItemByRoute(String route) {
    if (route.isEmpty) {
      throw ArgumentError('Route cannot be empty');
    }

    return NavigationData.findByRoute(route);
  }

  /// Gets the default navigation item (Home)
  NavigationItem getDefaultItem() {
    return NavigationData.defaultItem;
  }

  /// Checks if a navigation item with the given ID exists
  bool hasItemWithId(String id) {
    if (id.isEmpty) {
      return false;
    }

    return NavigationData.hasItemWithId(id);
  }

  /// Checks if a navigation item with the given route exists
  bool hasItemWithRoute(String route) {
    if (route.isEmpty) {
      return false;
    }

    return NavigationData.hasItemWithRoute(route);
  }

  /// Gets all available navigation routes
  List<String> getAllRoutes() {
    return NavigationData.allRoutes;
  }

  /// Gets all available navigation item IDs
  List<String> getAllIds() {
    return NavigationData.allIds;
  }

  /// Validates a route string
  ///
  /// Returns true if the route is valid and exists in navigation data
  bool isValidRoute(String route) {
    if (route.isEmpty || !route.startsWith('/')) {
      return false;
    }

    return NavigationData.hasItemWithRoute(route);
  }

  /// Gets navigation statistics and summary
  Map<String, dynamic> getNavigationSummary() {
    return NavigationData.getSummary();
  }

  /// Navigates to a route by string
  ///
  /// This is a convenience method that finds the navigation item by route
  /// and then navigates to it
  void navigateToRoute(String route) {
    if (route.isEmpty) {
      throw ArgumentError('Route cannot be empty');
    }

    final item = findItemByRoute(route);
    if (item == null) {
      throw ArgumentError('No navigation item found for route: $route');
    }

    navigateToItem(item);
  }

  /// Navigates to an item by ID
  ///
  /// This is a convenience method that finds the navigation item by ID
  /// and then navigates to it
  void navigateToId(String id) {
    if (id.isEmpty) {
      throw ArgumentError('ID cannot be empty');
    }

    final item = findItemById(id);
    if (item == null) {
      throw ArgumentError('No navigation item found for ID: $id');
    }

    navigateToItem(item);
  }

  /// Navigates to the default item (Home)
  void navigateToDefault() {
    navigateToItem(getDefaultItem());
  }
}
