import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/responsive_viewmodel.dart';
import '../viewmodels/content_viewmodel.dart';
import 'grid_content_view.dart';

/// Main content area with responsive grid layout
///
/// This widget serves as the primary content container that integrates
/// responsive grid column calculation and content area layout management.
/// It uses Consumer2 to listen to both ResponsiveViewModel and ContentViewModel.
///
/// Requirements: 2.4, 3.1, 3.2, 3.3, 5.3
class MainContentView extends StatelessWidget {
  /// Optional padding around the content
  final EdgeInsets? padding;

  /// Optional background color for the content area
  final Color? backgroundColor;

  /// Creates a MainContentView
  ///
  /// [padding] Optional padding around the content
  /// [backgroundColor] Optional background color for the content area
  const MainContentView({super.key, this.padding, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ResponsiveViewModel, ContentViewModel>(
      builder: (context, responsive, content, child) {
        return Container(
          color: backgroundColor ?? Theme.of(context).colorScheme.surface,
          padding: padding ?? const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content header with route information
              _buildContentHeader(context, content, responsive),

              const SizedBox(height: 16),

              // Main content area with responsive grid
              Expanded(child: _buildMainContent(context, responsive, content)),
            ],
          ),
        );
      },
    );
  }

  /// Builds the content header showing current route and device info
  Widget _buildContentHeader(
    BuildContext context,
    ContentViewModel content,
    ResponsiveViewModel responsive,
  ) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Route: ${content.currentRoute}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Device: ${responsive.deviceType} • Grid Columns: ${responsive.gridColumns}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              _getRouteIcon(content.currentRoute),
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the main content area with responsive grid
  Widget _buildMainContent(
    BuildContext context,
    ResponsiveViewModel responsive,
    ContentViewModel content,
  ) {
    return GridContentView(
      columns: responsive.gridColumns,
      maxCrossAxisExtent: responsive.maxCrossAxisExtent,
      currentRoute: content.currentRoute,
    );
  }

  /// Gets the appropriate icon for the current route
  IconData _getRouteIcon(String route) {
    switch (route) {
      case '/home':
        return Icons.home;
      case '/profile':
        return Icons.person;
      case '/settings':
        return Icons.settings;
      case '/about':
        return Icons.info;
      default:
        return Icons.dashboard;
    }
  }
}
