import 'package:flutter/material.dart';
import 'navigation_item.dart';

/// Static data provider for navigation items
///
/// This class provides sample navigation items for the application
/// including Home, Profile, Settings, and About as specified in
/// requirements 4.1, 4.2
class NavigationData {
  // Private constructor to prevent instantiation
  NavigationData._();

  /// Static list of navigation items for the application
  static final List<NavigationItem> _items = [
    const NavigationItem(
      id: 'home',
      title: 'Home',
      icon: Icons.home,
      route: '/home',
    ),
    const NavigationItem(
      id: 'profile',
      title: 'Profile',
      icon: Icons.person,
      route: '/profile',
    ),
    const NavigationItem(
      id: 'settings',
      title: 'Settings',
      icon: Icons.settings,
      route: '/settings',
    ),
    const NavigationItem(
      id: 'about',
      title: 'About',
      icon: Icons.info,
      route: '/about',
    ),
  ];

  /// Returns all navigation items
  static List<NavigationItem> get items => List.unmodifiable(_items);

  /// Returns the number of navigation items
  static int get itemCount => _items.length;

  /// Finds a navigation item by its ID
  ///
  /// Returns null if no item with the given ID is found
  static NavigationItem? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Finds a navigation item by its route
  ///
  /// Returns null if no item with the given route is found
  static NavigationItem? findByRoute(String route) {
    try {
      return _items.firstWhere((item) => item.route == route);
    } catch (e) {
      return null;
    }
  }

  /// Returns the default navigation item (Home)
  static NavigationItem get defaultItem => _items.first;

  /// Checks if a navigation item with the given ID exists
  static bool hasItemWithId(String id) {
    return _items.any((item) => item.id == id);
  }

  /// Checks if a navigation item with the given route exists
  static bool hasItemWithRoute(String route) {
    return _items.any((item) => item.route == route);
  }

  /// Returns all navigation item IDs
  static List<String> get allIds => _items.map((item) => item.id).toList();

  /// Returns all navigation item routes
  static List<String> get allRoutes =>
      _items.map((item) => item.route).toList();

  /// Returns all navigation item titles
  static List<String> get allTitles =>
      _items.map((item) => item.title).toList();

  /// Validates all navigation items in the data provider
  ///
  /// Returns true if all items are valid, false otherwise
  static bool validateAllItems() {
    return _items.every((item) => item.isValid());
  }

  /// Returns validation errors for all items
  ///
  /// Returns a map where keys are item IDs and values are lists of validation errors
  static Map<String, List<String>> getAllValidationErrors() {
    Map<String, List<String>> errors = {};

    for (final item in _items) {
      final itemErrors = item.getValidationErrors();
      if (itemErrors.isNotEmpty) {
        errors[item.id] = itemErrors;
      }
    }

    return errors;
  }

  /// Checks for duplicate IDs in the navigation items
  ///
  /// Returns a list of duplicate IDs found
  static List<String> findDuplicateIds() {
    final ids = <String>[];
    final duplicates = <String>[];

    for (final item in _items) {
      if (ids.contains(item.id)) {
        if (!duplicates.contains(item.id)) {
          duplicates.add(item.id);
        }
      } else {
        ids.add(item.id);
      }
    }

    return duplicates;
  }

  /// Checks for duplicate routes in the navigation items
  ///
  /// Returns a list of duplicate routes found
  static List<String> findDuplicateRoutes() {
    final routes = <String>[];
    final duplicates = <String>[];

    for (final item in _items) {
      if (routes.contains(item.route)) {
        if (!duplicates.contains(item.route)) {
          duplicates.add(item.route);
        }
      } else {
        routes.add(item.route);
      }
    }

    return duplicates;
  }

  /// Returns a summary of the navigation data
  static Map<String, dynamic> getSummary() {
    return {
      'totalItems': itemCount,
      'allValid': validateAllItems(),
      'duplicateIds': findDuplicateIds(),
      'duplicateRoutes': findDuplicateRoutes(),
      'items':
          _items
              .map(
                (item) => {
                  'id': item.id,
                  'title': item.title,
                  'route': item.route,
                  'isValid': item.isValid(),
                },
              )
              .toList(),
    };
  }
}
