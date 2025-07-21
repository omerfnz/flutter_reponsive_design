import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:reponsive_design/core/service_locator.dart';
import 'package:reponsive_design/interfaces/i_responsive_service.dart';
import 'package:reponsive_design/interfaces/i_navigation_service.dart';
import 'package:reponsive_design/interfaces/i_content_service.dart';
import 'package:reponsive_design/services/responsive_service.dart';
import 'package:reponsive_design/services/navigation_service.dart';
import 'package:reponsive_design/services/content_service.dart';

void main() {
  group('ServiceLocator', () {
    setUp(() {
      // Reset GetIt instance before each test
      GetIt.instance.reset();
    });

    tearDown(() {
      // Clean up after each test
      GetIt.instance.reset();
    });

    group('Service Registration', () {
      test('should register all required services', () {
        // Act
        ServiceLocator.setup();

        // Assert
        expect(GetIt.instance.isRegistered<IResponsiveService>(), isTrue);
        expect(GetIt.instance.isRegistered<INavigationService>(), isTrue);
        expect(GetIt.instance.isRegistered<IContentService>(), isTrue);
      });

      test('should register services as singletons', () {
        // Act
        ServiceLocator.setup();

        // Assert
        final responsiveService1 = GetIt.instance<IResponsiveService>();
        final responsiveService2 = GetIt.instance<IResponsiveService>();
        expect(identical(responsiveService1, responsiveService2), isTrue);

        final navigationService1 = GetIt.instance<INavigationService>();
        final navigationService2 = GetIt.instance<INavigationService>();
        expect(identical(navigationService1, navigationService2), isTrue);

        final contentService1 = GetIt.instance<IContentService>();
        final contentService2 = GetIt.instance<IContentService>();
        expect(identical(contentService1, contentService2), isTrue);
      });

      test('should register correct service implementations', () {
        // Act
        ServiceLocator.setup();

        // Assert
        expect(GetIt.instance<IResponsiveService>(), isA<ResponsiveService>());
        expect(GetIt.instance<INavigationService>(), isA<NavigationService>());
        expect(GetIt.instance<IContentService>(), isA<ContentService>());
      });
    });

    group('Service Retrieval', () {
      test('should retrieve responsive service successfully', () {
        // Arrange
        ServiceLocator.setup();

        // Act
        final service = ServiceLocator.get<IResponsiveService>();

        // Assert
        expect(service, isNotNull);
        expect(service, isA<IResponsiveService>());
      });

      test('should retrieve navigation service successfully', () {
        // Arrange
        ServiceLocator.setup();

        // Act
        final service = ServiceLocator.get<INavigationService>();

        // Assert
        expect(service, isNotNull);
        expect(service, isA<INavigationService>());
      });

      test('should retrieve content service successfully', () {
        // Arrange
        ServiceLocator.setup();

        // Act
        final service = ServiceLocator.get<IContentService>();

        // Assert
        expect(service, isNotNull);
        expect(service, isA<IContentService>());
      });

      test('should throw error when service not registered', () {
        // Act & Assert
        expect(
          () => ServiceLocator.get<IResponsiveService>(),
          throwsA(isA<StateError>()),
        );
      });
    });

    group('Service Lifecycle', () {
      test('should allow multiple setup calls without error', () {
        // Act & Assert
        expect(() => ServiceLocator.setup(), returnsNormally);
        expect(() => ServiceLocator.setup(), returnsNormally);
        expect(() => ServiceLocator.setup(), returnsNormally);
      });

      test('should maintain singleton behavior after multiple setups', () {
        // Act
        ServiceLocator.setup();
        final service1 = ServiceLocator.get<IResponsiveService>();

        ServiceLocator.setup();
        final service2 = ServiceLocator.get<IResponsiveService>();

        // Assert
        expect(identical(service1, service2), isTrue);
      });

      test('should handle reset functionality', () {
        // Arrange
        ServiceLocator.setup();
        expect(ServiceLocator.isRegistered<IResponsiveService>(), isTrue);

        // Act & Assert - Reset should work without throwing errors
        expect(() => ServiceLocator.reset(), returnsNormally);

        // Should be able to setup again
        expect(() => ServiceLocator.setup(), returnsNormally);
      });
    });

    group('Service Integration', () {
      test('should provide working responsive service', () {
        // Arrange
        ServiceLocator.setup();
        final service = ServiceLocator.get<IResponsiveService>();

        // Act & Assert
        expect(service.isMobile(400), isTrue);
        expect(service.isTablet(700), isTrue); // 700 is tablet
        expect(service.isDesktop(1200), isTrue);
        expect(service.getGridColumns(400), equals(2));
      });

      test('should provide working navigation service', () {
        // Arrange
        ServiceLocator.setup();
        final service = ServiceLocator.get<INavigationService>();

        // Act & Assert
        final items = service.getNavigationItems();
        expect(items, isNotEmpty);
        expect(items.length, equals(4));
        expect(items.first.id, equals('home'));
      });

      test('should provide working content service', () {
        // Arrange
        ServiceLocator.setup();
        final service = ServiceLocator.get<IContentService>();

        // Act & Assert
        final homeContent = service.getContentForRoute('/home');
        final unknownContent = service.getContentForRoute('/unknown');

        expect(homeContent, isNotNull);
        expect(unknownContent, isNotNull);
      });
    });

    group('Error Handling', () {
      test('should handle service registration errors gracefully', () {
        // This test ensures that if there are any issues with service registration,
        // they are handled appropriately
        expect(() => ServiceLocator.setup(), returnsNormally);
      });

      test('should provide meaningful error when service not found', () {
        // Act & Assert
        expect(
          () => ServiceLocator.get<String>(), // String is not registered
          throwsA(isA<StateError>()),
        );
      });
    });

    group('Performance', () {
      test('should register services quickly', () {
        // Act
        final stopwatch = Stopwatch()..start();
        ServiceLocator.setup();
        stopwatch.stop();

        // Assert - Setup should be very fast (less than 100ms)
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      test('should retrieve services quickly', () {
        // Arrange
        ServiceLocator.setup();

        // Act
        final stopwatch = Stopwatch()..start();
        ServiceLocator.get<IResponsiveService>();
        ServiceLocator.get<INavigationService>();
        ServiceLocator.get<IContentService>();
        stopwatch.stop();

        // Assert - Retrieval should be very fast (less than 10ms)
        expect(stopwatch.elapsedMilliseconds, lessThan(10));
      });
    });
  });
}
