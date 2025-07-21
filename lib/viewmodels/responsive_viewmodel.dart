import 'package:flutter/foundation.dart';
import '../interfaces/i_responsive_service.dart';

/// ViewModel for managing responsive state and screen size changes
///
/// This class extends ChangeNotifier to provide reactive state management
/// for responsive behavior. It tracks screen width changes and provides
/// computed properties for device type detection and grid calculations.
///
/// Requirements: 1.1, 1.2, 1.3, 3.1, 3.2, 3.3, 5.1, 5.2
class ResponsiveViewModel extends ChangeNotifier {
  final IResponsiveService _responsiveService;
  double _screenWidth = 0;

  /// Creates a ResponsiveViewModel with the required responsive service
  ///
  /// [responsiveService] The service responsible for responsive calculations
  ResponsiveViewModel(this._responsiveService);

  /// Gets the current screen width
  double get screenWidth => _screenWidth;

  /// Determines if the current screen size represents a mobile device
  ///
  /// Uses the responsive service to check if the current screen width
  /// falls within the mobile breakpoint range
  bool get isMobile => _responsiveService.isMobile(_screenWidth);

  /// Determines if the current screen size represents a tablet device
  ///
  /// Uses the responsive service to check if the current screen width
  /// falls within the tablet breakpoint range
  bool get isTablet => _responsiveService.isTablet(_screenWidth);

  /// Determines if the current screen size represents a desktop device
  ///
  /// Uses the responsive service to check if the current screen width
  /// falls within the desktop breakpoint range
  bool get isDesktop => _responsiveService.isDesktop(_screenWidth);

  /// Gets the appropriate number of grid columns for the current screen size
  ///
  /// Uses the responsive service to calculate the optimal number of columns
  /// based on the current screen width (2 for mobile, 4 for tablet, 6 for desktop)
  int get gridColumns => _responsiveService.getGridColumns(_screenWidth);

  /// Updates the screen width and notifies listeners of the change
  ///
  /// This method should be called whenever the screen size changes,
  /// typically from a MediaQuery listener in the UI layer
  ///
  /// [width] The new screen width in logical pixels
  void updateScreenWidth(double width) {
    if (_screenWidth != width) {
      _screenWidth = width;
      notifyListeners();
    }
  }

  /// Gets a string representation of the current device type
  ///
  /// Returns 'mobile', 'tablet', or 'desktop' based on current screen width
  String get deviceType {
    if (isMobile) return 'mobile';
    if (isTablet) return 'tablet';
    return 'desktop';
  }

  /// Checks if the current screen width supports navigation rail
  ///
  /// Navigation rail is typically shown on tablet and desktop devices
  /// Returns true for tablet and desktop, false for mobile
  bool get shouldShowNavigationRail => isTablet || isDesktop;

  /// Checks if the current screen width requires a navigation drawer
  ///
  /// Navigation drawer is typically used on mobile devices
  /// Returns true for mobile, false for tablet and desktop
  bool get shouldShowNavigationDrawer => isMobile;

  /// Gets the maximum cross axis extent for grid items based on screen size
  ///
  /// This value can be used with SliverGridDelegateWithMaxCrossAxisExtent
  /// to create responsive grid layouts
  double get maxCrossAxisExtent {
    if (_screenWidth <= 0) {
      debugPrint(
        'Warning: screenWidth is 0 or less, using fallback maxCrossAxisExtent=200.0',
      );
      return 200.0;
    }
    if (isMobile) return _screenWidth / 2; // 2 columns
    if (isTablet) return _screenWidth / 4; // 4 columns
    return _screenWidth / 6; // 6 columns for desktop
  }

  /// Checks if the screen width has been initialized
  ///
  /// Returns true if updateScreenWidth has been called at least once
  bool get isInitialized => _screenWidth > 0;

  /// Resets the screen width to 0 and notifies listeners
  ///
  /// This method can be used for testing or when the screen context is lost
  void reset() {
    if (_screenWidth != 0) {
      _screenWidth = 0;
      notifyListeners();
    }
  }
}
