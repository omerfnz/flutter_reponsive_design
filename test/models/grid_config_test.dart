import 'package:flutter_test/flutter_test.dart';
import 'package:reponsive_design/models/grid_config.dart';

void main() {
  group('GridConfig', () {
    group('Constructor', () {
      test('should create GridConfig with required properties', () {
        const config = GridConfig(columns: 4, maxCrossAxisExtent: 200.0);

        expect(config.columns, equals(4));
        expect(config.maxCrossAxisExtent, equals(200.0));
        expect(config.childAspectRatio, equals(1.0)); // default value
        expect(config.mainAxisSpacing, equals(8.0)); // default value
        expect(config.crossAxisSpacing, equals(8.0)); // default value
      });

      test('should create GridConfig with custom properties', () {
        const config = GridConfig(
          columns: 6,
          maxCrossAxisExtent: 150.0,
          childAspectRatio: 1.5,
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 16.0,
        );

        expect(config.columns, equals(6));
        expect(config.maxCrossAxisExtent, equals(150.0));
        expect(config.childAspectRatio, equals(1.5));
        expect(config.mainAxisSpacing, equals(12.0));
        expect(config.crossAxisSpacing, equals(16.0));
      });
    });

    group('Factory Constructors', () {
      test('should create mobile configuration', () {
        final config = GridConfig.mobile();

        expect(config.columns, equals(2));
        expect(config.maxCrossAxisExtent, equals(200.0));
        expect(config.childAspectRatio, equals(1.0));
        expect(config.mainAxisSpacing, equals(8.0));
        expect(config.crossAxisSpacing, equals(8.0));
      });

      test('should create tablet configuration', () {
        final config = GridConfig.tablet();

        expect(config.columns, equals(4));
        expect(config.maxCrossAxisExtent, equals(180.0));
        expect(config.childAspectRatio, equals(1.0));
        expect(config.mainAxisSpacing, equals(8.0));
        expect(config.crossAxisSpacing, equals(8.0));
      });

      test('should create desktop configuration', () {
        final config = GridConfig.desktop();

        expect(config.columns, equals(6));
        expect(config.maxCrossAxisExtent, equals(160.0));
        expect(config.childAspectRatio, equals(1.0));
        expect(config.mainAxisSpacing, equals(8.0));
        expect(config.crossAxisSpacing, equals(8.0));
      });

      test('should create mobile configuration with custom parameters', () {
        final config = GridConfig.mobile(
          childAspectRatio: 1.5,
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 16.0,
        );

        expect(config.columns, equals(2));
        expect(config.maxCrossAxisExtent, equals(200.0));
        expect(config.childAspectRatio, equals(1.5));
        expect(config.mainAxisSpacing, equals(12.0));
        expect(config.crossAxisSpacing, equals(16.0));
      });
    });

    group('fromScreenWidth Factory', () {
      test('should create mobile config for small screens', () {
        final config = GridConfig.fromScreenWidth(400);
        expect(config.columns, equals(2));
        expect(config.maxCrossAxisExtent, equals(200.0));
      });

      test('should create tablet config for medium screens', () {
        final config = GridConfig.fromScreenWidth(700);
        expect(config.columns, equals(4));
        expect(config.maxCrossAxisExtent, equals(180.0));
      });

      test('should create desktop config for large screens', () {
        final config = GridConfig.fromScreenWidth(1000);
        expect(config.columns, equals(6));
        expect(config.maxCrossAxisExtent, equals(160.0));
      });

      test('should handle edge cases for screen width', () {
        // Exactly at breakpoints
        expect(GridConfig.fromScreenWidth(600).columns, equals(4)); // tablet
        expect(GridConfig.fromScreenWidth(800).columns, equals(6)); // desktop

        // Just below breakpoints
        expect(GridConfig.fromScreenWidth(599).columns, equals(2)); // mobile
        expect(GridConfig.fromScreenWidth(799).columns, equals(4)); // tablet
      });
    });

    group('Validation', () {
      test('should return true for valid configuration', () {
        const config = GridConfig(
          columns: 4,
          maxCrossAxisExtent: 200.0,
          childAspectRatio: 1.0,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        );

        expect(config.isValid(), isTrue);
        expect(config.getValidationErrors(), isEmpty);
      });

      test('should return false for invalid columns', () {
        const config = GridConfig(columns: 0, maxCrossAxisExtent: 200.0);

        expect(config.isValid(), isFalse);
        expect(
          config.getValidationErrors(),
          contains('Columns must be greater than 0'),
        );
      });

      test('should return false for invalid maxCrossAxisExtent', () {
        const config = GridConfig(columns: 4, maxCrossAxisExtent: 0);

        expect(config.isValid(), isFalse);
        expect(
          config.getValidationErrors(),
          contains('Max cross axis extent must be greater than 0'),
        );
      });

      test('should return false for invalid childAspectRatio', () {
        const config = GridConfig(
          columns: 4,
          maxCrossAxisExtent: 200.0,
          childAspectRatio: 0,
        );

        expect(config.isValid(), isFalse);
        expect(
          config.getValidationErrors(),
          contains('Child aspect ratio must be greater than 0'),
        );
      });

      test('should return false for negative spacing values', () {
        const config = GridConfig(
          columns: 4,
          maxCrossAxisExtent: 200.0,
          mainAxisSpacing: -1.0,
          crossAxisSpacing: -1.0,
        );

        expect(config.isValid(), isFalse);
        final errors = config.getValidationErrors();
        expect(errors, contains('Main axis spacing cannot be negative'));
        expect(errors, contains('Cross axis spacing cannot be negative'));
      });

      test('should return multiple validation errors', () {
        const config = GridConfig(
          columns: -1,
          maxCrossAxisExtent: -1,
          childAspectRatio: -1,
          mainAxisSpacing: -1.0,
          crossAxisSpacing: -1.0,
        );

        expect(config.isValid(), isFalse);
        final errors = config.getValidationErrors();
        expect(errors.length, equals(5));
      });
    });

    group('Equality', () {
      test('should be equal when all properties match', () {
        const config1 = GridConfig(
          columns: 4,
          maxCrossAxisExtent: 200.0,
          childAspectRatio: 1.0,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        );

        const config2 = GridConfig(
          columns: 4,
          maxCrossAxisExtent: 200.0,
          childAspectRatio: 1.0,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        );

        expect(config1, equals(config2));
        expect(config1.hashCode, equals(config2.hashCode));
      });

      test('should not be equal when properties differ', () {
        const config1 = GridConfig(columns: 4, maxCrossAxisExtent: 200.0);

        const config2 = GridConfig(columns: 6, maxCrossAxisExtent: 200.0);

        expect(config1, isNot(equals(config2)));
      });

      test('should handle identical objects', () {
        const config = GridConfig(columns: 4, maxCrossAxisExtent: 200.0);

        expect(config, equals(config));
      });
    });

    group('toString', () {
      test('should return formatted string representation', () {
        const config = GridConfig(
          columns: 4,
          maxCrossAxisExtent: 200.0,
          childAspectRatio: 1.5,
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 16.0,
        );

        final result = config.toString();
        expect(result, contains('GridConfig'));
        expect(result, contains('columns: 4'));
        expect(result, contains('maxCrossAxisExtent: 200.0'));
        expect(result, contains('childAspectRatio: 1.5'));
        expect(result, contains('mainAxisSpacing: 12.0'));
        expect(result, contains('crossAxisSpacing: 16.0'));
      });
    });

    group('copyWith', () {
      test('should create copy with updated properties', () {
        const original = GridConfig(
          columns: 4,
          maxCrossAxisExtent: 200.0,
          childAspectRatio: 1.0,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        );

        final updated = original.copyWith(columns: 6, childAspectRatio: 1.5);

        expect(updated.columns, equals(6));
        expect(updated.maxCrossAxisExtent, equals(200.0));
        expect(updated.childAspectRatio, equals(1.5));
        expect(updated.mainAxisSpacing, equals(8.0));
        expect(updated.crossAxisSpacing, equals(8.0));
      });

      test('should create identical copy when no parameters provided', () {
        const original = GridConfig(columns: 4, maxCrossAxisExtent: 200.0);

        final copy = original.copyWith();

        expect(copy, equals(original));
        expect(copy, isNot(same(original)));
      });
    });
  });
}
