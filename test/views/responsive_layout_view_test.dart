import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reponsive_design/views/responsive_layout_view.dart';
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
  @override
  List<NavigationItem> getNavigationItems() {
    return [
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
    ];
  }

  @override
  void navigateToItem(NavigationItem item) {
    // Mock implementation
  }
}

void main() {
  group('ResponsiveLayoutView Widget Tests', () {
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

    Widget createTestWidget({required Widget child}) {
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
          home: ResponsiveLayoutView(title: 'Test App', child: child),
        ),
      );
    }

    testWidgets('should display app bar with title', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testChild = Text('Test Content');

      // Act
      await tester.pumpWidget(createTestWidget(child: testChild));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Test App'), findsOneWidget);
    });

    testWidgets('should display child content', (WidgetTester tester) async {
      // Arrange
      const testChild = Text('Test Content');

      // Act
      await tester.pumpWidget(createTestWidget(child: testChild));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('should show navigation rail on desktop', (
      WidgetTester tester,
    ) async {
      // Arrange
      mockResponsiveService.setDesktop();
      responsiveViewModel.updateScreenWidth(1200);
      const testChild = Text('Test Content');

      // Act
      await tester.pumpWidget(createTestWidget(child: testChild));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(Drawer), findsNothing);
    });

    testWidgets('should show navigation rail on tablet', (
      WidgetTester tester,
    ) async {
      // Arrange
      mockResponsiveService.setTablet();
      responsiveViewModel.updateScreenWidth(800);
      const testChild = Text('Test Content');

      // Act
      await tester.pumpWidget(createTestWidget(child: testChild));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(Drawer), findsNothing);
    });

    testWidgets('should show drawer on mobile', (WidgetTester tester) async {
      // Arrange
      mockResponsiveService.setMobile();
      responsiveViewModel.updateScreenWidth(400);
      const testChild = Text('Test Content');

      // Act
      await tester.pumpWidget(createTestWidget(child: testChild));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(NavigationRail), findsNothing);
      // Drawer is present in Scaffold but not visible until opened
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.drawer, isNotNull);
    });

    testWidgets('should show hamburger menu on mobile', (
      WidgetTester tester,
    ) async {
      // Arrange
      mockResponsiveService.setMobile();
      responsiveViewModel.updateScreenWidth(400);
      const testChild = Text('Test Content');

      // Act
      await tester.pumpWidget(createTestWidget(child: testChild));
      await tester.pumpAndSettle();

      // Assert
      // Hamburger menu icon should be present in AppBar when drawer is available
      expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('should not show hamburger menu on desktop', (
      WidgetTester tester,
    ) async {
      // Arrange
      mockResponsiveService.setDesktop();
      responsiveViewModel.updateScreenWidth(1200);
      const testChild = Text('Test Content');

      // Act
      await tester.pumpWidget(createTestWidget(child: testChild));
      await tester.pumpAndSettle();

      // Assert
      // No hamburger menu when drawer is not present
      expect(find.byIcon(Icons.menu), findsNothing);
    });

    testWidgets('should update screen width when widget rebuilds', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testChild = Text('Test Content');

      // Act
      await tester.pumpWidget(createTestWidget(child: testChild));
      await tester.pumpAndSettle();

      // Assert
      expect(responsiveViewModel.screenWidth, greaterThan(0));
    });

    testWidgets('should use default title when none provided', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testChild = Text('Test Content');

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ResponsiveViewModel>.value(
              value: responsiveViewModel,
            ),
            ChangeNotifierProvider<NavigationViewModel>.value(
              value: navigationViewModel,
            ),
          ],
          child: const MaterialApp(
            home: ResponsiveLayoutView(child: testChild),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Flutter Responsive Template'), findsOneWidget);
    });

    testWidgets('should display custom actions in app bar', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testChild = Text('Test Content');
      final actions = [
        IconButton(icon: const Icon(Icons.search), onPressed: () {}),
      ];

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ResponsiveViewModel>.value(
              value: responsiveViewModel,
            ),
            ChangeNotifierProvider<NavigationViewModel>.value(
              value: navigationViewModel,
            ),
          ],
          child: MaterialApp(
            home: ResponsiveLayoutView(
              title: 'Test App',
              actions: actions,
              child: testChild,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });
}
