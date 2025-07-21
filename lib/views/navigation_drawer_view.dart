import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/navigation_viewmodel.dart';

/// Navigation drawer component for mobile screens
///
/// This widget provides a navigation drawer that opens from the side
/// with navigation items matching the NavigationRail items. It integrates
/// with NavigationViewModel for state management and proper drawer handling.
///
/// Requirements: 1.3, 4.4, 4.1, 4.2, 5.3
class NavigationDrawerView extends StatelessWidget {
  /// Creates a NavigationDrawerView
  const NavigationDrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationViewModel>(
      builder: (context, navigation, _) {
        final items = navigation.navigationItems;
        final selectedItem = navigation.selectedItem;

        return Drawer(
          child: Column(
            children: [
              // Drawer header
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.flutter_dash,
                      size: 48,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Flutter Responsive',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      'Template',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),

              // Navigation items
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = selectedItem == item;

                    return Semantics(
                      label: '${item.title} menü öğesi',
                      selected: isSelected,
                      child: ListTile(
                        leading: Icon(
                          item.icon,
                          color:
                              isSelected
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.onSecondaryContainer
                                  : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            color:
                                isSelected
                                    ? Theme.of(
                                      context,
                                    ).colorScheme.onSecondaryContainer
                                    : Theme.of(context).colorScheme.onSurface,
                            fontWeight:
                                isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        selectedTileColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        onTap: () {
                          navigation.selectItem(item);
                          // Close the drawer after selection
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                ),
              ),

              // Footer
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'v1.0.0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
