import '../interfaces/i_responsive_service.dart';
import '../models/breakpoint_config.dart';

/// Implementation of IResponsiveService for responsive behavior management
///
/// This service provides methods for detecting device types and calculating
/// responsive layout properties based on screen width. It follows SOLID
/// principles and uses dependency injection for testability.
///
/// Follows requirements: 1.2, 1.3, 3.1, 3.2, 3.3, 5.1, 5.2
class ResponsiveService implements IResponsiveService {
  /// Creates a new instance of ResponsiveService
  const ResponsiveService();

  @override
  bool isMobile(double width) {
    // Validate input parameter
    if (width < 0) {
      throw ArgumentError('Screen width cannot be negative: $width');
    }

    return BreakpointConfig.isMobile(width);
  }

  @override
  bool isTablet(double width) {
    // Validate input parameter
    if (width < 0) {
      throw ArgumentError('Screen width cannot be negative: $width');
    }

    return BreakpointConfig.isTablet(width);
  }

  @override
  bool isDesktop(double width) {
    // Validate input parameter
    if (width < 0) {
      throw ArgumentError('Screen width cannot be negative: $width');
    }

    return BreakpointConfig.isDesktop(width);
  }

  @override
  int getGridColumns(double width) {
    // Validate input parameter
    if (width < 0) {
      throw ArgumentError('Screen width cannot be negative: $width');
    }

    return BreakpointConfig.getGridColumns(width);
  }

  /// Gets the device type as a string for debugging purposes
  String getDeviceType(double width) {
    if (width < 0) {
      throw ArgumentError('Screen width cannot be negative: $width');
    }

    return BreakpointConfig.getDeviceType(width);
  }

  /// Gets all breakpoint values for configuration purposes
  Map<String, double> getAllBreakpoints() {
    return BreakpointConfig.getAllBreakpoints();
  }

  /// Gets all grid column configurations
  Map<String, int> getAllGridColumns() {
    return BreakpointConfig.getAllGridColumns();
  }

  /// Determines if the screen width is at a specific breakpoint boundary
  bool isAtBreakpoint(double width, String breakpointName) {
    if (width < 0) {
      throw ArgumentError('Screen width cannot be negative: $width');
    }

    final breakpoints = getAllBreakpoints();
    final breakpointValue = breakpoints[breakpointName.toLowerCase()];

    if (breakpointValue == null) {
      throw ArgumentError('Unknown breakpoint: $breakpointName');
    }

    // Consider a small tolerance for floating point comparison
    const tolerance = 1.0;
    return (width - breakpointValue).abs() <= tolerance;
  }

  /// Gets the maximum cross axis extent for grid items based on screen width
  double getMaxCrossAxisExtent(double width) {
    if (width < 0) {
      throw ArgumentError('Screen width cannot be negative: $width');
    }

    if (isMobile(width)) {
      return 200.0; // Mobile: larger items for better touch interaction
    } else if (isTablet(width)) {
      return 180.0; // Tablet: medium-sized items
    } else {
      return 160.0; // Desktop: smaller items to fit more content
    }
  }

  /// Calculates the optimal item width for grid items
  double getOptimalItemWidth(double screenWidth, {double padding = 16.0}) {
    if (screenWidth < 0) {
      throw ArgumentError('Screen width cannot be negative: $screenWidth');
    }

    final columns = getGridColumns(screenWidth);
    final availableWidth = screenWidth - (padding * 2);
    final itemSpacing = 8.0 * (columns - 1); // 8dp spacing between items

    return (availableWidth - itemSpacing) / columns;
  }
}
