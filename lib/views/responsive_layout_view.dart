import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/responsive_viewmodel.dart';
import 'navigation_rail_view.dart';
import 'navigation_drawer_view.dart';

/// Main responsive layout wrapper that adapts to different screen sizes
///
/// This widget serves as the primary layout container that conditionally
/// renders NavigationRail for desktop/tablet or Drawer for mobile screens.
/// It includes an AppBar with conditional hamburger menu for mobile screens.
///
/// Requirements: 1.2, 1.3, 2.1, 2.2, 2.3, 5.3, 5.4
class ResponsiveLayoutView extends StatelessWidget {
  /// The main content to be displayed in the layout
  final Widget child;

  /// Optional app bar title
  final String? title;

  /// Optional app bar actions
  final List<Widget>? actions;

  /// Creates a ResponsiveLayoutView with the specified child content
  ///
  /// [child] The main content widget to display
  /// [title] Optional title for the app bar
  /// [actions] Optional actions for the app bar
  const ResponsiveLayoutView({
    super.key,
    required this.child,
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ResponsiveViewModel>(
      builder: (context, responsive, _) {
        // Update screen width when the widget rebuilds
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final mediaQuery = MediaQuery.of(context);
          responsive.updateScreenWidth(mediaQuery.size.width);
        });

        return Scaffold(
          appBar: _buildAppBar(context, responsive),
          drawer:
              responsive.shouldShowNavigationDrawer
                  ? const NavigationDrawerView()
                  : null,
          body: _buildBody(context, responsive),
        );
      },
    );
  }

  /// Builds the app bar with conditional hamburger menu for mobile
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ResponsiveViewModel responsive,
  ) {
    return AppBar(
      title: Text(title ?? 'Flutter Responsive Template'),
      actions: actions,
      // Hamburger menu is automatically shown by Scaffold when drawer is present
      // and screen is mobile (drawer != null)
      elevation: 1,
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
    );
  }

  /// Builds the main body with conditional navigation rail
  Widget _buildBody(BuildContext context, ResponsiveViewModel responsive) {
    return Row(
      children: [
        // Show NavigationRail for tablet and desktop screens
        if (responsive.shouldShowNavigationRail) const NavigationRailView(),

        // Main content area
        Expanded(
          child: Container(padding: const EdgeInsets.all(16.0), child: child),
        ),
      ],
    );
  }
}
