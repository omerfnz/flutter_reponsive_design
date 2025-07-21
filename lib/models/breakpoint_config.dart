/// Configuration class for responsive breakpoints
///
/// This class defines the breakpoint values used throughout the application
/// to determine device types and responsive behavior.
/// Follows requirements 3.1, 3.2, 3.3, 5.5
class BreakpointConfig {
  /// Breakpoint for mobile devices (up to 600dp)
  static const double mobileBreakpoint = 600.0;

  /// Breakpoint for tablet devices (600dp to 800dp)
  static const double tabletBreakpoint = 800.0;

  /// Breakpoint for desktop devices (800dp and above)
  static const double desktopBreakpoint = 1200.0;

  /// Grid columns for mobile devices
  static const int mobileGridColumns = 2;

  /// Grid columns for tablet devices
  static const int tabletGridColumns = 4;

  /// Grid columns for desktop devices
  static const int desktopGridColumns = 6;

  // Private constructor to prevent instantiation
  BreakpointConfig._();

  /// Determines if the given width represents a mobile device
  static bool isMobile(double width) {
    return width < mobileBreakpoint;
  }

  /// Determines if the given width represents a tablet device
  static bool isTablet(double width) {
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Determines if the given width represents a desktop device
  static bool isDesktop(double width) {
    return width >= tabletBreakpoint;
  }

  /// Returns the appropriate number of grid columns for the given width
  static int getGridColumns(double width) {
    if (isMobile(width)) {
      return mobileGridColumns;
    } else if (isTablet(width)) {
      return tabletGridColumns;
    } else {
      return desktopGridColumns;
    }
  }

  /// Returns the device type as a string for the given width
  static String getDeviceType(double width) {
    if (isMobile(width)) {
      return 'mobile';
    } else if (isTablet(width)) {
      return 'tablet';
    } else {
      return 'desktop';
    }
  }

  /// Returns all breakpoint values as a map
  static Map<String, double> getAllBreakpoints() {
    return {
      'mobile': mobileBreakpoint,
      'tablet': tabletBreakpoint,
      'desktop': desktopBreakpoint,
    };
  }

  /// Returns all grid column configurations as a map
  static Map<String, int> getAllGridColumns() {
    return {
      'mobile': mobileGridColumns,
      'tablet': tabletGridColumns,
      'desktop': desktopGridColumns,
    };
  }
}
