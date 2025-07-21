import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reponsive_design/views/grid_content_view.dart';

void main() {
  group('GridContentView Widget Tests', () {
    Widget createTestWidget({
      int columns = 4,
      double maxCrossAxisExtent = 200.0,
      String currentRoute = '/home',
      double childAspectRatio = 1.0,
      double spacing = 8.0,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: GridContentView(
            columns: columns,
            maxCrossAxisExtent: maxCrossAxisExtent,
            currentRoute: currentRoute,
            childAspectRatio: childAspectRatio,
            spacing: spacing,
          ),
        ),
      );
    }

    testWidgets('should display grid view', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('should use SliverGridDelegateWithMaxCrossAxisExtent', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      final gridView = tester.widget<GridView>(find.byType(GridView));
      expect(
        gridView.gridDelegate,
        isA<SliverGridDelegateWithMaxCrossAxisExtent>(),
      );
    });

    testWidgets('should display correct number of items for home route', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(currentRoute: '/home'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsNWidgets(12)); // Home route shows 12 items
    });

    testWidgets('should display correct number of items for profile route', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(currentRoute: '/profile'));
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.byType(Card),
        findsNWidgets(6),
      ); // Profile route shows 6 items
    });

    testWidgets('should display correct number of items for settings route', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(currentRoute: '/settings'));
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.byType(Card),
        findsNWidgets(8),
      ); // Settings route shows 8 items
    });

    testWidgets('should display correct number of items for about route', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(currentRoute: '/about'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsNWidgets(4)); // About route shows 4 items
    });

    testWidgets('should display default number of items for unknown route', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(currentRoute: '/unknown'));
      await tester.pumpAndSettle();

      // Assert
      expect(
        find.byType(Card),
        findsNWidgets(9),
      ); // Unknown route shows 9 items
    });

    testWidgets('should display home-specific content for home route', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(currentRoute: '/home'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Dashboard 1'), findsOneWidget);
      expect(find.text('Analytics 2'), findsOneWidget);
      expect(find.text('Reports 3'), findsOneWidget);
      expect(find.text('Tasks 4'), findsOneWidget);
    });

    testWidgets('should display profile-specific content for profile route', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(currentRoute: '/profile'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Personal Info 1'), findsOneWidget);
      expect(find.text('Security 2'), findsOneWidget);
      expect(find.text('Preferences 3'), findsOneWidget);
    });

    testWidgets('should display settings-specific content for settings route', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(currentRoute: '/settings'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('General 1'), findsOneWidget);
      expect(find.text('Notifications 2'), findsOneWidget);
      expect(find.text('Theme 3'), findsOneWidget);
      expect(find.text('Storage 4'), findsOneWidget);
    });

    testWidgets('should display about-specific content for about route', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(currentRoute: '/about'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Version 1'), findsOneWidget);
      expect(find.text('Support 2'), findsOneWidget);
      expect(find.text('Feedback 3'), findsOneWidget);
    });

    testWidgets('should display appropriate icons for home route', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(currentRoute: '/home'));
      await tester.pumpAndSettle();

      // Assert - Since items cycle, we expect multiple instances of each icon
      expect(find.byIcon(Icons.dashboard), findsWidgets);
      expect(find.byIcon(Icons.analytics), findsWidgets);
      expect(find.byIcon(Icons.assessment), findsWidgets);
      expect(find.byIcon(Icons.task), findsWidgets);
    });

    testWidgets('should display appropriate icons for profile route', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(currentRoute: '/profile'));
      await tester.pumpAndSettle();

      // Assert - Since items cycle, we expect multiple instances of each icon
      expect(find.byIcon(Icons.person), findsWidgets);
      expect(find.byIcon(Icons.security), findsWidgets);
      expect(find.byIcon(Icons.tune), findsWidgets);
    });

    testWidgets('should handle item tap and show snackbar', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(currentRoute: '/home'));
      await tester.pumpAndSettle();

      // Tap on first item
      await tester.tap(find.text('Dashboard 1'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Tapped on Dashboard 1'), findsOneWidget);
    });

    testWidgets('should use custom child aspect ratio', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(childAspectRatio: 1.5));
      await tester.pumpAndSettle();

      // Assert
      final gridView = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          gridView.gridDelegate as SliverGridDelegateWithMaxCrossAxisExtent;
      expect(delegate.childAspectRatio, equals(1.5));
    });

    testWidgets('should use custom spacing', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget(spacing: 16.0));
      await tester.pumpAndSettle();

      // Assert
      final gridView = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          gridView.gridDelegate as SliverGridDelegateWithMaxCrossAxisExtent;
      expect(delegate.crossAxisSpacing, equals(16.0));
      expect(delegate.mainAxisSpacing, equals(16.0));
    });

    testWidgets('should use custom max cross axis extent', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(maxCrossAxisExtent: 300.0));
      await tester.pumpAndSettle();

      // Assert
      final gridView = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          gridView.gridDelegate as SliverGridDelegateWithMaxCrossAxisExtent;
      expect(delegate.maxCrossAxisExtent, equals(300.0));
    });

    testWidgets('should display subtitles for items', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(currentRoute: '/home'));
      await tester.pumpAndSettle();

      // Assert - Since items cycle, we expect multiple instances of each subtitle
      expect(find.text('Overview'), findsWidgets);
      expect(find.text('Data insights'), findsWidgets);
      expect(find.text('Generate reports'), findsWidgets);
      expect(find.text('Manage tasks'), findsWidgets);
    });

    testWidgets('should have proper card structure', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(currentRoute: '/home'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Card), findsWidgets);
      expect(find.byType(InkWell), findsWidgets);
      expect(find.byType(Container), findsWidgets); // Icon containers
      expect(find.byType(Column), findsWidgets); // Item content columns
    });

    testWidgets('should handle multiple taps on different items', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget(currentRoute: '/home'));
      await tester.pumpAndSettle();

      // Tap on first item
      await tester.tap(find.text('Dashboard 1'));
      await tester.pumpAndSettle();
      expect(find.text('Tapped on Dashboard 1'), findsOneWidget);

      // Wait for snackbar to disappear
      await tester.pump(const Duration(seconds: 3));

      // Tap on second item
      await tester.tap(find.text('Analytics 2'));
      await tester.pumpAndSettle();
      expect(find.text('Tapped on Analytics 2'), findsOneWidget);
    });

    testWidgets('should cycle through base items for large item counts', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        createTestWidget(currentRoute: '/home'),
      ); // 12 items, 4 base items
      await tester.pumpAndSettle();

      // Assert that items cycle through base items
      expect(find.text('Dashboard 1'), findsOneWidget);
      expect(find.text('Analytics 2'), findsOneWidget);
      expect(find.text('Reports 3'), findsOneWidget);
      expect(find.text('Tasks 4'), findsOneWidget);
      expect(
        find.text('Dashboard 5'),
        findsOneWidget,
      ); // Cycles back to first base item
      expect(find.text('Analytics 6'), findsOneWidget);
    });

    group('Responsive Grid Tests', () {
      testWidgets('should support mobile grid configuration (2 columns)', (
        WidgetTester tester,
      ) async {
        // Act - Simulate mobile screen with 2 columns
        await tester.pumpWidget(
          createTestWidget(
            columns: 2,
            maxCrossAxisExtent: 300.0, // Mobile-like extent
            currentRoute: '/home',
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate =
            gridView.gridDelegate as SliverGridDelegateWithMaxCrossAxisExtent;
        expect(delegate.maxCrossAxisExtent, equals(300.0));
        expect(find.byType(Card), findsWidgets); // Verify cards are present
      });

      testWidgets('should support tablet grid configuration (4 columns)', (
        WidgetTester tester,
      ) async {
        // Act - Simulate tablet screen with 4 columns
        await tester.pumpWidget(
          createTestWidget(
            columns: 4,
            maxCrossAxisExtent: 200.0, // Tablet-like extent
            currentRoute: '/home',
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate =
            gridView.gridDelegate as SliverGridDelegateWithMaxCrossAxisExtent;
        expect(delegate.maxCrossAxisExtent, equals(200.0));
        expect(find.byType(Card), findsWidgets); // Verify cards are present
      });

      testWidgets('should support desktop grid configuration (6 columns)', (
        WidgetTester tester,
      ) async {
        // Act - Simulate desktop screen with 6 columns
        await tester.pumpWidget(
          createTestWidget(
            columns: 6,
            maxCrossAxisExtent: 150.0, // Desktop-like extent
            currentRoute: '/home',
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate =
            gridView.gridDelegate as SliverGridDelegateWithMaxCrossAxisExtent;
        expect(delegate.maxCrossAxisExtent, equals(150.0));
        expect(find.byType(Card), findsWidgets); // Verify cards are present
      });

      testWidgets('should maintain proper aspect ratio across configurations', (
        WidgetTester tester,
      ) async {
        // Test different aspect ratios
        const testRatios = [0.8, 1.0, 1.2, 1.5];

        for (final ratio in testRatios) {
          // Act
          await tester.pumpWidget(
            createTestWidget(childAspectRatio: ratio, currentRoute: '/home'),
          );
          await tester.pumpAndSettle();

          // Assert
          final gridView = tester.widget<GridView>(find.byType(GridView));
          final delegate =
              gridView.gridDelegate as SliverGridDelegateWithMaxCrossAxisExtent;
          expect(delegate.childAspectRatio, equals(ratio));
        }
      });

      testWidgets('should handle different spacing configurations', (
        WidgetTester tester,
      ) async {
        // Test different spacing values
        const testSpacings = [4.0, 8.0, 12.0, 16.0];

        for (final spacing in testSpacings) {
          // Act
          await tester.pumpWidget(
            createTestWidget(spacing: spacing, currentRoute: '/home'),
          );
          await tester.pumpAndSettle();

          // Assert
          final gridView = tester.widget<GridView>(find.byType(GridView));
          final delegate =
              gridView.gridDelegate as SliverGridDelegateWithMaxCrossAxisExtent;
          expect(delegate.crossAxisSpacing, equals(spacing));
          expect(delegate.mainAxisSpacing, equals(spacing));
        }
      });
    });
  });
}
