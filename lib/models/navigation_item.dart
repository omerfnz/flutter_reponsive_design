import 'package:flutter/material.dart';

/// Model class representing a navigation item in the application
///
/// This class follows the requirements for navigation items with proper
/// validation and equality operators as specified in requirements 4.1, 4.2, 6.2
class NavigationItem {
  /// Unique identifier for the navigation item
  final String id;

  /// Display title for the navigation item
  final String title;

  /// Icon to be displayed with the navigation item
  final IconData icon;

  /// Route path for navigation
  final String route;

  /// Creates a new NavigationItem instance
  ///
  /// All parameters are required and will be validated
  const NavigationItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.route,
  });

  /// Validates the navigation item properties
  ///
  /// Returns true if all properties are valid, false otherwise
  bool isValid() {
    return _isValidId() && _isValidTitle() && _isValidRoute();
  }

  /// Validates the ID property
  bool _isValidId() {
    return id.isNotEmpty && id.trim().isNotEmpty;
  }

  /// Validates the title property
  bool _isValidTitle() {
    return title.isNotEmpty && title.trim().isNotEmpty;
  }

  /// Validates the route property
  bool _isValidRoute() {
    return route.isNotEmpty && route.trim().isNotEmpty && route.startsWith('/');
  }

  /// Returns validation errors as a list of strings
  List<String> getValidationErrors() {
    List<String> errors = [];

    if (!_isValidId()) {
      errors.add('ID cannot be empty or whitespace only');
    }

    if (!_isValidTitle()) {
      errors.add('Title cannot be empty or whitespace only');
    }

    if (!_isValidRoute()) {
      errors.add('Route must not be empty and must start with "/"');
    }

    return errors;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NavigationItem &&
        other.id == id &&
        other.title == title &&
        other.icon == icon &&
        other.route == route;
  }

  @override
  int get hashCode {
    return Object.hash(id, title, icon, route);
  }

  @override
  String toString() {
    return 'NavigationItem(id: $id, title: $title, icon: $icon, route: $route)';
  }

  /// Creates a copy of this NavigationItem with optionally updated properties
  NavigationItem copyWith({
    String? id,
    String? title,
    IconData? icon,
    String? route,
  }) {
    return NavigationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      route: route ?? this.route,
    );
  }
}
