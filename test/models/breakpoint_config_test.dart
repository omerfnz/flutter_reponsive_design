import 'package:flutter_test/flutter_test.dart';
import 'package:reponsive_design/models/breakpoint_config.dart';

void main() {
  group('BreakpointConfig', () {
    group('Constants', () {
      test('should have correct breakpoint values', () {
        expect(BreakpointConfig.mobileBreakpoint, equals(600.0));
        expect(BreakpointConfig.tabletBreakpoint, equals(800.0));
        expect(BreakpointConfig.desktopBreakpoint, equals(1200.0));
      });

      test('should have correct grid column values', () {
        expect(BreakpointConfig.mobileGridColumns, equals(2));
        expect(BreakpointConfig.tabletGridColumns, equals(4));
        expect(BreakpointConfig.desktopGridColumns, equals(6));
      });
    });

    group('Device Type Detection', () {
      test('should correctly identify mobile devices', () {
        expect(BreakpointConfig.isMobile(300), isTrue);
        expect(BreakpointConfig.isMobile(599), isTrue);
        expect(BreakpointConfig.isMobile(600), isFalse);
        expect(BreakpointConfig.isMobile(800), isFalse);
      });

      test('should correctly identify tablet devices', () {
        expect(BreakpointConfig.isTablet(599), isFalse);
        expect(BreakpointConfig.isTablet(600), isTrue);
        expect(BreakpointConfig.isTablet(700), isTrue);
        expect(BreakpointConfig.isTablet(799), isTrue);
        expect(BreakpointConfig.isTablet(800), isFalse);
      });

      test('should correctly identify desktop devices', () {
        expect(BreakpointConfig.isDesktop(600), isFalse);
        expect(BreakpointConfig.isDesktop(799), isFalse);
        expect(BreakpointConfig.isDesktop(800), isTrue);
        expect(BreakpointConfig.isDesktop(1200), isTrue);
        expect(BreakpointConfig.isDesktop(1920), isTrue);
      });
    });

    group('Grid Columns', () {
      test('should return correct grid columns for mobile', () {
        expect(BreakpointConfig.getGridColumns(300), equals(2));
        expect(BreakpointConfig.getGridColumns(599), equals(2));
      });

      test('should return correct grid columns for tablet', () {
        expect(BreakpointConfig.getGridColumns(600), equals(4));
        expect(BreakpointConfig.getGridColumns(700), equals(4));
        expect(BreakpointConfig.getGridColumns(799), equals(4));
      });

      test('should return correct grid columns for desktop', () {
        expect(BreakpointConfig.getGridColumns(800), equals(6));
        expect(BreakpointConfig.getGridColumns(1200), equals(6));
        expect(BreakpointConfig.getGridColumns(1920), equals(6));
      });
    });

    group('Device Type String', () {
      test('should return correct device type strings', () {
        expect(BreakpointConfig.getDeviceType(300), equals('mobile'));
        expect(BreakpointConfig.getDeviceType(600), equals('tablet'));
        expect(BreakpointConfig.getDeviceType(800), equals('desktop'));
      });
    });

    group('Configuration Maps', () {
      test('should return all breakpoints', () {
        final breakpoints = BreakpointConfig.getAllBreakpoints();
        expect(breakpoints['mobile'], equals(600.0));
        expect(breakpoints['tablet'], equals(800.0));
        expect(breakpoints['desktop'], equals(1200.0));
      });

      test('should return all grid columns', () {
        final gridColumns = BreakpointConfig.getAllGridColumns();
        expect(gridColumns['mobile'], equals(2));
        expect(gridColumns['tablet'], equals(4));
        expect(gridColumns['desktop'], equals(6));
      });
    });

    group('Edge Cases', () {
      test('should handle exact breakpoint values', () {
        // Exactly at mobile breakpoint should be tablet
        expect(BreakpointConfig.isMobile(600.0), isFalse);
        expect(BreakpointConfig.isTablet(600.0), isTrue);

        // Exactly at tablet breakpoint should be desktop
        expect(BreakpointConfig.isTablet(800.0), isFalse);
        expect(BreakpointConfig.isDesktop(800.0), isTrue);
      });

      test('should handle zero and negative values', () {
        expect(BreakpointConfig.isMobile(0), isTrue);
        expect(BreakpointConfig.getGridColumns(0), equals(2));
        expect(BreakpointConfig.getDeviceType(0), equals('mobile'));
      });

      test('should handle very large values', () {
        expect(BreakpointConfig.isDesktop(9999), isTrue);
        expect(BreakpointConfig.getGridColumns(9999), equals(6));
        expect(BreakpointConfig.getDeviceType(9999), equals('desktop'));
      });
    });
  });
}
