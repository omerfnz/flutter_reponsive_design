import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reponsive_design/services/content_service.dart';
import 'package:reponsive_design/interfaces/i_content_service.dart';
import 'package:reponsive_design/models/navigation_data.dart';

void main() {
  group('ContentService', () {
    late IContentService contentService;

    setUp(() {
      contentService = const ContentService();
    });

    group('getContentForRoute', () {
      testWidgets('should return home content for /home route', (
        WidgetTester tester,
      ) async {
        final content = contentService.getContentForRoute('/home');

        expect(content, isA<Widget>());

        await tester.pumpWidget(MaterialApp(home: content));

        expect(find.text('Welcome Home'), findsOneWidget);
        expect(find.text('This is the home page content'), findsOneWidget);
        expect(find.byIcon(Icons.home), findsOneWidget);
      });

      testWidgets('should return profile content for /profile route', (
        WidgetTester tester,
      ) async {
        final content = contentService.getContentForRoute('/profile');

        expect(content, isA<Widget>());

        await tester.pumpWidget(MaterialApp(home: content));

        expect(find.text('User Profile'), findsOneWidget);
        expect(find.text('This is the profile page content'), findsOneWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);
      });

      testWidgets('should return settings content for /settings route', (
        WidgetTester tester,
      ) async {
        final content = contentService.getContentForRoute('/settings');

        expect(content, isA<Widget>());

        await tester.pumpWidget(MaterialApp(home: content));

        expect(find.text('Settings'), findsOneWidget);
        expect(find.text('This is the settings page content'), findsOneWidget);
        expect(find.byIcon(Icons.settings), findsOneWidget);
      });

      testWidgets('should return about content for /about route', (
        WidgetTester tester,
      ) async {
        final content = contentService.getContentForRoute('/about');

        expect(content, isA<Widget>());

        await tester.pumpWidget(MaterialApp(home: content));

        expect(find.text('About'), findsOneWidget);
        expect(find.text('This is the about page content'), findsOneWidget);
        expect(find.byIcon(Icons.info), findsOneWidget);
      });

      testWidgets('should return fallback content for unknown route', (
        WidgetTester tester,
      ) async {
        final content = contentService.getContentForRoute('/unknown');

        expect(content, isA<Widget>());

        await tester.pumpWidget(MaterialApp(home: content));

        expect(find.text('Route Not Found'), findsOneWidget);
        expect(
          find.text('The route "/unknown" was not found.'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.warning), findsOneWidget);
        expect(find.text('Go to Home'), findsOneWidget);
      });

      testWidgets('should handle empty route by using default route', (
        WidgetTester tester,
      ) async {
        final content = contentService.getContentForRoute('');

        expect(content, isA<Widget>());

        await tester.pumpWidget(MaterialApp(home: content));

        // Should show home content as default
        expect(find.text('Welcome Home'), findsOneWidget);
        expect(find.byIcon(Icons.home), findsOneWidget);
      });

      testWidgets('should normalize routes without leading slash', (
        WidgetTester tester,
      ) async {
        final content = contentService.getContentForRoute('profile');

        expect(content, isA<Widget>());

        await tester.pumpWidget(MaterialApp(home: content));

        expect(find.text('User Profile'), findsOneWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);
      });

      test('should return widget for all supported routes', () {
        final supportedRoutes = NavigationData.allRoutes;

        for (final route in supportedRoutes) {
          final content = contentService.getContentForRoute(route);
          expect(content, isA<Widget>());
        }
      });
    });

    group('Additional ContentService methods', () {
      test('isRouteSupported should return true for supported routes', () {
        final service = contentService as ContentService;

        expect(service.isRouteSupported('/home'), isTrue);
        expect(service.isRouteSupported('/profile'), isTrue);
        expect(service.isRouteSupported('/settings'), isTrue);
        expect(service.isRouteSupported('/about'), isTrue);
      });

      test('isRouteSupported should return false for unsupported routes', () {
        final service = contentService as ContentService;

        expect(service.isRouteSupported('/unknown'), isFalse);
        expect(service.isRouteSupported('/nonexistent'), isFalse);
        expect(service.isRouteSupported(''), isFalse);
      });

      test('isRouteSupported should handle routes without leading slash', () {
        final service = contentService as ContentService;

        expect(service.isRouteSupported('home'), isTrue);
        expect(service.isRouteSupported('profile'), isTrue);
        expect(service.isRouteSupported('settings'), isTrue);
        expect(service.isRouteSupported('about'), isTrue);
      });

      test('getSupportedRoutes should return all navigation routes', () {
        final service = contentService as ContentService;

        final supportedRoutes = service.getSupportedRoutes();
        final navigationRoutes = NavigationData.allRoutes;

        expect(supportedRoutes, equals(navigationRoutes));
        expect(supportedRoutes, contains('/home'));
        expect(supportedRoutes, contains('/profile'));
        expect(supportedRoutes, contains('/settings'));
        expect(supportedRoutes, contains('/about'));
      });

      test('getDefaultRoute should return /home', () {
        final service = contentService as ContentService;

        expect(service.getDefaultRoute(), equals('/home'));
      });

      test('getContentTypeForRoute should return correct content types', () {
        final service = contentService as ContentService;

        expect(service.getContentTypeForRoute('/home'), equals('Home Page'));
        expect(
          service.getContentTypeForRoute('/profile'),
          equals('User Profile'),
        );
        expect(
          service.getContentTypeForRoute('/settings'),
          equals('Application Settings'),
        );
        expect(
          service.getContentTypeForRoute('/about'),
          equals('About Information'),
        );
        expect(
          service.getContentTypeForRoute('/unknown'),
          equals('Unknown Content'),
        );
        expect(service.getContentTypeForRoute(''), equals('Unknown'));
      });

      test(
        'getContentTypeForRoute should handle routes without leading slash',
        () {
          final service = contentService as ContentService;

          expect(service.getContentTypeForRoute('home'), equals('Home Page'));
          expect(
            service.getContentTypeForRoute('profile'),
            equals('User Profile'),
          );
          expect(
            service.getContentTypeForRoute('settings'),
            equals('Application Settings'),
          );
          expect(
            service.getContentTypeForRoute('about'),
            equals('About Information'),
          );
        },
      );

      test('isValidRouteFormat should validate route format correctly', () {
        final service = contentService as ContentService;

        // Valid routes
        expect(service.isValidRouteFormat('/home'), isTrue);
        expect(service.isValidRouteFormat('/profile'), isTrue);
        expect(service.isValidRouteFormat('/settings'), isTrue);
        expect(service.isValidRouteFormat('/about'), isTrue);
        expect(service.isValidRouteFormat('/user/profile'), isTrue);
        expect(service.isValidRouteFormat('/admin/settings'), isTrue);
        expect(service.isValidRouteFormat('/test_route'), isTrue);
        expect(service.isValidRouteFormat('/test-route'), isTrue);

        // Invalid routes
        expect(service.isValidRouteFormat(''), isFalse);
        expect(
          service.isValidRouteFormat('home'),
          isFalse,
        ); // Missing leading slash
        expect(
          service.isValidRouteFormat('/home/'),
          isFalse,
        ); // Trailing slash not allowed by regex
        expect(service.isValidRouteFormat('/home with spaces'), isFalse);
        expect(service.isValidRouteFormat('/home@special'), isFalse);
      });

      test('getContentSummary should return comprehensive summary', () {
        final service = contentService as ContentService;

        final summary = service.getContentSummary();

        expect(summary, isA<Map<String, dynamic>>());
        expect(summary['defaultRoute'], equals('/home'));
        expect(summary['supportedRoutes'], isA<List<String>>());
        expect(summary['totalSupportedRoutes'], equals(4));
        expect(summary['contentTypes'], isA<List>());

        final contentTypes = summary['contentTypes'] as List;
        expect(contentTypes, hasLength(4));

        // Check that all routes have corresponding content types
        for (final contentType in contentTypes) {
          expect(contentType, isA<Map<String, dynamic>>());
          expect(contentType['route'], isA<String>());
          expect(contentType['type'], isA<String>());
        }
      });
    });

    group('Error handling and edge cases', () {
      testWidgets('should handle null or invalid widget creation gracefully', (
        WidgetTester tester,
      ) async {
        // Test with various edge case routes
        final edgeCaseRoutes = [
          '//',
          '///',
          '/home/',
          '/profile/extra',
          '/settings/nested/deep',
        ];

        for (final route in edgeCaseRoutes) {
          final content = contentService.getContentForRoute(route);
          expect(content, isA<Widget>());

          // Should be able to render without throwing
          await tester.pumpWidget(MaterialApp(home: content));
          await tester.pump();
        }
      });

      test('should handle route normalization consistently', () {
        final service = contentService as ContentService;

        // Test that routes with and without leading slash are handled consistently
        final routePairs = [
          ['home', '/home'],
          ['profile', '/profile'],
          ['settings', '/settings'],
          ['about', '/about'],
        ];

        for (final pair in routePairs) {
          final withoutSlash = pair[0];
          final withSlash = pair[1];

          expect(
            service.isRouteSupported(withoutSlash),
            equals(service.isRouteSupported(withSlash)),
          );
          expect(
            service.getContentTypeForRoute(withoutSlash),
            equals(service.getContentTypeForRoute(withSlash)),
          );
        }
      });

      testWidgets('should provide consistent fallback behavior', (
        WidgetTester tester,
      ) async {
        final unknownRoutes = ['/unknown', '/nonexistent', '/invalid', '/test'];

        for (final route in unknownRoutes) {
          final content = contentService.getContentForRoute(route);

          await tester.pumpWidget(MaterialApp(home: content));

          // All unknown routes should show the same fallback structure
          expect(find.text('Route Not Found'), findsOneWidget);
          expect(find.byIcon(Icons.warning), findsOneWidget);
          expect(find.text('Go to Home'), findsOneWidget);
        }
      });
    });

    group('Integration tests', () {
      test('should maintain consistency with NavigationData', () {
        final service = contentService as ContentService;
        final navigationRoutes = NavigationData.allRoutes;
        final supportedRoutes = service.getSupportedRoutes();

        // Content service should support all navigation routes
        expect(supportedRoutes, equals(navigationRoutes));

        // All navigation routes should be supported
        for (final route in navigationRoutes) {
          expect(service.isRouteSupported(route), isTrue);
        }
      });

      testWidgets('should provide content for all navigation items', (
        WidgetTester tester,
      ) async {
        final navigationItems = NavigationData.items;

        for (final item in navigationItems) {
          final content = contentService.getContentForRoute(item.route);

          expect(content, isA<Widget>());

          // Should be able to render without errors
          await tester.pumpWidget(MaterialApp(home: content));
          await tester.pump();

          // Should not show error or fallback content for valid routes
          expect(find.text('Route Not Found'), findsNothing);
          expect(find.text('Content Error'), findsNothing);
        }
      });

      test('should handle complete content workflow', () {
        final service = contentService as ContentService;

        // Get summary
        final summary = service.getContentSummary();
        expect(summary['totalSupportedRoutes'], greaterThan(0));

        // Test all supported routes
        final supportedRoutes = service.getSupportedRoutes();
        for (final route in supportedRoutes) {
          expect(service.isRouteSupported(route), isTrue);
          expect(service.isValidRouteFormat(route), isTrue);

          final contentType = service.getContentTypeForRoute(route);
          expect(contentType, isNotEmpty);
          expect(contentType, isNot(equals('Unknown Content')));

          final content = service.getContentForRoute(route);
          expect(content, isA<Widget>());
        }

        // Test default route
        final defaultRoute = service.getDefaultRoute();
        expect(service.isRouteSupported(defaultRoute), isTrue);

        final defaultContent = service.getContentForRoute(defaultRoute);
        expect(defaultContent, isA<Widget>());
      });
    });
  });
}
