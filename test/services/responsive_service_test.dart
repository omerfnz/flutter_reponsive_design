import 'package:flutter_test/flutter_test.dart';
import 'package:reponsive_design/services/responsive_service.dart';
import 'package:reponsive_design/interfaces/i_responsive_service.dart';
import 'package:reponsive_design/models/breakpoint_config.dart';

void main() {
  group('ResponsiveService', () {
    late IResponsiveService responsiveService;

    setUp(() {
      responsiveService = const ResponsiveService();
    });

    group('isMobile', () {
      test('should return true for widths below mobile breakpoint', () {
        // Test various mobile widths
        expect(responsiveService.isMobile(0), isTrue);
        expect(responsiveService.isMobile(320), isTrue);
        expect(responsiveService.isMobile(480), isTrue);
        expect(responsiveService.isMobile(599), isTrue);
      });

      test('should return false for widths at or above mobile breakpoint', () {
        // Test tablet and desktop widths
        expect(responsiveService.isMobile(600), isFalse);
        expect(responsiveService.isMobile(768), isFalse);
        expect(responsiveService.isMobile(1024), isFalse);
        expect(responsiveService.isMobile(1200), isFalse);
      });

      test('should throw ArgumentError for negative width', () {
        expect(() => responsiveService.isMobile(-1), throwsArgumentError);
        expect(() => responsiveService.isMobile(-100), throwsArgumentError);
      });

      test('should handle edge case at exact breakpoint', () {
        expect(
          responsiveService.isMobile(BreakpointConfig.mobileBreakpoint),
          isFalse,
        );
        expect(
          responsiveService.isMobile(BreakpointConfig.mobileBreakpoint - 0.1),
          isTrue,
        );
      });
    });

    group('isTablet', () {
      test(
        'should return true for widths between mobile and tablet breakpoints',
        () {
          expect(responsiveService.isTablet(600), isTrue);
          expect(responsiveService.isTablet(650), isTrue);
          expect(responsiveService.isTablet(768), isTrue);
          expect(responsiveService.isTablet(799), isTrue);
        },
      );

      test('should return false for mobile widths', () {
        expect(responsiveService.isTablet(320), isFalse);
        expect(responsiveService.isTablet(480), isFalse);
        expect(responsiveService.isTablet(599), isFalse);
      });

      test('should return false for desktop widths', () {
        expect(responsiveService.isTablet(800), isFalse);
        expect(responsiveService.isTablet(1024), isFalse);
        expect(responsiveService.isTablet(1200), isFalse);
      });

      test('should throw ArgumentError for negative width', () {
        expect(() => responsiveService.isTablet(-1), throwsArgumentError);
        expect(() => responsiveService.isTablet(-50), throwsArgumentError);
      });

      test('should handle edge cases at exact breakpoints', () {
        expect(
          responsiveService.isTablet(BreakpointConfig.mobileBreakpoint),
          isTrue,
        );
        expect(
          responsiveService.isTablet(BreakpointConfig.tabletBreakpoint),
          isFalse,
        );
        expect(
          responsiveService.isTablet(BreakpointConfig.tabletBreakpoint - 0.1),
          isTrue,
        );
      });
    });

    group('isDesktop', () {
      test('should return true for widths at or above tablet breakpoint', () {
        expect(responsiveService.isDesktop(800), isTrue);
        expect(responsiveService.isDesktop(1024), isTrue);
        expect(responsiveService.isDesktop(1200), isTrue);
        expect(responsiveService.isDesktop(1920), isTrue);
      });

      test('should return false for mobile and tablet widths', () {
        expect(responsiveService.isDesktop(320), isFalse);
        expect(responsiveService.isDesktop(480), isFalse);
        expect(responsiveService.isDesktop(600), isFalse);
        expect(responsiveService.isDesktop(768), isFalse);
        expect(responsiveService.isDesktop(799), isFalse);
      });

      test('should throw ArgumentError for negative width', () {
        expect(() => responsiveService.isDesktop(-1), throwsArgumentError);
        expect(() => responsiveService.isDesktop(-200), throwsArgumentError);
      });

      test('should handle edge case at exact breakpoint', () {
        expect(
          responsiveService.isDesktop(BreakpointConfig.tabletBreakpoint),
          isTrue,
        );
        expect(
          responsiveService.isDesktop(BreakpointConfig.tabletBreakpoint - 0.1),
          isFalse,
        );
      });
    });

    group('getGridColumns', () {
      test('should return mobile columns for mobile widths', () {
        expect(
          responsiveService.getGridColumns(320),
          equals(BreakpointConfig.mobileGridColumns),
        );
        expect(
          responsiveService.getGridColumns(480),
          equals(BreakpointConfig.mobileGridColumns),
        );
        expect(
          responsiveService.getGridColumns(599),
          equals(BreakpointConfig.mobileGridColumns),
        );
      });

      test('should return tablet columns for tablet widths', () {
        expect(
          responsiveService.getGridColumns(600),
          equals(BreakpointConfig.tabletGridColumns),
        );
        expect(
          responsiveService.getGridColumns(768),
          equals(BreakpointConfig.tabletGridColumns),
        );
        expect(
          responsiveService.getGridColumns(799),
          equals(BreakpointConfig.tabletGridColumns),
        );
      });

      test('should return desktop columns for desktop widths', () {
        expect(
          responsiveService.getGridColumns(800),
          equals(BreakpointConfig.desktopGridColumns),
        );
        expect(
          responsiveService.getGridColumns(1024),
          equals(BreakpointConfig.desktopGridColumns),
        );
        expect(
          responsiveService.getGridColumns(1920),
          equals(BreakpointConfig.desktopGridColumns),
        );
      });

      test('should throw ArgumentError for negative width', () {
        expect(() => responsiveService.getGridColumns(-1), throwsArgumentError);
        expect(
          () => responsiveService.getGridColumns(-10),
          throwsArgumentError,
        );
      });

      test('should handle edge cases at exact breakpoints', () {
        expect(
          responsiveService.getGridColumns(BreakpointConfig.mobileBreakpoint),
          equals(BreakpointConfig.tabletGridColumns),
        );
        expect(
          responsiveService.getGridColumns(BreakpointConfig.tabletBreakpoint),
          equals(BreakpointConfig.desktopGridColumns),
        );
      });
    });

    group('Additional ResponsiveService methods', () {
      test('getDeviceType should return correct device type strings', () {
        final service = responsiveService as ResponsiveService;

        expect(service.getDeviceType(320), equals('mobile'));
        expect(service.getDeviceType(600), equals('tablet'));
        expect(service.getDeviceType(800), equals('desktop'));
        expect(service.getDeviceType(1920), equals('desktop'));
      });

      test('getDeviceType should throw ArgumentError for negative width', () {
        final service = responsiveService as ResponsiveService;
        expect(() => service.getDeviceType(-1), throwsArgumentError);
      });

      test('getAllBreakpoints should return all breakpoint values', () {
        final service = responsiveService as ResponsiveService;
        final breakpoints = service.getAllBreakpoints();

        expect(breakpoints, isA<Map<String, double>>());
        expect(
          breakpoints['mobile'],
          equals(BreakpointConfig.mobileBreakpoint),
        );
        expect(
          breakpoints['tablet'],
          equals(BreakpointConfig.tabletBreakpoint),
        );
        expect(
          breakpoints['desktop'],
          equals(BreakpointConfig.desktopBreakpoint),
        );
      });

      test(
        'getAllGridColumns should return all grid column configurations',
        () {
          final service = responsiveService as ResponsiveService;
          final gridColumns = service.getAllGridColumns();

          expect(gridColumns, isA<Map<String, int>>());
          expect(
            gridColumns['mobile'],
            equals(BreakpointConfig.mobileGridColumns),
          );
          expect(
            gridColumns['tablet'],
            equals(BreakpointConfig.tabletGridColumns),
          );
          expect(
            gridColumns['desktop'],
            equals(BreakpointConfig.desktopGridColumns),
          );
        },
      );

      test('isAtBreakpoint should detect breakpoint boundaries correctly', () {
        final service = responsiveService as ResponsiveService;

        expect(service.isAtBreakpoint(600.0, 'mobile'), isTrue);
        expect(
          service.isAtBreakpoint(599.0, 'mobile'),
          isTrue,
        ); // Within tolerance
        expect(
          service.isAtBreakpoint(601.0, 'mobile'),
          isTrue,
        ); // Within tolerance
        expect(service.isAtBreakpoint(800.0, 'tablet'), isTrue);
        expect(service.isAtBreakpoint(1200.0, 'desktop'), isTrue);
      });

      test('isAtBreakpoint should throw for invalid breakpoint names', () {
        final service = responsiveService as ResponsiveService;
        expect(
          () => service.isAtBreakpoint(600, 'invalid'),
          throwsArgumentError,
        );
        expect(() => service.isAtBreakpoint(600, ''), throwsArgumentError);
      });

      test('isAtBreakpoint should throw for negative width', () {
        final service = responsiveService as ResponsiveService;
        expect(() => service.isAtBreakpoint(-1, 'mobile'), throwsArgumentError);
      });

      test(
        'getMaxCrossAxisExtent should return correct values for each device type',
        () {
          final service = responsiveService as ResponsiveService;

          expect(service.getMaxCrossAxisExtent(320), equals(200.0)); // Mobile
          expect(service.getMaxCrossAxisExtent(600), equals(180.0)); // Tablet
          expect(service.getMaxCrossAxisExtent(800), equals(160.0)); // Desktop
        },
      );

      test('getMaxCrossAxisExtent should throw for negative width', () {
        final service = responsiveService as ResponsiveService;
        expect(() => service.getMaxCrossAxisExtent(-1), throwsArgumentError);
      });

      test('getOptimalItemWidth should calculate correct item widths', () {
        final service = responsiveService as ResponsiveService;

        // Mobile: 2 columns, screen width 320, padding 16
        // Available width: 320 - 32 = 288
        // Item spacing: 8 * (2-1) = 8
        // Item width: (288 - 8) / 2 = 140
        expect(service.getOptimalItemWidth(320), equals(140.0));

        // Tablet: 4 columns, screen width 768, padding 16
        // Available width: 768 - 32 = 736
        // Item spacing: 8 * (4-1) = 24
        // Item width: (736 - 24) / 4 = 178
        expect(service.getOptimalItemWidth(768), equals(178.0));
      });

      test('getOptimalItemWidth should handle custom padding', () {
        final service = responsiveService as ResponsiveService;

        // Mobile with custom padding of 24
        // Available width: 320 - 48 = 272
        // Item spacing: 8 * (2-1) = 8
        // Item width: (272 - 8) / 2 = 132
        expect(service.getOptimalItemWidth(320, padding: 24.0), equals(132.0));
      });

      test('getOptimalItemWidth should throw for negative width', () {
        final service = responsiveService as ResponsiveService;
        expect(() => service.getOptimalItemWidth(-1), throwsArgumentError);
      });
    });

    group('Integration tests', () {
      test('device type detection should be mutually exclusive', () {
        final testWidths = [
          320.0,
          480.0,
          600.0,
          768.0,
          800.0,
          1024.0,
          1200.0,
          1920.0,
        ];

        for (final width in testWidths) {
          final isMobile = responsiveService.isMobile(width);
          final isTablet = responsiveService.isTablet(width);
          final isDesktop = responsiveService.isDesktop(width);

          // Exactly one should be true
          final trueCount =
              [isMobile, isTablet, isDesktop].where((x) => x).length;
          expect(
            trueCount,
            equals(1),
            reason: 'Width $width should match exactly one device type',
          );
        }
      });

      test('grid columns should match device type', () {
        // Mobile widths should return mobile columns
        expect(responsiveService.getGridColumns(320), equals(2));
        expect(responsiveService.getGridColumns(599), equals(2));

        // Tablet widths should return tablet columns
        expect(responsiveService.getGridColumns(600), equals(4));
        expect(responsiveService.getGridColumns(799), equals(4));

        // Desktop widths should return desktop columns
        expect(responsiveService.getGridColumns(800), equals(6));
        expect(responsiveService.getGridColumns(1920), equals(6));
      });

      test('service should handle edge cases gracefully', () {
        // Test with very small positive values
        expect(responsiveService.isMobile(0.1), isTrue);
        expect(responsiveService.getGridColumns(0.1), equals(2));

        // Test with very large values
        expect(responsiveService.isDesktop(10000), isTrue);
        expect(responsiveService.getGridColumns(10000), equals(6));
      });
    });
  });
}
