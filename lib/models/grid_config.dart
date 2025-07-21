/// Configuration class for grid layout management
///
/// This class manages grid configuration settings including columns,
/// cross-axis extent, and aspect ratios for responsive grid layouts.
/// Follows requirements 3.1, 3.2, 3.3, 5.5
class GridConfig {
  /// Number of columns in the grid
  final int columns;

  /// Maximum cross-axis extent for grid items
  final double maxCrossAxisExtent;

  /// Aspect ratio for grid items (width/height)
  final double childAspectRatio;

  /// Main axis spacing between grid items
  final double mainAxisSpacing;

  /// Cross axis spacing between grid items
  final double crossAxisSpacing;

  /// Creates a new GridConfig instance
  const GridConfig({
    required this.columns,
    required this.maxCrossAxisExtent,
    this.childAspectRatio = 1.0,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
  });

  /// Creates a GridConfig for mobile devices
  factory GridConfig.mobile({
    double childAspectRatio = 1.0,
    double mainAxisSpacing = 8.0,
    double crossAxisSpacing = 8.0,
  }) {
    return GridConfig(
      columns: 2,
      maxCrossAxisExtent: 200.0,
      childAspectRatio: childAspectRatio,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
    );
  }

  /// Creates a GridConfig for tablet devices
  factory GridConfig.tablet({
    double childAspectRatio = 1.0,
    double mainAxisSpacing = 8.0,
    double crossAxisSpacing = 8.0,
  }) {
    return GridConfig(
      columns: 4,
      maxCrossAxisExtent: 180.0,
      childAspectRatio: childAspectRatio,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
    );
  }

  /// Creates a GridConfig for desktop devices
  factory GridConfig.desktop({
    double childAspectRatio = 1.0,
    double mainAxisSpacing = 8.0,
    double crossAxisSpacing = 8.0,
  }) {
    return GridConfig(
      columns: 6,
      maxCrossAxisExtent: 160.0,
      childAspectRatio: childAspectRatio,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
    );
  }

  /// Creates a GridConfig based on screen width
  factory GridConfig.fromScreenWidth(
    double screenWidth, {
    double childAspectRatio = 1.0,
    double mainAxisSpacing = 8.0,
    double crossAxisSpacing = 8.0,
  }) {
    if (screenWidth < 600) {
      return GridConfig.mobile(
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      );
    } else if (screenWidth < 800) {
      return GridConfig.tablet(
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      );
    } else {
      return GridConfig.desktop(
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      );
    }
  }

  /// Validates the grid configuration
  bool isValid() {
    return columns > 0 &&
        maxCrossAxisExtent > 0 &&
        childAspectRatio > 0 &&
        mainAxisSpacing >= 0 &&
        crossAxisSpacing >= 0;
  }

  /// Returns validation errors as a list of strings
  List<String> getValidationErrors() {
    List<String> errors = [];

    if (columns <= 0) {
      errors.add('Columns must be greater than 0');
    }

    if (maxCrossAxisExtent <= 0) {
      errors.add('Max cross axis extent must be greater than 0');
    }

    if (childAspectRatio <= 0) {
      errors.add('Child aspect ratio must be greater than 0');
    }

    if (mainAxisSpacing < 0) {
      errors.add('Main axis spacing cannot be negative');
    }

    if (crossAxisSpacing < 0) {
      errors.add('Cross axis spacing cannot be negative');
    }

    return errors;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GridConfig &&
        other.columns == columns &&
        other.maxCrossAxisExtent == maxCrossAxisExtent &&
        other.childAspectRatio == childAspectRatio &&
        other.mainAxisSpacing == mainAxisSpacing &&
        other.crossAxisSpacing == crossAxisSpacing;
  }

  @override
  int get hashCode {
    return Object.hash(
      columns,
      maxCrossAxisExtent,
      childAspectRatio,
      mainAxisSpacing,
      crossAxisSpacing,
    );
  }

  @override
  String toString() {
    return 'GridConfig('
        'columns: $columns, '
        'maxCrossAxisExtent: $maxCrossAxisExtent, '
        'childAspectRatio: $childAspectRatio, '
        'mainAxisSpacing: $mainAxisSpacing, '
        'crossAxisSpacing: $crossAxisSpacing'
        ')';
  }

  /// Creates a copy of this GridConfig with optionally updated properties
  GridConfig copyWith({
    int? columns,
    double? maxCrossAxisExtent,
    double? childAspectRatio,
    double? mainAxisSpacing,
    double? crossAxisSpacing,
  }) {
    return GridConfig(
      columns: columns ?? this.columns,
      maxCrossAxisExtent: maxCrossAxisExtent ?? this.maxCrossAxisExtent,
      childAspectRatio: childAspectRatio ?? this.childAspectRatio,
      mainAxisSpacing: mainAxisSpacing ?? this.mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing ?? this.crossAxisSpacing,
    );
  }
}
