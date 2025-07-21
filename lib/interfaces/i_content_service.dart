import 'package:flutter/widgets.dart';

/// Interface for content management
/// Defines contracts for route-based content retrieval and management
abstract class IContentService {
  /// Retrieves content widget for a specific route
  /// Returns appropriate widget content based on the provided route
  /// Includes error handling for invalid routes
  Widget getContentForRoute(String route);
}
