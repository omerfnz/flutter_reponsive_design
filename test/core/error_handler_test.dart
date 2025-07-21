import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reponsive_design/core/error_handler.dart';

void main() {
  group('ErrorHandler', () {
    group('Error Handling Methods', () {
      test('handleResponsiveError should log error without screen width', () {
        // This test verifies that responsive errors are handled properly
        // In a real app, we would mock the logging service
        expect(
          () => ErrorHandler.handleResponsiveError('Test responsive error'),
          returnsNormally,
        );
      });

      test('handleResponsiveError should log error with screen width', () {
        expect(
          () => ErrorHandler.handleResponsiveError(
            'Test responsive error',
            800.0,
          ),
          returnsNormally,
        );
      });

      test('handleNavigationError should log error without callback', () {
        expect(
          () => ErrorHandler.handleNavigationError(
            '/test-route',
            'Test navigation error',
          ),
          returnsNormally,
        );
      });

      test('handleNavigationError should execute callback when provided', () {
        bool callbackExecuted = false;
        void testCallback() {
          callbackExecuted = true;
        }

        ErrorHandler.handleNavigationError(
          '/test-route',
          'Test navigation error',
          testCallback,
        );

        expect(callbackExecuted, isTrue);
      });

      test('handleNavigationError should handle callback exceptions', () {
        void throwingCallback() {
          throw Exception('Callback error');
        }

        expect(
          () => ErrorHandler.handleNavigationError(
            '/test-route',
            'Test navigation error',
            throwingCallback,
          ),
          returnsNormally,
        );
      });

      test('handleContentError should log error', () {
        expect(
          () => ErrorHandler.handleContentError(
            '/test-route',
            'Test content error',
          ),
          returnsNormally,
        );
      });

      test('handleServiceError should log error', () {
        expect(
          () => ErrorHandler.handleServiceError(
            'TestService',
            'Test service error',
          ),
          returnsNormally,
        );
      });

      test('handleViewModelError should log error without callback', () {
        expect(
          () => ErrorHandler.handleViewModelError(
            'TestViewModel',
            'Test viewmodel error',
          ),
          returnsNormally,
        );
      });

      test('handleViewModelError should execute callback when provided', () {
        bool callbackExecuted = false;
        void testCallback() {
          callbackExecuted = true;
        }

        ErrorHandler.handleViewModelError(
          'TestViewModel',
          'Test viewmodel error',
          testCallback,
        );

        expect(callbackExecuted, isTrue);
      });

      test('handleViewModelError should handle callback exceptions', () {
        void throwingCallback() {
          throw Exception('Reset error');
        }

        expect(
          () => ErrorHandler.handleViewModelError(
            'TestViewModel',
            'Test viewmodel error',
            throwingCallback,
          ),
          returnsNormally,
        );
      });

      test('handleGeneralError should log error without context', () {
        expect(
          () => ErrorHandler.handleGeneralError('Test general error'),
          returnsNormally,
        );
      });

      test('handleGeneralError should log error with context', () {
        expect(
          () => ErrorHandler.handleGeneralError('Test general error', {
            'key': 'value',
            'number': 42,
          }),
          returnsNormally,
        );
      });
    });

    group('Error Widget Builders', () {
      testWidgets('buildErrorWidget should create basic error widget', (
        tester,
      ) async {
        final widget = ErrorHandler.buildErrorWidget('Test error message');

        await tester.pumpWidget(MaterialApp(home: widget));

        expect(find.text('Oops! Something went wrong'), findsOneWidget);
        expect(find.text('Test error message'), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(find.text('Retry'), findsNothing);
      });

      testWidgets(
        'buildErrorWidget should create error widget with retry button',
        (tester) async {
          bool retryPressed = false;
          void onRetry() {
            retryPressed = true;
          }

          final widget = ErrorHandler.buildErrorWidget(
            'Test error message',
            onRetry: onRetry,
          );

          await tester.pumpWidget(MaterialApp(home: widget));

          expect(find.text('Retry'), findsOneWidget);

          await tester.tap(find.text('Retry'));
          await tester.pump();

          expect(retryPressed, isTrue);
        },
      );

      testWidgets('buildErrorWidget should show custom icon', (tester) async {
        final widget = ErrorHandler.buildErrorWidget(
          'Test error message',
          icon: Icons.warning,
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        expect(find.byIcon(Icons.warning), findsOneWidget);
        expect(find.byIcon(Icons.error_outline), findsNothing);
      });

      testWidgets('buildErrorWidget should show details when enabled', (
        tester,
      ) async {
        final widget = ErrorHandler.buildErrorWidget(
          'Test error message',
          showDetails: true,
          details: 'Detailed error information',
        );

        await tester.pumpWidget(MaterialApp(home: widget));

        expect(find.text('Detailed error information'), findsOneWidget);
      });

      testWidgets(
        'buildContentErrorWidget should create content error widget',
        (tester) async {
          final widget = ErrorHandler.buildContentErrorWidget('/test-route');

          await tester.pumpWidget(MaterialApp(home: widget));

          expect(find.text('Content Not Available'), findsOneWidget);
          expect(
            find.text('Unable to load content for "/test-route"'),
            findsOneWidget,
          );
          expect(find.byIcon(Icons.warning_amber_outlined), findsOneWidget);
        },
      );

      testWidgets(
        'buildContentErrorWidget should show retry and home buttons',
        (tester) async {
          bool retryPressed = false;
          bool homePressed = false;

          void onRetry() {
            retryPressed = true;
          }

          void onGoHome() {
            homePressed = true;
          }

          final widget = ErrorHandler.buildContentErrorWidget(
            '/test-route',
            onRetry: onRetry,
            onGoHome: onGoHome,
          );

          await tester.pumpWidget(MaterialApp(home: widget));

          expect(find.text('Retry'), findsOneWidget);
          expect(find.text('Go Home'), findsOneWidget);

          await tester.tap(find.text('Retry'));
          await tester.pump();
          expect(retryPressed, isTrue);

          await tester.tap(find.text('Go Home'));
          await tester.pump();
          expect(homePressed, isTrue);
        },
      );

      testWidgets(
        'buildNetworkErrorWidget should create network error widget',
        (tester) async {
          final widget = ErrorHandler.buildNetworkErrorWidget();

          await tester.pumpWidget(MaterialApp(home: widget));

          expect(find.text('No Internet Connection'), findsOneWidget);
          expect(
            find.text('Please check your internet connection and try again.'),
            findsOneWidget,
          );
          expect(find.byIcon(Icons.wifi_off), findsOneWidget);
          expect(find.text('Retry'), findsNothing);
        },
      );

      testWidgets(
        'buildNetworkErrorWidget should show retry button when callback provided',
        (tester) async {
          bool retryPressed = false;
          void onRetry() {
            retryPressed = true;
          }

          final widget = ErrorHandler.buildNetworkErrorWidget(onRetry: onRetry);

          await tester.pumpWidget(MaterialApp(home: widget));

          expect(find.text('Retry'), findsOneWidget);

          await tester.tap(find.text('Retry'));
          await tester.pump();
          expect(retryPressed, isTrue);
        },
      );

      testWidgets(
        'buildResponsiveFallbackWidget should create responsive fallback widget',
        (tester) async {
          final widget = ErrorHandler.buildResponsiveFallbackWidget(800.0);

          await tester.pumpWidget(MaterialApp(home: widget));

          expect(find.text('Layout Adjustment'), findsOneWidget);
          expect(
            find.text('Optimizing layout for screen width: 800px'),
            findsOneWidget,
          );
          expect(find.byIcon(Icons.devices), findsOneWidget);
        },
      );
    });

    group('Utility Methods', () {
      test('getErrorStatistics should return default statistics', () {
        final stats = ErrorHandler.getErrorStatistics();

        expect(stats, isA<Map<String, dynamic>>());
        expect(stats['totalErrors'], equals(0));
        expect(stats['errorTypes'], isA<Map<String, int>>());
        expect(stats['lastError'], isNull);
        expect(stats['errorRate'], equals(0.0));
      });

      test('isErrorReportingEnabled should return true by default', () {
        expect(ErrorHandler.isErrorReportingEnabled, isTrue);
      });

      test('setupGlobalErrorHandling should execute without errors', () {
        expect(() => ErrorHandler.setupGlobalErrorHandling(), returnsNormally);
      });
    });

    group('Edge Cases', () {
      test('should handle null or empty error messages gracefully', () {
        expect(() => ErrorHandler.handleGeneralError(''), returnsNormally);
      });

      test('should handle null context in general error', () {
        expect(
          () => ErrorHandler.handleGeneralError('Test error', null),
          returnsNormally,
        );
      });

      test('should handle empty route in navigation error', () {
        expect(
          () => ErrorHandler.handleNavigationError('', 'Test error'),
          returnsNormally,
        );
      });

      test('should handle empty route in content error', () {
        expect(
          () => ErrorHandler.handleContentError('', 'Test error'),
          returnsNormally,
        );
      });

      test('should handle negative screen width in responsive error', () {
        expect(
          () => ErrorHandler.handleResponsiveError('Test error', -100.0),
          returnsNormally,
        );
      });

      test('should handle zero screen width in responsive fallback widget', () {
        expect(
          () => ErrorHandler.buildResponsiveFallbackWidget(0.0),
          returnsNormally,
        );
      });
    });

    group('Widget Integration', () {
      testWidgets('error widgets should be accessible', (tester) async {
        final widget = ErrorHandler.buildErrorWidget('Test error');

        await tester.pumpWidget(MaterialApp(home: widget));

        // Check that the widget tree is properly constructed
        expect(find.byType(Center), findsAtLeastNWidgets(1));
        expect(find.byType(Padding), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);
        expect(find.byType(Text), findsAtLeastNWidgets(2));
      });

      testWidgets('content error widget should handle long route names', (
        tester,
      ) async {
        const longRoute =
            '/very/long/route/name/that/might/cause/layout/issues';
        final widget = ErrorHandler.buildContentErrorWidget(longRoute);

        await tester.pumpWidget(MaterialApp(home: widget));

        expect(find.textContaining(longRoute), findsOneWidget);
      });

      testWidgets(
        'error widgets should be responsive to different screen sizes',
        (tester) async {
          final widget = ErrorHandler.buildErrorWidget('Test error');

          // Test with different screen sizes
          await tester.binding.setSurfaceSize(const Size(400, 600)); // Mobile
          await tester.pumpWidget(MaterialApp(home: widget));
          expect(find.text('Test error'), findsOneWidget);

          await tester.binding.setSurfaceSize(const Size(800, 600)); // Tablet
          await tester.pumpWidget(MaterialApp(home: widget));
          expect(find.text('Test error'), findsOneWidget);

          await tester.binding.setSurfaceSize(const Size(1200, 800)); // Desktop
          await tester.pumpWidget(MaterialApp(home: widget));
          expect(find.text('Test error'), findsOneWidget);

          // Reset to default size
          await tester.binding.setSurfaceSize(null);
        },
      );
    });
  });
}
