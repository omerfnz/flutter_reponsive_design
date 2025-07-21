import '../models/navigation_item.dart';

/// Interface for navigation management
/// Defines contracts for navigation item handling and routing
abstract class INavigationService {
  /// Retrieves the list of available navigation items
  /// Returns a list of NavigationItem objects for the application
  List<NavigationItem> getNavigationItems();

  /// Handles navigation to a specific navigation item
  /// Performs the actual navigation logic for the given item
  void navigateToItem(NavigationItem item);
}
