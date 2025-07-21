import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reponsive_design/models/navigation_item.dart';

void main() {
  group('NavigationItem', () {
    group('Constructor', () {
      test('should create NavigationItem with valid properties', () {
        const item = NavigationItem(
          id: 'home',
          title: 'Home',
          icon: Icons.home,
          route: '/home',
        );

        expect(item.id, equals('home'));
        expect(item.title, equals('Home'));
        expect(item.icon, equals(Icons.home));
        expect(item.route, equals('/home'));
      });
    });

    group('Validation', () {
      test('should return true for valid NavigationItem', () {
        const item = NavigationItem(
          id: 'home',
          title: 'Home',
          icon: Icons.home,
          route: '/home',
        );

        expect(item.isValid(), isTrue);
        expect(item.getValidationErrors(), isEmpty);
      });

      test('should return false for empty id', () {
        const item = NavigationItem(
          id: '',
          title: 'Home',
          icon: Icons.home,
          route: '/home',
        );

        expect(item.isValid(), isFalse);
        expect(
          item.getValidationErrors(),
          contains('ID cannot be empty or whitespace only'),
        );
      });

      test('should return false for whitespace-only id', () {
        const item = NavigationItem(
          id: '   ',
          title: 'Home',
          icon: Icons.home,
          route: '/home',
        );

        expect(item.isValid(), isFalse);
        expect(
          item.getValidationErrors(),
          contains('ID cannot be empty or whitespace only'),
        );
      });

      test('should return false for empty title', () {
        const item = NavigationItem(
          id: 'home',
          title: '',
          icon: Icons.home,
          route: '/home',
        );

        expect(item.isValid(), isFalse);
        expect(
          item.getValidationErrors(),
          contains('Title cannot be empty or whitespace only'),
        );
      });

      test('should return false for whitespace-only title', () {
        const item = NavigationItem(
          id: 'home',
          title: '   ',
          icon: Icons.home,
          route: '/home',
        );

        expect(item.isValid(), isFalse);
        expect(
          item.getValidationErrors(),
          contains('Title cannot be empty or whitespace only'),
        );
      });

      test('should return false for empty route', () {
        const item = NavigationItem(
          id: 'home',
          title: 'Home',
          icon: Icons.home,
          route: '',
        );

        expect(item.isValid(), isFalse);
        expect(
          item.getValidationErrors(),
          contains('Route must not be empty and must start with "/"'),
        );
      });

      test('should return false for route not starting with /', () {
        const item = NavigationItem(
          id: 'home',
          title: 'Home',
          icon: Icons.home,
          route: 'home',
        );

        expect(item.isValid(), isFalse);
        expect(
          item.getValidationErrors(),
          contains('Route must not be empty and must start with "/"'),
        );
      });

      test('should return multiple validation errors', () {
        const item = NavigationItem(
          id: '',
          title: '',
          icon: Icons.home,
          route: 'invalid',
        );

        expect(item.isValid(), isFalse);
        final errors = item.getValidationErrors();
        expect(errors.length, equals(3));
        expect(errors, contains('ID cannot be empty or whitespace only'));
        expect(errors, contains('Title cannot be empty or whitespace only'));
        expect(
          errors,
          contains('Route must not be empty and must start with "/"'),
        );
      });
    });

    group('Equality', () {
      test('should be equal when all properties match', () {
        const item1 = NavigationItem(
          id: 'home',
          title: 'Home',
          icon: Icons.home,
          route: '/home',
        );

        const item2 = NavigationItem(
          id: 'home',
          title: 'Home',
          icon: Icons.home,
          route: '/home',
        );

        expect(item1, equals(item2));
        expect(item1.hashCode, equals(item2.hashCode));
      });

      test('should not be equal when id differs', () {
        const item1 = NavigationItem(
          id: 'home',
          title: 'Home',
          icon: Icons.home,
          route: '/home',
        );

        const item2 = NavigationItem(
          id: 'profile',
          title: 'Home',
          icon: Icons.home,
          route: '/home',
        );

        expect(item1, isNot(equals(item2)));
      });

      test('should not be equal when title differs', () {
        const item1 = NavigationItem(
          id: 'home',
          title: 'Home',
          icon: Icons.home,
          route: '/home',
        );

        const item2 = NavigationItem(
          id: 'home',
          title: 'Profile',
          icon: Icons.home,
          route: '/home',
        );

        expect(item1, isNot(equals(item2)));
      });

      test('should not be equal when icon differs', () {
        const item1 = NavigationItem(
          id: 'home',
          title: 'Home',
          icon: Icons.home,
          route: '/home',
        );

        const item2 = NavigationItem(
          id: 'home',
          title: 'Home',
          icon: Icons.person,
          route: '/home',
        );

        expect(item1, isNot(equals(item2)));
      });

      test('should not be equal when route differs', () {
        const item1 = NavigationItem(
          id: 'home',
          title: 'Home',
          icon: Icons.home,
          route: '/home',
        );

        const item2 = NavigationItem(
          id: 'home',
          title: 'Home',
          icon: Icons.home,
          route: '/profile',
        );

        expect(item1, isNot(equals(item2)));
      });

      test('should handle identical objects', () {
        const item = NavigationItem(
          id: 'home',
          title: 'Home',
          icon: Icons.home,
          route: '/home',
        );

        expect(item, equals(item));
      });
    });

    group('toString', () {
      test('should return formatted string representation', () {
        const item = NavigationItem(
          id: 'home',
          title: 'Home',
          icon: Icons.home,
          route: '/home',
        );

        final result = item.toString();
        expect(result, contains('NavigationItem'));
        expect(result, contains('id: home'));
        expect(result, contains('title: Home'));
        expect(result, contains('route: /home'));
      });
    });

    group('copyWith', () {
      test('should create copy with updated properties', () {
        const original = NavigationItem(
          id: 'home',
          title: 'Home',
          icon: Icons.home,
          route: '/home',
        );

        final updated = original.copyWith(
          title: 'Updated Home',
          route: '/updated-home',
        );

        expect(updated.id, equals('home'));
        expect(updated.title, equals('Updated Home'));
        expect(updated.icon, equals(Icons.home));
        expect(updated.route, equals('/updated-home'));
      });

      test('should create identical copy when no parameters provided', () {
        const original = NavigationItem(
          id: 'home',
          title: 'Home',
          icon: Icons.home,
          route: '/home',
        );

        final copy = original.copyWith();

        expect(copy, equals(original));
        expect(copy, isNot(same(original)));
      });
    });
  });
}
