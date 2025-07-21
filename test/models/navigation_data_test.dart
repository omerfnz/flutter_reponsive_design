import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reponsive_design/models/navigation_data.dart';
import 'package:reponsive_design/models/navigation_item.dart';

void main() {
  group('NavigationData', () {
    group('Static Data', () {
      test('should have 4 navigation items', () {
        expect(NavigationData.itemCount, equals(4));
        expect(NavigationData.items.length, equals(4));
      });

      test('should contain Home navigation item', () {
        final homeItem = NavigationData.findById('home');
        expect(homeItem, isNotNull);
        expect(homeItem!.title, equals('Home'));
        expect(homeItem.icon, equals(Icons.home));
        expect(homeItem.route, equals('/home'));
      });

      test('should contain Profile navigation item', () {
        final profileItem = NavigationData.findById('profile');
        expect(profileItem, isNotNull);
        expect(profileItem!.title, equals('Profile'));
        expect(profileItem.icon, equals(Icons.person));
        expect(profileItem.route, equals('/profile'));
      });

      test('should contain Settings navigation item', () {
        final settingsItem = NavigationData.findById('settings');
        expect(settingsItem, isNotNull);
        expect(settingsItem!.title, equals('Settings'));
        expect(settingsItem.icon, equals(Icons.settings));
        expect(settingsItem.route, equals('/settings'));
      });

      test('should contain About navigation item', () {
        final aboutItem = NavigationData.findById('about');
        expect(aboutItem, isNotNull);
        expect(aboutItem!.title, equals('About'));
        expect(aboutItem.icon, equals(Icons.info));
        expect(aboutItem.route, equals('/about'));
      });

      test('should return unmodifiable list', () {
        final items = NavigationData.items;
        expect(
          () => items.add(
            const NavigationItem(
              id: 'test',
              title: 'Test',
              icon: Icons.star,
              route: '/test',
            ),
          ),
          throwsUnsupportedError,
        );
      });
    });

    group('Find Methods', () {
      test('should find item by valid ID', () {
        final item = NavigationData.findById('home');
        expect(item, isNotNull);
        expect(item!.id, equals('home'));
      });

      test('should return null for invalid ID', () {
        final item = NavigationData.findById('nonexistent');
        expect(item, isNull);
      });

      test('should find item by valid route', () {
        final item = NavigationData.findByRoute('/profile');
        expect(item, isNotNull);
        expect(item!.route, equals('/profile'));
      });

      test('should return null for invalid route', () {
        final item = NavigationData.findByRoute('/nonexistent');
        expect(item, isNull);
      });

      test('should handle empty string searches', () {
        expect(NavigationData.findById(''), isNull);
        expect(NavigationData.findByRoute(''), isNull);
      });
    });

    group('Default Item', () {
      test('should return Home as default item', () {
        final defaultItem = NavigationData.defaultItem;
        expect(defaultItem.id, equals('home'));
        expect(defaultItem.title, equals('Home'));
        expect(defaultItem.route, equals('/home'));
      });
    });

    group('Existence Checks', () {
      test('should correctly check if item exists by ID', () {
        expect(NavigationData.hasItemWithId('home'), isTrue);
        expect(NavigationData.hasItemWithId('profile'), isTrue);
        expect(NavigationData.hasItemWithId('settings'), isTrue);
        expect(NavigationData.hasItemWithId('about'), isTrue);
        expect(NavigationData.hasItemWithId('nonexistent'), isFalse);
      });

      test('should correctly check if item exists by route', () {
        expect(NavigationData.hasItemWithRoute('/home'), isTrue);
        expect(NavigationData.hasItemWithRoute('/profile'), isTrue);
        expect(NavigationData.hasItemWithRoute('/settings'), isTrue);
        expect(NavigationData.hasItemWithRoute('/about'), isTrue);
        expect(NavigationData.hasItemWithRoute('/nonexistent'), isFalse);
      });
    });

    group('Collection Methods', () {
      test('should return all IDs', () {
        final ids = NavigationData.allIds;
        expect(ids, contains('home'));
        expect(ids, contains('profile'));
        expect(ids, contains('settings'));
        expect(ids, contains('about'));
        expect(ids.length, equals(4));
      });

      test('should return all routes', () {
        final routes = NavigationData.allRoutes;
        expect(routes, contains('/home'));
        expect(routes, contains('/profile'));
        expect(routes, contains('/settings'));
        expect(routes, contains('/about'));
        expect(routes.length, equals(4));
      });

      test('should return all titles', () {
        final titles = NavigationData.allTitles;
        expect(titles, contains('Home'));
        expect(titles, contains('Profile'));
        expect(titles, contains('Settings'));
        expect(titles, contains('About'));
        expect(titles.length, equals(4));
      });
    });

    group('Validation', () {
      test('should validate all items successfully', () {
        expect(NavigationData.validateAllItems(), isTrue);
      });

      test('should return empty validation errors for valid data', () {
        final errors = NavigationData.getAllValidationErrors();
        expect(errors, isEmpty);
      });

      test('should find no duplicate IDs', () {
        final duplicates = NavigationData.findDuplicateIds();
        expect(duplicates, isEmpty);
      });

      test('should find no duplicate routes', () {
        final duplicates = NavigationData.findDuplicateRoutes();
        expect(duplicates, isEmpty);
      });
    });

    group('Summary', () {
      test('should return correct summary', () {
        final summary = NavigationData.getSummary();

        expect(summary['totalItems'], equals(4));
        expect(summary['allValid'], isTrue);
        expect(summary['duplicateIds'], isEmpty);
        expect(summary['duplicateRoutes'], isEmpty);

        final items = summary['items'] as List;
        expect(items.length, equals(4));

        // Check first item (Home)
        final homeItem = items.firstWhere((item) => item['id'] == 'home');
        expect(homeItem['title'], equals('Home'));
        expect(homeItem['route'], equals('/home'));
        expect(homeItem['isValid'], isTrue);
      });
    });

    group('Data Integrity', () {
      test('should have unique IDs', () {
        final ids = NavigationData.allIds;
        final uniqueIds = ids.toSet();
        expect(ids.length, equals(uniqueIds.length));
      });

      test('should have unique routes', () {
        final routes = NavigationData.allRoutes;
        final uniqueRoutes = routes.toSet();
        expect(routes.length, equals(uniqueRoutes.length));
      });

      test('should have all valid navigation items', () {
        for (final item in NavigationData.items) {
          expect(
            item.isValid(),
            isTrue,
            reason: 'Item ${item.id} should be valid',
          );
        }
      });

      test('should have proper route format', () {
        for (final item in NavigationData.items) {
          expect(
            item.route.startsWith('/'),
            isTrue,
            reason: 'Route ${item.route} should start with "/"',
          );
        }
      });

      test('should have non-empty titles and IDs', () {
        for (final item in NavigationData.items) {
          expect(
            item.id.isNotEmpty,
            isTrue,
            reason: 'ID should not be empty for item ${item.id}',
          );
          expect(
            item.title.isNotEmpty,
            isTrue,
            reason: 'Title should not be empty for item ${item.id}',
          );
        }
      });
    });

    group('Edge Cases', () {
      test('should handle case-sensitive ID searches', () {
        expect(NavigationData.findById('HOME'), isNull);
        expect(NavigationData.findById('Home'), isNull);
        expect(NavigationData.findById('home'), isNotNull);
      });

      test('should handle case-sensitive route searches', () {
        expect(NavigationData.findByRoute('/HOME'), isNull);
        expect(NavigationData.findByRoute('/Home'), isNull);
        expect(NavigationData.findByRoute('/home'), isNotNull);
      });

      test('should handle whitespace in searches', () {
        expect(NavigationData.findById(' home '), isNull);
        expect(NavigationData.findByRoute(' /home '), isNull);
      });
    });
  });
}
