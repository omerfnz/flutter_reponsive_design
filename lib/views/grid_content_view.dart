import 'package:flutter/material.dart';

/// Grid content view with dynamic column support
///
/// This widget implements a responsive grid using GridView.builder with
/// SliverGridDelegateWithMaxCrossAxisExtent. It supports dynamic column
/// calculation (2 for mobile, 4 for tablet, 6 for desktop) and proper
/// grid item rendering with sample content.
///
/// Requirements: 3.1, 3.2, 3.3, 3.4, 5.3
class GridContentView extends StatelessWidget {
  /// Number of columns for the grid
  final int columns;

  /// Maximum cross axis extent for grid items
  final double maxCrossAxisExtent;

  /// Current route for content customization
  final String currentRoute;

  /// Child aspect ratio for grid items
  final double childAspectRatio;

  /// Spacing between grid items
  final double spacing;

  /// Creates a GridContentView
  ///
  /// [columns] Number of columns for the grid
  /// [maxCrossAxisExtent] Maximum cross axis extent for grid items
  /// [currentRoute] Current route for content customization
  /// [childAspectRatio] Child aspect ratio for grid items (default: 1.0)
  /// [spacing] Spacing between grid items (default: 8.0)
  const GridContentView({
    super.key,
    required this.columns,
    required this.maxCrossAxisExtent,
    required this.currentRoute,
    this.childAspectRatio = 1.0,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxCrossAxisExtent,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: _getItemCount(),
      itemBuilder: (context, index) => _buildGridItem(context, index),
    );
  }

  /// Gets the number of items to display based on the current route
  int _getItemCount() {
    switch (currentRoute) {
      case '/home':
        return 12; // Show more items on home
      case '/profile':
        return 6;
      case '/settings':
        return 8;
      case '/about':
        return 4;
      default:
        return 9;
    }
  }

  /// Builds individual grid items with sample content
  Widget _buildGridItem(BuildContext context, int index) {
    final itemData = _getItemData(index);

    return Focus(
      canRequestFocus: true,
      child: Semantics(
        label: '${itemData.title}, ${itemData.subtitle} grid öğesi',
        button: true,
        child: Card(
          elevation: 2,
          child: InkWell(
            onTap: () => _handleItemTap(context, index),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Item icon
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: itemData.color.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        itemData.icon,
                        color: itemData.color,
                        size: 24,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Item title
                  Flexible(
                    child: Text(
                      itemData.title,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(height: 2),

                  // Item subtitle
                  Flexible(
                    child: Text(
                      itemData.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Gets sample data for grid items based on current route and index
  GridItemData _getItemData(int index) {
    final baseItems = _getBaseItemsForRoute();
    final itemIndex = index % baseItems.length;
    final baseItem = baseItems[itemIndex];

    return GridItemData(
      title: '${baseItem.title} ${index + 1}',
      subtitle: baseItem.subtitle,
      icon: baseItem.icon,
      color: baseItem.color,
    );
  }

  /// Gets base items for the current route
  List<GridItemData> _getBaseItemsForRoute() {
    switch (currentRoute) {
      case '/home':
        return [
          GridItemData(
            title: 'Dashboard',
            subtitle: 'Overview',
            icon: Icons.dashboard,
            color: Colors.blue,
          ),
          GridItemData(
            title: 'Analytics',
            subtitle: 'Data insights',
            icon: Icons.analytics,
            color: Colors.green,
          ),
          GridItemData(
            title: 'Reports',
            subtitle: 'Generate reports',
            icon: Icons.assessment,
            color: Colors.orange,
          ),
          GridItemData(
            title: 'Tasks',
            subtitle: 'Manage tasks',
            icon: Icons.task,
            color: Colors.purple,
          ),
        ];

      case '/profile':
        return [
          GridItemData(
            title: 'Personal Info',
            subtitle: 'Edit details',
            icon: Icons.person,
            color: Colors.indigo,
          ),
          GridItemData(
            title: 'Security',
            subtitle: 'Privacy settings',
            icon: Icons.security,
            color: Colors.red,
          ),
          GridItemData(
            title: 'Preferences',
            subtitle: 'App settings',
            icon: Icons.tune,
            color: Colors.teal,
          ),
        ];

      case '/settings':
        return [
          GridItemData(
            title: 'General',
            subtitle: 'App preferences',
            icon: Icons.settings,
            color: Colors.grey,
          ),
          GridItemData(
            title: 'Notifications',
            subtitle: 'Alert settings',
            icon: Icons.notifications,
            color: Colors.amber,
          ),
          GridItemData(
            title: 'Theme',
            subtitle: 'Appearance',
            icon: Icons.palette,
            color: Colors.pink,
          ),
          GridItemData(
            title: 'Storage',
            subtitle: 'Manage data',
            icon: Icons.storage,
            color: Colors.cyan,
          ),
        ];

      case '/about':
        return [
          GridItemData(
            title: 'Version',
            subtitle: 'App info',
            icon: Icons.info,
            color: Colors.blue,
          ),
          GridItemData(
            title: 'Support',
            subtitle: 'Get help',
            icon: Icons.support,
            color: Colors.green,
          ),
          GridItemData(
            title: 'Feedback',
            subtitle: 'Send feedback',
            icon: Icons.feedback,
            color: Colors.orange,
          ),
        ];

      default:
        return [
          GridItemData(
            title: 'Item',
            subtitle: 'Sample content',
            icon: Icons.widgets,
            color: Colors.grey,
          ),
        ];
    }
  }

  /// Handles item tap events
  void _handleItemTap(BuildContext context, int index) {
    final itemData = _getItemData(index);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tapped on ${itemData.title}'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Data class for grid items
class GridItemData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const GridItemData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
