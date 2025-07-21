/// Interface for responsive behavior management
/// Defines contracts for screen size detection and responsive calculations
abstract class IResponsiveService {
  /// Determines if the current screen width represents a mobile device
  /// Returns true if width is below mobile breakpoint
  bool isMobile(double width);

  /// Determines if the current screen width represents a tablet device
  /// Returns true if width is between mobile and desktop breakpoints
  bool isTablet(double width);

  /// Determines if the current screen width represents a desktop device
  /// Returns true if width is above desktop breakpoint
  bool isDesktop(double width);

  /// Calculates the appropriate number of grid columns based on screen width
  /// Returns column count optimized for the current screen size
  int getGridColumns(double width);
}
