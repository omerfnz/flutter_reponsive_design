import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reponsive_design/views/navigation_rail_view.dart';
import 'package:reponsive_design/viewmodels/responsive_viewmodel.dart';
import 'package:reponsive_design/viewmodels/navigation_viewmodel.dart';
import 'package:reponsive_design/interfaces/i_responsive_service.dart';
import 'package:reponsive_design/interfaces/i_navigation_service.dart';
import 'package:reponsive_design/models/navigation_item.dart';

// Mock implementations for testing
class MockResponsiveService implements IResponsiveService {
  bool _isMobile = false;
  bool _isTablet = false;
  bool _isDesktop = true;

  void setMobile() {
    _isMobile = true;
    _isTablet = false;
    _isDesktop = false;
  }

  void setTablet() {
    _isMobile = false;
    _isTablet = true;
    _isDesktop = false;
  }

  void setDesktop() {
    _isMobile = false;
    _isTablet = false;
    _isDesktop = true;
  }

  @override
  bool isMobile(double width) => _isMobile;

  @override
  bool isTablet(double width) => _isTablet;

  @override
  bool isDesktop(double width) => _isDesktop;

  @override
  int getGridColumns(double width) {
    if (_isMobile) return 2;
    if (_isTablet) return 4;
    return 6;
  }
}

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
  group('NavigationRailView Widget Tests', () {
    late MockResponsiveService mockResponsiveService;
    late MockNavigationService mockNavigationService;
    late ResponsiveViewModel responsiveViewModel;
    late NavigationViewModel navigationViewModel;

    setUp(() {
      mockResponsiveService = MockResponsiveService();
      mockNavigationService = MockNavigationService();
      responsiveViewModel = ResponsiveViewModel(mockResponsiveService);
      navigationViewModel = NavigationViewModel(mockNavigationService);
    });

    Widget createTestWidget({bool? isExtended}) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<ResponsiveViewModel>.value(
            value: responsiveViewModel,
          ),
          ChangeNotifierProvider<NavigationViewModel>.value(
            value: navigationViewModel,
          ),
        ],
        child: MaterialApp(
          home: Scaffold(body: NavigationRailView(isExtended: isExtended)),
        ),
      );
    }

    testWidgets('should display navigation rail', (WidgetTester tester) async {
      // Arrange
      mockResponsiveService.setDesktop();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(NavigationRail), findsOneWidget);
    });

    testWidgets('should display all navigation items', (
      WidgetTester tester,
    ) async {
      // Arrange
      mockResponsiveService.setDesktop();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('should be extended on desktop by default', (
      WidgetTester tester,
    ) async {
      // Arrange
      mockResponsiveService.setDesktop();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final navigationRail = tester.widget<NavigationRail>(
        find.byType(NavigationRail),
      );
      expect(navigationRail.extended, isTrue);
    });

    testWidgets('should not be extended on tablet', (
      WidgetTester tester,
    ) async {
      // Arrange
      mockResponsiveService.setTablet();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final navigationRail = tester.widget<NavigationRail>(
        find.byType(NavigationRail),
      );
      expect(navigationRail.extended, isFalse);
    });

    testWidgets('should show toggle button on desktop', (
      WidgetTester tester,
    ) async {
      // Arrange
      mockResponsiveService.setDesktop();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.menu_open), findsOneWidget);
    });

    testWidgets('should not show toggle button on tablet', (
      WidgetTester tester,
    ) async {
      // Arrange
      mockResponsiveService.setTablet();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('should toggle extended state when toggle button is pressed', (
      WidgetTester tester,
    ) async {
      // Arrange
      mockResponsiveService.setDesktop();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify initial state
      NavigationRail navigationRail = tester.widget<NavigationRail>(
        find.byType(NavigationRail),
      );
      expect(navigationRail.extended, isTrue);
      expect(find.byIcon(Icons.menu_open), findsOneWidget);

      // Tap toggle button
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Assert state changed
      navigationRail = tester.widget<NavigationRail>(
        find.byType(NavigationRail),
      );
      expect(navigationRail.extended, isFalse);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('should handle item selection', (WidgetTester tester) async {
      // Arrange
      mockResponsiveService.setDesktop();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap on the second item (Profile)
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();

      // Assert
      expect(navigationViewModel.selectedIndex, equals(1));
      expect(navigationViewModel.selectedItem?.id, equals('profile'));
      expect(mockNavigationService.lastNavigatedItem?.id, equals('profile'));
    });

    testWidgets('should highlight selected item', (WidgetTester tester) async {
      // Arrange
      mockResponsiveService.setDesktop();
      navigationViewModel.selectItemByIndex(0); // Select first item

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final navigationRail = tester.widget<NavigationRail>(
        find.byType(NavigationRail),
      );
      expect(navigationRail.selectedIndex, equals(0));
    });

    testWidgets('should handle no selection state', (
      WidgetTester tester,
    ) async {
      // Arrange
      mockResponsiveService.setDesktop();
      // Don't select any item

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final navigationRail = tester.widget<NavigationRail>(
        find.byType(NavigationRail),
      );
      expect(navigationRail.selectedIndex, isNull);
    });

    testWidgets('should respect custom isExtended parameter', (
      WidgetTester tester,
    ) async {
      // Arrange
      mockResponsiveService.setDesktop();

      // Act
      await tester.pumpWidget(createTestWidget(isExtended: false));
      await tester.pumpAndSettle();

      // Assert
      final navigationRail = tester.widget<NavigationRail>(
        find.byType(NavigationRail),
      );
      expect(navigationRail.extended, isFalse);
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('should use proper theme colors', (WidgetTester tester) async {
      // Arrange
      mockResponsiveService.setDesktop();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final navigationRail = tester.widget<NavigationRail>(
        find.byType(NavigationRail),
      );
      expect(navigationRail.backgroundColor, isNotNull);
      expect(navigationRail.indicatorColor, isNotNull);
      expect(navigationRail.selectedIconTheme, isNotNull);
      expect(navigationRail.selectedLabelTextStyle, isNotNull);
      expect(navigationRail.unselectedIconTheme, isNotNull);
      expect(navigationRail.unselectedLabelTextStyle, isNotNull);
    });

    testWidgets('should handle multiple selection changes', (
      WidgetTester tester,
    ) async {
      // Arrange
      mockResponsiveService.setDesktop();

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Select first item
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();
      expect(navigationViewModel.selectedIndex, equals(0));

      // Select second item
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();
      expect(navigationViewModel.selectedIndex, equals(1));

      // Select third item
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      expect(navigationViewModel.selectedIndex, equals(2));
    });
  });
}
