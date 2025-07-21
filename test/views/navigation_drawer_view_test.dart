import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reponsive_design/views/navigation_drawer_view.dart';
import 'package:reponsive_design/viewmodels/navigation_viewmodel.dart';
import 'package:reponsive_design/interfaces/i_navigation_service.dart';
import 'package:reponsive_design/models/navigation_item.dart';

// Mock implementation for testing
class MockNavigationService implements INavigationService {
  final List<NavigationItem> _items = [
    const NavigationItem(
      id: 'home',
      title: 'Home',
      icon: Icons.home,
      route: '/home',
    ),
    const NavigationItem(
      id: 'profile',
      title: 'Profile',
      icon: Icons.person,
      route: '/profile',
    ),
    const NavigationItem(
      id: 'settings',
      title: 'Settings',
      icon: Icons.settings,
      route: '/settings',
    ),
    const NavigationItem(
      id: 'about',
      title: 'About',
      icon: Icons.info,
      route: '/about',
    ),
  ];

  NavigationItem? lastNavigatedItem;

  @override
  List<NavigationItem> getNavigationItems() => _items;

  @override
  void navigateToItem(NavigationItem item) {
    lastNavigatedItem = item;
  }
}

void main() {
  group('NavigationDrawerView Widget Tests', () {
    late MockNavigationService mockNavigationService;
    late NavigationViewModel navigationViewModel;

    setUp(() {
      mockNavigationService = MockNavigationService();
      navigationViewModel = NavigationViewModel(mockNavigationService);
    });

    Widget createTestWidget() {
      return ChangeNotifierProvider<NavigationViewModel>.value(
        value: navigationViewModel,
        child: const MaterialApp(home: NavigationDrawerView()),
      );
    }

    testWidgets('should display drawer', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('should display drawer header with app info', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(DrawerHeader), findsOneWidget);
      expect(find.byIcon(Icons.flutter_dash), findsOneWidget);
      expect(find.text('Flutter Responsive'), findsOneWidget);
      expect(find.text('Template'), findsOneWidget);
    });

    testWidgets('should display all navigation items', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('should display version in footer', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('v1.0.0'), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('should handle item selection', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap on Profile item
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      // Assert
      expect(navigationViewModel.selectedItem?.id, equals('profile'));
      expect(mockNavigationService.lastNavigatedItem?.id, equals('profile'));
    });

    testWidgets('should highlight selected item', (WidgetTester tester) async {
      // Arrange - select an item first
      navigationViewModel.selectItemByIndex(1); // Select Profile

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final profileTile = tester.widget<ListTile>(
        find.ancestor(
          of: find.text('Profile'),
          matching: find.byType(ListTile),
        ),
      );
      expect(profileTile.selected, isTrue);
    });

    testWidgets('should not highlight unselected items', (
      WidgetTester tester,
    ) async {
      // Arrange - select Profile item
      navigationViewModel.selectItemByIndex(1);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert Home is not selected
      final homeTile = tester.widget<ListTile>(
        find.ancestor(of: find.text('Home'), matching: find.byType(ListTile)),
      );
      expect(homeTile.selected, isFalse);
    });

    testWidgets('should handle no selection state', (
      WidgetTester tester,
    ) async {
      // Act (no item selected)
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert all items are unselected
      final listTiles = tester.widgetList<ListTile>(find.byType(ListTile));
      for (final tile in listTiles) {
        expect(tile.selected, isFalse);
      }
    });

    testWidgets('should use proper theme colors for selected item', (
      WidgetTester tester,
    ) async {
      // Arrange - select an item
      navigationViewModel.selectItemByIndex(0);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final selectedTile = tester.widget<ListTile>(
        find.ancestor(of: find.text('Home'), matching: find.byType(ListTile)),
      );
      expect(selectedTile.selected, isTrue);
      expect(selectedTile.selectedTileColor, isNotNull);
    });

    testWidgets('should handle multiple item selections', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Select Home
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(navigationViewModel.selectedItem?.id, equals('home'));

      // Test that we can select different items programmatically
      navigationViewModel.selectItemById('settings');
      expect(navigationViewModel.selectedItem?.id, equals('settings'));
    });

    testWidgets('should display correct number of navigation items', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final listTiles = tester.widgetList<ListTile>(find.byType(ListTile));
      expect(listTiles.length, equals(4)); // Home, Profile, Settings, About
    });

    testWidgets('should use ListView.builder for navigation items', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should have proper drawer structure', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert structure
      expect(
        find.byType(Column),
        findsWidgets,
      ); // Multiple columns are expected
      expect(find.byType(DrawerHeader), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
      expect(find.byType(Padding), findsWidgets); // Multiple padding widgets
    });
  });
}
