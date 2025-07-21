import 'package:flutter/foundation.dart';
import '../interfaces/i_navigation_service.dart';
import '../models/navigation_item.dart';

/// ViewModel for managing navigation state and user interactions
///
/// This class extends ChangeNotifier to provide reactive state management
/// for navigation-related functionality. It follows MVVM architecture
/// principles and implements proper dependency injection.
///
/// Requirements: 4.3, 4.4, 5.1, 5.2, 6.4
class NavigationViewModel extends ChangeNotifier {
  final INavigationService _navigationService;
  NavigationItem? _selectedItem;

  /// Creates a NavigationViewModel with the required navigation service
  ///
  /// [navigationService] The service responsible for navigation operations
  NavigationViewModel(this._navigationService);

  /// Gets the currently selected navigation item
  NavigationItem? get selectedItem => _selectedItem;

  /// Gets the list of available navigation items from the service
  List<NavigationItem> get navigationItems =>
      _navigationService.getNavigationItems();

  /// Selects a navigation item and triggers navigation
  ///
  /// This method updates the selected item state and delegates the actual
  /// navigation to the navigation service. It notifies listeners of the
  /// state change to update the UI accordingly.
  ///
  /// [item] The navigation item to select and navigate to
  void selectItem(NavigationItem item) {
    if (_selectedItem != item) {
      _selectedItem = item;
      _navigationService.navigateToItem(item);
      notifyListeners();
    }
  }

  /// Clears the current selection
  ///
  /// This method resets the selected item to null and notifies listeners
  void clearSelection() {
    if (_selectedItem != null) {
      _selectedItem = null;
      notifyListeners();
    }
  }

  /// Checks if a specific item is currently selected
  ///
  /// [item] The navigation item to check
  /// Returns true if the item is currently selected, false otherwise
  bool isItemSelected(NavigationItem item) {
    return _selectedItem == item;
  }

  /// Gets the index of the currently selected item in the navigation items list
  ///
  /// Returns the index of the selected item, or -1 if no item is selected
  /// or the selected item is not found in the list
  int get selectedIndex {
    if (_selectedItem == null) return -1;

    final items = navigationItems;
    for (int i = 0; i < items.length; i++) {
      if (items[i] == _selectedItem) {
        return i;
      }
    }
    return -1;
  }

  /// Selects an item by its index in the navigation items list
  ///
  /// [index] The index of the item to select
  /// Throws [RangeError] if the index is out of bounds
  void selectItemByIndex(int index) {
    final items = navigationItems;
    if (index < 0 || index >= items.length) {
      throw RangeError.index(index, items, 'index');
    }
    selectItem(items[index]);
  }

  /// Selects an item by its ID
  ///
  /// [id] The ID of the item to select
  /// Returns true if an item with the given ID was found and selected,
  /// false otherwise
  bool selectItemById(String id) {
    final items = navigationItems;
    for (final item in items) {
      if (item.id == id) {
        selectItem(item);
        return true;
      }
    }
    return false;
  }
}
