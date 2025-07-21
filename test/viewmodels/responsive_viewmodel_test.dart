import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:reponsive_design/interfaces/i_responsive_service.dart';
import 'package:reponsive_design/viewmodels/responsive_viewmodel.dart';

import 'responsive_viewmodel_test.mocks.dart';

@GenerateMocks([IResponsiveService])
void main() {
  group('ResponsiveViewModel Tests', () {
    late ResponsiveViewModel viewModel;
    late MockIResponsiveService mockResponsiveService;

    setUp(() {
      mockResponsiveService = MockIResponsiveService();
      viewModel = ResponsiveViewModel(mockResponsiveService);
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('Initialization', () {
      test('should initialize with zero screen width', () {
        expect(viewModel.screenWidth, equals(0));
        expect(viewModel.isInitialized, isFalse);
      });

      test('should return device type properties based on service', () {
        // Setup mock responses for width 0
        when(mockResponsiveService.isMobile(0)).thenReturn(true);
        when(mockResponsiveService.isTablet(0)).thenReturn(false);
        when(mockResponsiveService.isDesktop(0)).thenReturn(false);
        when(mockResponsiveService.getGridColumns(0)).thenReturn(2);

        expect(viewModel.isMobile, isTrue);
        expect(viewModel.isTablet, isFalse);
        expect(viewModel.isDesktop, isFalse);
        expect(viewModel.gridColumns, equals(2));
        expect(viewModel.deviceType, equals('mobile'));
      });
    });

    group('Screen Width Updates', () {
      test('should update screen width and notify listeners', () {
        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        viewModel.updateScreenWidth(800);

        expect(viewModel.screenWidth, equals(800));
        expect(viewModel.isInitialized, isTrue);
        expect(listenerCalled, isTrue);
      });

      test('should not notify listeners when setting same width', () {
        viewModel.updateScreenWidth(800);

        int listenerCallCount = 0;
        viewModel.addListener(() {
          listenerCallCount++;
        });

        // Set the same width again
        viewModel.updateScreenWidth(800);

        expect(listenerCallCount, equals(0));
      });

      test('should notify listeners when width changes', () {
        viewModel.updateScreenWidth(800);

        int listenerCallCount = 0;
        viewModel.addListener(() {
          listenerCallCount++;
        });

        viewModel.updateScreenWidth(1200);

        expect(listenerCallCount, equals(1));
        expect(viewModel.screenWidth, equals(1200));
      });
    });

    group('Mobile Device Detection', () {
      test('should return mobile properties for mobile width', () {
        const mobileWidth = 400.0;

        when(mockResponsiveService.isMobile(mobileWidth)).thenReturn(true);
        when(mockResponsiveService.isTablet(mobileWidth)).thenReturn(false);
        when(mockResponsiveService.isDesktop(mobileWidth)).thenReturn(false);
        when(mockResponsiveService.getGridColumns(mobileWidth)).thenReturn(2);

        viewModel.updateScreenWidth(mobileWidth);

        expect(viewModel.isMobile, isTrue);
        expect(viewModel.isTablet, isFalse);
        expect(viewModel.isDesktop, isFalse);
        expect(viewModel.gridColumns, equals(2));
        expect(viewModel.deviceType, equals('mobile'));
        expect(viewModel.shouldShowNavigationRail, isFalse);
        expect(viewModel.shouldShowNavigationDrawer, isTrue);
        expect(viewModel.maxCrossAxisExtent, equals(mobileWidth / 2));
      });
    });

    group('Tablet Device Detection', () {
      test('should return tablet properties for tablet width', () {
        const tabletWidth = 800.0;

        when(mockResponsiveService.isMobile(tabletWidth)).thenReturn(false);
        when(mockResponsiveService.isTablet(tabletWidth)).thenReturn(true);
        when(mockResponsiveService.isDesktop(tabletWidth)).thenReturn(false);
        when(mockResponsiveService.getGridColumns(tabletWidth)).thenReturn(4);

        viewModel.updateScreenWidth(tabletWidth);

        expect(viewModel.isMobile, isFalse);
        expect(viewModel.isTablet, isTrue);
        expect(viewModel.isDesktop, isFalse);
        expect(viewModel.gridColumns, equals(4));
        expect(viewModel.deviceType, equals('tablet'));
        expect(viewModel.shouldShowNavigationRail, isTrue);
        expect(viewModel.shouldShowNavigationDrawer, isFalse);
        expect(viewModel.maxCrossAxisExtent, equals(tabletWidth / 4));
      });
    });

    group('Desktop Device Detection', () {
      test('should return desktop properties for desktop width', () {
        const desktopWidth = 1200.0;

        when(mockResponsiveService.isMobile(desktopWidth)).thenReturn(false);
        when(mockResponsiveService.isTablet(desktopWidth)).thenReturn(false);
        when(mockResponsiveService.isDesktop(desktopWidth)).thenReturn(true);
        when(mockResponsiveService.getGridColumns(desktopWidth)).thenReturn(6);

        viewModel.updateScreenWidth(desktopWidth);

        expect(viewModel.isMobile, isFalse);
        expect(viewModel.isTablet, isFalse);
        expect(viewModel.isDesktop, isTrue);
        expect(viewModel.gridColumns, equals(6));
        expect(viewModel.deviceType, equals('desktop'));
        expect(viewModel.shouldShowNavigationRail, isTrue);
        expect(viewModel.shouldShowNavigationDrawer, isFalse);
        expect(viewModel.maxCrossAxisExtent, equals(desktopWidth / 6));
      });
    });

    group('Grid Calculations', () {
      test(
        'should calculate correct max cross axis extent for different screen sizes',
        () {
          // Mobile
          when(mockResponsiveService.isMobile(400)).thenReturn(true);
          when(mockResponsiveService.isTablet(400)).thenReturn(false);
          when(mockResponsiveService.isDesktop(400)).thenReturn(false);
          viewModel.updateScreenWidth(400);
          expect(viewModel.maxCrossAxisExtent, equals(200)); // 400 / 2

          // Tablet
          when(mockResponsiveService.isMobile(800)).thenReturn(false);
          when(mockResponsiveService.isTablet(800)).thenReturn(true);
          when(mockResponsiveService.isDesktop(800)).thenReturn(false);
          viewModel.updateScreenWidth(800);
          expect(viewModel.maxCrossAxisExtent, equals(200)); // 800 / 4

          // Desktop
          when(mockResponsiveService.isMobile(1200)).thenReturn(false);
          when(mockResponsiveService.isTablet(1200)).thenReturn(false);
          when(mockResponsiveService.isDesktop(1200)).thenReturn(true);
          viewModel.updateScreenWidth(1200);
          expect(viewModel.maxCrossAxisExtent, equals(200)); // 1200 / 6
        },
      );

      test('should delegate grid column calculation to service', () {
        const testWidth = 1000.0;
        const expectedColumns = 5;

        when(
          mockResponsiveService.getGridColumns(testWidth),
        ).thenReturn(expectedColumns);

        viewModel.updateScreenWidth(testWidth);

        expect(viewModel.gridColumns, equals(expectedColumns));
        verify(mockResponsiveService.getGridColumns(testWidth)).called(1);
      });
    });

    group('Navigation UI Helpers', () {
      test('should show navigation rail for tablet and desktop', () {
        // Setup for tablet
        when(mockResponsiveService.isMobile(800)).thenReturn(false);
        when(mockResponsiveService.isTablet(800)).thenReturn(true);
        when(mockResponsiveService.isDesktop(800)).thenReturn(false);

        viewModel.updateScreenWidth(800);
        expect(viewModel.shouldShowNavigationRail, isTrue);
        expect(viewModel.shouldShowNavigationDrawer, isFalse);

        // Setup for desktop
        when(mockResponsiveService.isMobile(1200)).thenReturn(false);
        when(mockResponsiveService.isTablet(1200)).thenReturn(false);
        when(mockResponsiveService.isDesktop(1200)).thenReturn(true);

        viewModel.updateScreenWidth(1200);
        expect(viewModel.shouldShowNavigationRail, isTrue);
        expect(viewModel.shouldShowNavigationDrawer, isFalse);
      });

      test('should show navigation drawer for mobile', () {
        when(mockResponsiveService.isMobile(400)).thenReturn(true);
        when(mockResponsiveService.isTablet(400)).thenReturn(false);
        when(mockResponsiveService.isDesktop(400)).thenReturn(false);

        viewModel.updateScreenWidth(400);
        expect(viewModel.shouldShowNavigationRail, isFalse);
        expect(viewModel.shouldShowNavigationDrawer, isTrue);
      });
    });

    group('Device Type String', () {
      test('should return correct device type string', () {
        // Mobile
        when(mockResponsiveService.isMobile(400)).thenReturn(true);
        when(mockResponsiveService.isTablet(400)).thenReturn(false);
        when(mockResponsiveService.isDesktop(400)).thenReturn(false);
        viewModel.updateScreenWidth(400);
        expect(viewModel.deviceType, equals('mobile'));

        // Tablet
        when(mockResponsiveService.isMobile(800)).thenReturn(false);
        when(mockResponsiveService.isTablet(800)).thenReturn(true);
        when(mockResponsiveService.isDesktop(800)).thenReturn(false);
        viewModel.updateScreenWidth(800);
        expect(viewModel.deviceType, equals('tablet'));

        // Desktop
        when(mockResponsiveService.isMobile(1200)).thenReturn(false);
        when(mockResponsiveService.isTablet(1200)).thenReturn(false);
        when(mockResponsiveService.isDesktop(1200)).thenReturn(true);
        viewModel.updateScreenWidth(1200);
        expect(viewModel.deviceType, equals('desktop'));
      });
    });

    group('Reset Functionality', () {
      test('should reset screen width to zero and notify listeners', () {
        viewModel.updateScreenWidth(800);
        expect(viewModel.screenWidth, equals(800));
        expect(viewModel.isInitialized, isTrue);

        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        viewModel.reset();

        expect(viewModel.screenWidth, equals(0));
        expect(viewModel.isInitialized, isFalse);
        expect(listenerCalled, isTrue);
      });

      test('should not notify listeners when resetting already zero width', () {
        expect(viewModel.screenWidth, equals(0));

        int listenerCallCount = 0;
        viewModel.addListener(() {
          listenerCallCount++;
        });

        viewModel.reset();

        expect(listenerCallCount, equals(0));
      });
    });

    group('Service Integration', () {
      test('should call responsive service methods with correct width', () {
        const testWidth = 950.0;

        // Setup mock responses
        when(mockResponsiveService.isMobile(testWidth)).thenReturn(false);
        when(mockResponsiveService.isTablet(testWidth)).thenReturn(true);
        when(mockResponsiveService.isDesktop(testWidth)).thenReturn(false);
        when(mockResponsiveService.getGridColumns(testWidth)).thenReturn(4);

        viewModel.updateScreenWidth(testWidth);

        // Access all properties to trigger service calls
        viewModel.isMobile;
        viewModel.isTablet;
        viewModel.isDesktop;
        viewModel.gridColumns;

        verify(mockResponsiveService.isMobile(testWidth)).called(1);
        verify(mockResponsiveService.isTablet(testWidth)).called(1);
        verify(mockResponsiveService.isDesktop(testWidth)).called(1);
        verify(mockResponsiveService.getGridColumns(testWidth)).called(1);
      });
    });

    group('Listener Management', () {
      test('should properly manage listeners', () {
        int listenerCallCount = 0;
        void listener() {
          listenerCallCount++;
        }

        viewModel.addListener(listener);
        viewModel.updateScreenWidth(800);
        expect(listenerCallCount, equals(1));

        viewModel.removeListener(listener);
        viewModel.updateScreenWidth(1200);
        expect(listenerCallCount, equals(1)); // Should not increase
      });
    });
  });
}
