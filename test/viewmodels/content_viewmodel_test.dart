import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:reponsive_design/interfaces/i_content_service.dart';
import 'package:reponsive_design/viewmodels/content_viewmodel.dart';

import 'content_viewmodel_test.mocks.dart';

@GenerateMocks([IContentService])
void main() {
  group('ContentViewModel Tests', () {
    late ContentViewModel viewModel;
    late MockIContentService mockContentService;
    late Widget testHomeWidget;
    late Widget testProfileWidget;
    late Widget testSettingsWidget;
    late Widget testErrorWidget;

    setUp(() {
      mockContentService = MockIContentService();

      // Create test widgets
      testHomeWidget = const Text('Home Content');
      testProfileWidget = const Text('Profile Content');
      testSettingsWidget = const Text('Settings Content');
      testErrorWidget = const Text('Error Content');

      // Setup mock responses
      when(
        mockContentService.getContentForRoute('/home'),
      ).thenReturn(testHomeWidget);
      when(
        mockContentService.getContentForRoute('/profile'),
      ).thenReturn(testProfileWidget);
      when(
        mockContentService.getContentForRoute('/settings'),
      ).thenReturn(testSettingsWidget);
      when(
        mockContentService.getContentForRoute('/about'),
      ).thenReturn(const Text('About Content'));
      when(
        mockContentService.getContentForRoute('/invalid'),
      ).thenReturn(testErrorWidget);

      viewModel = ContentViewModel(mockContentService);
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('Initialization', () {
      test('should initialize with home route', () {
        expect(viewModel.currentRoute, equals('/home'));
        expect(viewModel.isCurrentRoute('/home'), isTrue);
        expect(viewModel.isCurrentRoute('/profile'), isFalse);
      });

      test('should return home content initially', () {
        final content = viewModel.currentContent;
        expect(content, equals(testHomeWidget));
        verify(mockContentService.getContentForRoute('/home')).called(1);
      });
    });

    group('Route Updates', () {
      test('should update route and notify listeners', () {
        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        viewModel.updateRoute('/profile');

        expect(viewModel.currentRoute, equals('/profile'));
        expect(listenerCalled, isTrue);
        expect(viewModel.isCurrentRoute('/profile'), isTrue);
        expect(viewModel.isCurrentRoute('/home'), isFalse);
      });

      test('should not notify listeners when setting same route', () {
        viewModel.updateRoute('/profile');

        int listenerCallCount = 0;
        viewModel.addListener(() {
          listenerCallCount++;
        });

        // Update to the same route
        viewModel.updateRoute('/profile');

        expect(listenerCallCount, equals(0));
        expect(viewModel.currentRoute, equals('/profile'));
      });

      test('should return correct content after route update', () {
        viewModel.updateRoute('/profile');

        final content = viewModel.currentContent;
        expect(content, equals(testProfileWidget));
        verify(mockContentService.getContentForRoute('/profile')).called(1);
      });
    });

    group('Content Retrieval', () {
      test(
        'should get content for specific route without changing current route',
        () {
          expect(viewModel.currentRoute, equals('/home'));

          final profileContent = viewModel.getContentForRoute('/profile');

          expect(profileContent, equals(testProfileWidget));
          expect(viewModel.currentRoute, equals('/home')); // Should not change
          verify(mockContentService.getContentForRoute('/profile')).called(1);
        },
      );

      test('should delegate content retrieval to service', () {
        viewModel.getContentForRoute('/settings');

        verify(mockContentService.getContentForRoute('/settings')).called(1);
      });
    });

    group('Route Validation', () {
      test('should validate correct routes', () {
        expect(viewModel.isValidRoute('/home'), isTrue);
        expect(viewModel.isValidRoute('/profile'), isTrue);
        expect(viewModel.isValidRoute('/settings'), isTrue);
        expect(viewModel.isValidRoute('/about'), isTrue);
      });

      test('should invalidate incorrect routes', () {
        expect(viewModel.isValidRoute(''), isFalse);
        expect(
          viewModel.isValidRoute('home'),
          isFalse,
        ); // Missing leading slash
        expect(viewModel.isValidRoute('/invalid'), isFalse);
        expect(viewModel.isValidRoute('/nonexistent'), isFalse);
      });

      test('should return available routes', () {
        final routes = viewModel.availableRoutes;
        expect(routes, contains('/home'));
        expect(routes, contains('/profile'));
        expect(routes, contains('/settings'));
        expect(routes, contains('/about'));
        expect(routes.length, equals(4));
      });
    });

    group('Route Update with Validation', () {
      test('should update route when valid', () {
        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        final result = viewModel.updateRouteWithValidation('/profile');

        expect(result, isTrue);
        expect(viewModel.currentRoute, equals('/profile'));
        expect(listenerCalled, isTrue);
      });

      test('should fallback to home when invalid route', () {
        viewModel.updateRoute('/profile'); // Start with profile

        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        final result = viewModel.updateRouteWithValidation('/invalid');

        expect(result, isFalse);
        expect(
          viewModel.currentRoute,
          equals('/home'),
        ); // Should fallback to home
        expect(listenerCalled, isTrue);
      });

      test(
        'should not notify listeners when already on home and invalid route provided',
        () {
          expect(viewModel.currentRoute, equals('/home'));

          int listenerCallCount = 0;
          viewModel.addListener(() {
            listenerCallCount++;
          });

          final result = viewModel.updateRouteWithValidation('/invalid');

          expect(result, isFalse);
          expect(viewModel.currentRoute, equals('/home'));
          expect(listenerCallCount, equals(0)); // No change, so no notification
        },
      );
    });

    group('Navigation Helpers', () {
      test('should navigate to home', () {
        viewModel.updateRoute('/profile');
        expect(viewModel.currentRoute, equals('/profile'));

        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        viewModel.navigateToHome();

        expect(viewModel.currentRoute, equals('/home'));
        expect(listenerCalled, isTrue);
      });

      test('should not notify when already on home', () {
        expect(viewModel.currentRoute, equals('/home'));

        int listenerCallCount = 0;
        viewModel.addListener(() {
          listenerCallCount++;
        });

        viewModel.navigateToHome();

        expect(listenerCallCount, equals(0));
      });
    });

    group('Route History', () {
      test('should maintain route history', () {
        viewModel.updateRouteWithHistory('/profile');
        expect(viewModel.currentRoute, equals('/profile'));

        viewModel.updateRouteWithHistory('/settings');
        expect(viewModel.currentRoute, equals('/settings'));

        final canGoBack = viewModel.navigateBack();
        expect(canGoBack, isTrue);
        expect(viewModel.currentRoute, equals('/profile'));
      });

      test('should handle back navigation correctly', () {
        // Navigate from home to profile
        viewModel.updateRouteWithHistory('/profile');
        expect(viewModel.currentRoute, equals('/profile'));

        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        // Navigate back to home
        final canGoBack = viewModel.navigateBack();
        expect(canGoBack, isTrue);
        expect(viewModel.currentRoute, equals('/home'));
        expect(listenerCalled, isTrue);
      });

      test('should return false when no previous route exists', () {
        expect(viewModel.currentRoute, equals('/home'));

        final canGoBack = viewModel.navigateBack();
        expect(canGoBack, isFalse);
        expect(viewModel.currentRoute, equals('/home'));
      });

      test('should not navigate back to same route', () {
        viewModel.updateRouteWithHistory('/profile');
        viewModel.updateRouteWithHistory('/profile'); // Same route

        final canGoBack = viewModel.navigateBack();
        expect(canGoBack, isTrue);
        expect(
          viewModel.currentRoute,
          equals('/home'),
        ); // Should go to original route
      });
    });

    group('Reset Functionality', () {
      test('should reset to home route and clear history', () {
        viewModel.updateRouteWithHistory('/profile');
        viewModel.updateRouteWithHistory('/settings');
        expect(viewModel.currentRoute, equals('/settings'));

        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        viewModel.reset();

        expect(viewModel.currentRoute, equals('/home'));
        expect(listenerCalled, isTrue);

        // History should be cleared
        final canGoBack = viewModel.navigateBack();
        expect(canGoBack, isFalse);
      });

      test(
        'should not notify listeners when already on home with no history',
        () {
          expect(viewModel.currentRoute, equals('/home'));

          int listenerCallCount = 0;
          viewModel.addListener(() {
            listenerCallCount++;
          });

          viewModel.reset();

          expect(listenerCallCount, equals(0));
        },
      );
    });

    group('Service Integration', () {
      test('should call content service for current content', () {
        viewModel.updateRoute('/settings');

        // Access current content to trigger service call
        viewModel.currentContent;

        verify(mockContentService.getContentForRoute('/settings')).called(1);
      });

      test('should handle service errors gracefully', () {
        when(
          mockContentService.getContentForRoute('/error'),
        ).thenThrow(Exception('Service error'));

        expect(() => viewModel.getContentForRoute('/error'), throwsException);
      });
    });

    group('Listener Management', () {
      test('should properly manage listeners', () {
        int listenerCallCount = 0;
        void listener() {
          listenerCallCount++;
        }

        viewModel.addListener(listener);
        viewModel.updateRoute('/profile');
        expect(listenerCallCount, equals(1));

        viewModel.removeListener(listener);
        viewModel.updateRoute('/settings');
        expect(listenerCallCount, equals(1)); // Should not increase
      });
    });

    group('Edge Cases', () {
      test('should handle multiple rapid route changes', () {
        int listenerCallCount = 0;
        viewModel.addListener(() {
          listenerCallCount++;
        });

        viewModel.updateRoute('/profile');
        viewModel.updateRoute('/settings');
        viewModel.updateRoute('/about');
        viewModel.updateRoute('/home');

        expect(listenerCallCount, equals(4));
        expect(viewModel.currentRoute, equals('/home'));
      });

      test('should handle route update with history for same route', () {
        viewModel.updateRouteWithHistory('/profile');
        expect(viewModel.currentRoute, equals('/profile'));

        int listenerCallCount = 0;
        viewModel.addListener(() {
          listenerCallCount++;
        });

        // Update to same route with history
        viewModel.updateRouteWithHistory('/profile');

        expect(listenerCallCount, equals(0));
        expect(viewModel.currentRoute, equals('/profile'));
      });
    });
  });
}
