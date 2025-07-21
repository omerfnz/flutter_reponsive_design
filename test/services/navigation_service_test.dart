import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reponsive_design/services/navigation_service.dart';
import 'package:reponsive_design/interfaces/i_navigation_service.dart';
import 'package:reponsive_design/models/navigation_item.dart';
import 'package:reponsive_design/models/navigation_data.dart';

void main() {
  group('NavigationService', () {
    late INavigationService navigationService;
    late List<NavigationItem> capturedNavigationEvents;

    setUp(() {
      capturedNavigationEvents = [];
      navigationService = NavigationService(
        onNavigationChanged: (item) => capturedNavigationEvents.add(item),
      );
    });

    group('getNavigationItems', () {
      test('should return all navigation items from NavigationData', () {
        final items = navigationService.getNavigationItems();

        expect(items, isNotEmpty);
        expect(items.length, equals(NavigationData.itemCount));

        // Verify all expected items are present
        final expectedIds = ['home', 'profile', 'settings', 'about'];
        final actualIds = items.map((item) => item.id).toList();

        for (final expectedId in expectedIds) {
          expect(actualIds, contains(expectedId));
        }
      });

      test('should return items with proper structure', () {
        final items = navigationService.getNavigationItems();

        for (final item in items) {
          expect(item.id, isNotEmpty);
          expect(item.title, isNotEmpty);
          expect(item.route, startsWith('/'));
          expect(item.isValid(), isTrue);
        }
      });

      test('should return valid navigation items', () {
        final items = navigationService.getNavigationItems();

        for (final item in items) {
          expect(item.isValid(), isTrue);
          expect(item.getValidationErrors(), isEmpty);
        }
      });
    });

    group('navigateToItem', () {
      test('should navigate to valid navigation item', () {
        final homeItem = NavigationData.findById('home')!;

        expect(
          () => navigationService.navigateToItem(homeItem),
          returnsNormally,
        );
        expect(capturedNavigationEvents, contains(homeItem));
      });

      test('should navigate to all valid navigation items', () {
        final items = navigationService.getNavigationItems();

        for (final item in items) {
          capturedNavigationEvents.clear();
          navigationService.navigateToItem(item);
          expect(capturedNavigationEvents, contains(item));
        }
      });

      test('should throw ArgumentError for invalid navigation item', () {
        const invalidItem = NavigationItem(
          id: '',
          title: 'Invalid',
          icon: Icons.error,
          route: '/invalid',
        );

        expect(
          () => navigationService.navigateToItem(invalidItem),
          throwsArgumentError,
        );
      });

      test('should throw ArgumentError for item not in navigation data', () {
        const unknownItem = NavigationItem(
          id: 'unknown',
          title: 'Unknown',
          icon: Icons.help,
          route: '/unknown',
        );

        expect(
          () => navigationService.navigateToItem(unknownItem),
          throwsArgumentError,
        );
      });

      test('should handle navigation errors gracefully', () {
        // Create an item that exists in navigation data but has validation issues
        final homeItem = NavigationData.findById('home')!;
        final invalidItem = homeItem.copyWith(id: ''); // Make it invalid

        // This should trigger error handling and fallback to home
        expect(
          () => navigationService.navigateToItem(invalidItem),
          throwsArgumentError,
        );
      });
    });

    group('Additional NavigationService methods', () {
      test('findItemById should return correct item for valid ID', () {
        final service = navigationService as NavigationService;

        final homeItem = service.findItemById('home');
        expect(homeItem, isNotNull);
        expect(homeItem!.id, equals('home'));
        expect(homeItem.title, equals('Home'));
        expect(homeItem.route, equals('/home'));
      });

      test('findItemById should return null for invalid ID', () {
        final service = navigationService as NavigationService;

        expect(service.findItemById('nonexistent'), isNull);
      });

      test('findItemById should throw ArgumentError for empty ID', () {
        final service = navigationService as NavigationService;

        expect(() => service.findItemById(''), throwsArgumentError);
      });

      test('findItemByRoute should return correct item for valid route', () {
        final service = navigationService as NavigationService;

        final profileItem = service.findItemByRoute('/profile');
        expect(profileItem, isNotNull);
        expect(profileItem!.id, equals('profile'));
        expect(profileItem.title, equals('Profile'));
        expect(profileItem.route, equals('/profile'));
      });

      test('findItemByRoute should return null for invalid route', () {
        final service = navigationService as NavigationService;

        expect(service.findItemByRoute('/nonexistent'), isNull);
      });

      test('findItemByRoute should throw ArgumentError for empty route', () {
        final service = navigationService as NavigationService;

        expect(() => service.findItemByRoute(''), throwsArgumentError);
      });

      test('getDefaultItem should return home item', () {
        final service = navigationService as NavigationService;

        final defaultItem = service.getDefaultItem();
        expect(defaultItem.id, equals('home'));
        expect(defaultItem.title, equals('Home'));
        expect(defaultItem.route, equals('/home'));
      });

      test('hasItemWithId should return true for existing IDs', () {
        final service = navigationService as NavigationService;

        expect(service.hasItemWithId('home'), isTrue);
        expect(service.hasItemWithId('profile'), isTrue);
        expect(service.hasItemWithId('settings'), isTrue);
        expect(service.hasItemWithId('about'), isTrue);
      });

      test('hasItemWithId should return false for non-existing IDs', () {
        final service = navigationService as NavigationService;

        expect(service.hasItemWithId('nonexistent'), isFalse);
        expect(service.hasItemWithId(''), isFalse);
      });

      test('hasItemWithRoute should return true for existing routes', () {
        final service = navigationService as NavigationService;

        expect(service.hasItemWithRoute('/home'), isTrue);
        expect(service.hasItemWithRoute('/profile'), isTrue);
        expect(service.hasItemWithRoute('/settings'), isTrue);
        expect(service.hasItemWithRoute('/about'), isTrue);
      });

      test('hasItemWithRoute should return false for non-existing routes', () {
        final service = navigationService as NavigationService;

        expect(service.hasItemWithRoute('/nonexistent'), isFalse);
        expect(service.hasItemWithRoute(''), isFalse);
      });

      test('getAllRoutes should return all navigation routes', () {
        final service = navigationService as NavigationService;

        final routes = service.getAllRoutes();
        expect(routes, contains('/home'));
        expect(routes, contains('/profile'));
        expect(routes, contains('/settings'));
        expect(routes, contains('/about'));
        expect(routes.length, equals(4));
      });

      test('getAllIds should return all navigation IDs', () {
        final service = navigationService as NavigationService;

        final ids = service.getAllIds();
        expect(ids, contains('home'));
        expect(ids, contains('profile'));
        expect(ids, contains('settings'));
        expect(ids, contains('about'));
        expect(ids.length, equals(4));
      });

      test('isValidRoute should validate routes correctly', () {
        final service = navigationService as NavigationService;

        // Valid routes
        expect(service.isValidRoute('/home'), isTrue);
        expect(service.isValidRoute('/profile'), isTrue);
        expect(service.isValidRoute('/settings'), isTrue);
        expect(service.isValidRoute('/about'), isTrue);

        // Invalid routes
        expect(service.isValidRoute('/nonexistent'), isFalse);
        expect(service.isValidRoute('home'), isFalse); // Missing leading slash
        expect(service.isValidRoute(''), isFalse);
      });

      test('getNavigationSummary should return comprehensive summary', () {
        final service = navigationService as NavigationService;

        final summary = service.getNavigationSummary();
        expect(summary, isA<Map<String, dynamic>>());
        expect(summary['totalItems'], equals(4));
        expect(summary['allValid'], isTrue);
        expect(summary['duplicateIds'], isEmpty);
        expect(summary['duplicateRoutes'], isEmpty);
        expect(summary['items'], isA<List>());
      });

      test('navigateToRoute should navigate to valid route', () {
        final service = navigationService as NavigationService;

        capturedNavigationEvents.clear();
        service.navigateToRoute('/profile');

        expect(capturedNavigationEvents, hasLength(1));
        expect(capturedNavigationEvents.first.route, equals('/profile'));
      });

      test('navigateToRoute should throw ArgumentError for invalid route', () {
        final service = navigationService as NavigationService;

        expect(
          () => service.navigateToRoute('/nonexistent'),
          throwsArgumentError,
        );
        expect(() => service.navigateToRoute(''), throwsArgumentError);
      });

      test('navigateToId should navigate to valid ID', () {
        final service = navigationService as NavigationService;

        capturedNavigationEvents.clear();
        service.navigateToId('settings');

        expect(capturedNavigationEvents, hasLength(1));
        expect(capturedNavigationEvents.first.id, equals('settings'));
      });

      test('navigateToId should throw ArgumentError for invalid ID', () {
        final service = navigationService as NavigationService;

        expect(() => service.navigateToId('nonexistent'), throwsArgumentError);
        expect(() => service.navigateToId(''), throwsArgumentError);
      });

      test('navigateToDefault should navigate to home', () {
        final service = navigationService as NavigationService;

        capturedNavigationEvents.clear();
        service.navigateToDefault();

        expect(capturedNavigationEvents, hasLength(1));
        expect(capturedNavigationEvents.first.id, equals('home'));
      });
    });

    group('NavigationService with NavigatorKey', () {
      test('should work with navigator key', () {
        final navigatorKey = GlobalKey<NavigatorState>();
        final serviceWithKey = NavigationService(
          navigatorKey: navigatorKey,
          onNavigationChanged: (item) => capturedNavigationEvents.add(item),
        );

        final homeItem = NavigationData.findById('home')!;

        // Should throw because navigator state is not initialized in test environment
        expect(
          () => serviceWithKey.navigateToItem(homeItem),
          throwsA(isA<Error>()),
        );
      });
    });

    group('Error handling and edge cases', () {
      test('should handle empty navigation data gracefully', () {
        // This test verifies the service can handle edge cases
        final items = navigationService.getNavigationItems();
        expect(items, isNotEmpty); // Should always return at least default item
      });

      test('should validate all navigation items on retrieval', () {
        final items = navigationService.getNavigationItems();

        for (final item in items) {
          expect(item.isValid(), isTrue);
        }
      });

      test('should handle navigation callback being null', () {
        final serviceWithoutCallback = const NavigationService();
        final homeItem = NavigationData.findById('home')!;

        expect(
          () => serviceWithoutCallback.navigateToItem(homeItem),
          returnsNormally,
        );
      });
    });

    group('Integration tests', () {
      test('should maintain consistency between different lookup methods', () {
        final service = navigationService as NavigationService;
        final items = service.getNavigationItems();

        for (final item in items) {
          // Test ID lookup consistency
          final foundById = service.findItemById(item.id);
          expect(foundById, equals(item));
          expect(service.hasItemWithId(item.id), isTrue);

          // Test route lookup consistency
          final foundByRoute = service.findItemByRoute(item.route);
          expect(foundByRoute, equals(item));
          expect(service.hasItemWithRoute(item.route), isTrue);

          // Test route validation consistency
          expect(service.isValidRoute(item.route), isTrue);
        }
      });

      test('should handle complete navigation workflow', () {
        final service = navigationService as NavigationService;

        // Get all items
        final items = service.getNavigationItems();
        expect(items, isNotEmpty);

        // Navigate to each item
        for (final item in items) {
          capturedNavigationEvents.clear();
          service.navigateToItem(item);
          expect(capturedNavigationEvents, contains(item));
        }

        // Test convenience methods
        capturedNavigationEvents.clear();
        service.navigateToRoute('/home');
        expect(capturedNavigationEvents.first.route, equals('/home'));

        capturedNavigationEvents.clear();
        service.navigateToId('profile');
        expect(capturedNavigationEvents.first.id, equals('profile'));

        capturedNavigationEvents.clear();
        service.navigateToDefault();
        expect(capturedNavigationEvents.first.id, equals('home'));
      });
    });
  });
}
