import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../viewmodels/navigation_viewmodel.dart';
import '../viewmodels/responsive_viewmodel.dart';

/// Navigation rail component for desktop and tablet screens
///
/// This widget provides a vertical navigation rail with expandable/collapsible
/// functionality. It integrates with NavigationViewModel for state management
/// and displays navigation items with icons and labels.
///
/// Requirements: 1.2, 4.3, 4.1, 4.2, 5.3
class NavigationRailView extends StatefulWidget {
  /// Whether the navigation rail should be extended by default
  final bool? isExtended;

  /// Creates a NavigationRailView
  ///
  /// [isExtended] Optional parameter to control initial extended state
  const NavigationRailView({super.key, this.isExtended});

  @override
  State<NavigationRailView> createState() => _NavigationRailViewState();
}

class _NavigationRailViewState extends State<NavigationRailView> {
  late bool _isExtended;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _isExtended = widget.isExtended ?? true;
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<NavigationViewModel, ResponsiveViewModel>(
      builder: (context, navigation, responsive, _) {
        final items = navigation.navigationItems;
        final selectedIndex = navigation.selectedIndex;

        return Focus(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                if (selectedIndex < items.length - 1) {
                  navigation.selectItemByIndex(selectedIndex + 1);
                  return KeyEventResult.handled;
                }
              } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                if (selectedIndex > 0) {
                  navigation.selectItemByIndex(selectedIndex - 1);
                  return KeyEventResult.handled;
                }
              }
            }
            return KeyEventResult.ignored;
          },
          child: NavigationRail(
            extended: _isExtended && responsive.isDesktop,
            destinations:
                items
                    .map(
                      (item) => NavigationRailDestination(
                        icon: Semantics(
                          label: '${item.title} menü öğesi',
                          selected: navigation.selectedItem == item,
                          child: Icon(item.icon),
                        ),
                        label: Semantics(
                          label: '${item.title} menü öğesi',
                          selected: navigation.selectedItem == item,
                          child: Text(item.title),
                        ),
                      ),
                    )
                    .toList(),
            selectedIndex: selectedIndex >= 0 ? selectedIndex : null,
            onDestinationSelected: (index) {
              navigation.selectItemByIndex(index);
            },
            leading:
                responsive.isDesktop
                    ? FloatingActionButton(
                      elevation: 0,
                      onPressed: _toggleExtended,
                      child: Icon(_isExtended ? Icons.menu_open : Icons.menu),
                    )
                    : null,
            backgroundColor: Theme.of(context).colorScheme.surface,
            indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
            selectedIconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            selectedLabelTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
            unselectedIconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            unselectedLabelTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        );
      },
    );
  }

  /// Toggles the extended state of the navigation rail
  void _toggleExtended() {
    setState(() {
      _isExtended = !_isExtended;
    });
  }
}
