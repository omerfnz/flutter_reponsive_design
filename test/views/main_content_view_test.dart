import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reponsive_design/views/main_content_view.dart';
import 'package:reponsive_design/viewmodels/responsive_viewmodel.dart';
import 'package:reponsive_design/viewmodels/content_viewmodel.dart';
import 'package:reponsive_design/interfaces/i_responsive_service.dart';
import 'package:reponsive_design/interfaces/i_content_service.dart';

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

class MockContentService implements IContentService {
  @override
  Widget getContentForRoute(String route) {
    return Text('Content for $route');
  }
}

void main() {
  group('MainContentView Widget Tests', () {
    late MockResponsiveService mockResponsiveService;
    late MockContentService mockContentService;
    late ResponsiveViewModel responsiveViewModel;
    late ContentViewModel contentViewModel;

    setUp(() {
      mockResponsiveService = MockResponsiveService();
      mockContentService = MockContentService();
      responsiveViewModel = ResponsiveViewModel(mockResponsiveService);
      contentViewModel = ContentViewModel(mockContentService);
    });

    Widget createTestWidget({EdgeInsets? padding, Color? backgroundColor}) {
      // Initialize screen width to avoid maxCrossAxisExtent being 0
      responsiveViewModel.updateScreenWidth(800);

      return MultiProvider(
        providers: [
          ChangeNotifierProvider<ResponsiveViewModel>.value(
            value: responsiveViewModel,
          ),
          ChangeNotifierProvider<ContentViewModel>.value(
            value: contentViewModel,
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: MainContentView(
              padding: padding,
              backgroundColor: backgroundColor,
            ),
          ),
        ),
      );
    }

    testWidgets('should display main content view', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(MainContentView), findsOneWidget);
    });

    testWidgets('should display content header with route info', (
      WidgetTester tester,
    ) async {
      // Arrange
      contentViewModel.updateRoute('/profile');

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Current Route: /profile'), findsOneWidget);
    });

    testWidgets('should display device type and grid columns', (
      WidgetTester tester,
    ) async {
      // Arrange
      mockResponsiveService.setDesktop();
      responsiveViewModel.updateScreenWidth(1200);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Device: desktop'), findsOneWidget);
      expect(find.textContaining('Grid Columns: 6'), findsOneWidget);
    });

    testWidgets('should show correct device type for mobile', (
      WidgetTester tester,
    ) async {
      // Arrange
      mockResponsiveService.setMobile();
      responsiveViewModel.updateScreenWidth(400);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Device: mobile'), findsOneWidget);
      expect(find.textContaining('Grid Columns: 2'), findsOneWidget);
    });

    testWidgets('should show correct device type for tablet', (
      WidgetTester tester,
    ) async {
      // Arrange
      mockResponsiveService.setTablet();
      responsiveViewModel.updateScreenWidth(800);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Device: tablet'), findsOneWidget);
      expect(find.textContaining('Grid Columns: 4'), findsOneWidget);
    });

    testWidgets('should display appropriate icon for route', (
      WidgetTester tester,
    ) async {
      // Arrange
      contentViewModel.updateRoute('/home');

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('should display profile icon for profile route', (
      WidgetTester tester,
    ) async {
      // Arrange
      contentViewModel.updateRoute('/profile');

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.person), findsAtLeastNWidgets(1));
    });

    testWidgets('should display settings icon for settings route', (
      WidgetTester tester,
    ) async {
      // Arrange
      contentViewModel.updateRoute('/settings');

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.settings), findsAtLeastNWidgets(1));
    });

    testWidgets('should display info icon for about route', (
      WidgetTester tester,
    ) async {
      // Arrange
      contentViewModel.updateRoute('/about');

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.info), findsAtLeastNWidgets(1));
    });

    testWidgets('should display default icon for unknown route', (
      WidgetTester tester,
    ) async {
      // Arrange
      contentViewModel.updateRoute('/unknown');

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byIcon(Icons.dashboard), findsOneWidget);
    });

    testWidgets('should use custom padding when provided', (
      WidgetTester tester,
    ) async {
      // Arrange
      const customPadding = EdgeInsets.all(32.0);

      // Act
      await tester.pumpWidget(createTestWidget(padding: customPadding));
      await tester.pumpAndSettle();

      // Assert
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.padding, equals(customPadding));
    });

    testWidgets('should use default padding when none provided', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.padding, equals(const EdgeInsets.all(16.0)));
    });

    testWidgets('should use custom background color when provided', (
      WidgetTester tester,
    ) async {
      // Arrange
      const customColor = Colors.red;

      // Act
      await tester.pumpWidget(createTestWidget(backgroundColor: customColor));
      await tester.pumpAndSettle();

      // Assert
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.color, equals(customColor));
    });

    testWidgets('should contain grid content view', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('should have proper layout structure', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Column), findsAtLeastNWidgets(1));
      expect(find.byType(Card), findsWidgets);
      expect(find.byType(Expanded), findsAtLeastNWidgets(1));
    });

    testWidgets('should update when responsive state changes', (
      WidgetTester tester,
    ) async {
      // Arrange
      mockResponsiveService.setMobile();
      responsiveViewModel.updateScreenWidth(400);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.textContaining('Device: mobile'), findsOneWidget);

      // Change to desktop
      mockResponsiveService.setDesktop();
      responsiveViewModel.updateScreenWidth(1200);
      await tester.pumpAndSettle();

      // Assert state changed
      expect(find.textContaining('Device: desktop'), findsOneWidget);
    });

    testWidgets('should update when content route changes', (
      WidgetTester tester,
    ) async {
      // Arrange
      contentViewModel.updateRoute('/home');

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.text('Current Route: /home'), findsOneWidget);
      expect(find.byIcon(Icons.home), findsAtLeastNWidgets(1));

      // Change route
      contentViewModel.updateRoute('/profile');
      await tester.pumpAndSettle();

      // Assert state changed
      expect(find.text('Current Route: /profile'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsAtLeastNWidgets(1));
    });
  });
}
