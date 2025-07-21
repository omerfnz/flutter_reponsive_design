import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reponsive_design/core/service_locator.dart';
import 'package:reponsive_design/interfaces/i_responsive_service.dart';
import 'package:reponsive_design/interfaces/i_navigation_service.dart';
import 'package:reponsive_design/interfaces/i_content_service.dart';
import 'package:reponsive_design/viewmodels/responsive_viewmodel.dart';
import 'package:reponsive_design/viewmodels/navigation_viewmodel.dart';
import 'package:reponsive_design/viewmodels/content_viewmodel.dart';
import 'package:reponsive_design/views/responsive_layout_view.dart';
import 'package:reponsive_design/views/main_content_view.dart';

void main() {
  group('App Integration Tests', () {
    setUp(() {
      ServiceLocator.setup();
    });

    tearDown(() {
      ServiceLocator.reset();
    });

    group('Service Integration', () {
      testWidgets('should integrate all services with ViewModels', (
        tester,
      ) async {
        // Arrange
        final responsiveService = ServiceLocator.get<IResponsiveService>();
        final navigationService = ServiceLocator.get<INavigationService>();
        final contentService = ServiceLocator.get<IContentService>();

        final responsiveViewModel = ResponsiveViewModel(responsiveService);
        final navigationViewModel = NavigationViewModel(navigationService);
        final contentViewModel = ContentViewModel(contentService);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: responsiveViewModel),
                ChangeNotifierProvider.value(value: navigationViewModel),
                ChangeNotifierProvider.value(value: contentViewModel),
              ],
              child: const ResponsiveLayoutView(child: MainContentView()),
            ),
          ),
        );

        // Assert
        expect(find.byType(ResponsiveLayoutView), findsOneWidget);
        expect(find.byType(MainContentView), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('should handle responsive layout changes', (tester) async {
        // Arrange
        final responsiveService = ServiceLocator.get<IResponsiveService>();
        final navigationService = ServiceLocator.get<INavigationService>();
        final contentService = ServiceLocator.get<IContentService>();

        final responsiveViewModel = ResponsiveViewModel(responsiveService);
        final navigationViewModel = NavigationViewModel(navigationService);
        final contentViewModel = ContentViewModel(contentService);

        Widget createApp() {
          return MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: responsiveViewModel),
                ChangeNotifierProvider.value(value: navigationViewModel),
                ChangeNotifierProvider.value(value: contentViewModel),
              ],
              child: const ResponsiveLayoutView(child: MainContentView()),
            ),
          );
        }

        // Test mobile layout
        await tester.binding.setSurfaceSize(const Size(400, 600));
        await tester.pumpWidget(createApp());
        await tester.pumpAndSettle();

        expect(responsiveViewModel.isMobile, isTrue);
        expect(find.byType(Drawer), findsOneWidget);

        // Test tablet layout
        await tester.binding.setSurfaceSize(const Size(800, 600));
        await tester.pumpWidget(createApp());
        await tester.pumpAndSettle();

        expect(responsiveViewModel.isTablet, isTrue);

        // Test desktop layout
        await tester.binding.setSurfaceSize(const Size(1200, 800));
        await tester.pumpWidget(createApp());
        await tester.pumpAndSettle();

        expect(responsiveViewModel.isDesktop, isTrue);

        // Reset to default size
        await tester.binding.setSurfaceSize(null);
      });

      testWidgets('should handle navigation flow', (tester) async {
        // Arrange
        final responsiveService = ServiceLocator.get<IResponsiveService>();
        final navigationService = ServiceLocator.get<INavigationService>();
        final contentService = ServiceLocator.get<IContentService>();

        final responsiveViewModel = ResponsiveViewModel(responsiveService);
        final navigationViewModel = NavigationViewModel(navigationService);
        final contentViewModel = ContentViewModel(contentService);

        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: responsiveViewModel),
                ChangeNotifierProvider.value(value: navigationViewModel),
                ChangeNotifierProvider.value(value: contentViewModel),
              ],
              child: const ResponsiveLayoutView(child: MainContentView()),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Navigate to different routes
        final navigationItems = navigationService.getNavigationItems();

        for (final item in navigationItems) {
          navigationViewModel.selectItem(item);
          contentViewModel.updateRoute(item.route);
          await tester.pumpAndSettle();

          // Assert
          expect(navigationViewModel.selectedItem, equals(item));
          expect(contentViewModel.currentRoute, equals(item.route));
        }
      });
    });

    group('Error Handling Integration', () {
      testWidgets('should handle service errors gracefully', (tester) async {
        // This test ensures that the app doesn't crash when services encounter errors
        final responsiveService = ServiceLocator.get<IResponsiveService>();
        final navigationService = ServiceLocator.get<INavigationService>();
        final contentService = ServiceLocator.get<IContentService>();

        final responsiveViewModel = ResponsiveViewModel(responsiveService);
        final navigationViewModel = NavigationViewModel(navigationService);
        final contentViewModel = ContentViewModel(contentService);

        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: responsiveViewModel),
                ChangeNotifierProvider.value(value: navigationViewModel),
                ChangeNotifierProvider.value(value: contentViewModel),
              ],
              child: const ResponsiveLayoutView(child: MainContentView()),
            ),
          ),
        );

        // Act - Try to navigate to invalid route
        contentViewModel.updateRoute('/invalid-route');
        await tester.pumpAndSettle();

        // Assert - App should still be functional
        expect(find.byType(ResponsiveLayoutView), findsOneWidget);
        expect(find.byType(MainContentView), findsOneWidget);
      });

      testWidgets('should handle extreme screen sizes', (tester) async {
        final responsiveService = ServiceLocator.get<IResponsiveService>();
        final navigationService = ServiceLocator.get<INavigationService>();
        final contentService = ServiceLocator.get<IContentService>();

        final responsiveViewModel = ResponsiveViewModel(responsiveService);
        final navigationViewModel = NavigationViewModel(navigationService);
        final contentViewModel = ContentViewModel(contentService);

        Widget createApp() {
          return MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: responsiveViewModel),
                ChangeNotifierProvider.value(value: navigationViewModel),
                ChangeNotifierProvider.value(value: contentViewModel),
              ],
              child: const ResponsiveLayoutView(child: MainContentView()),
            ),
          );
        }

        // Test very small screen
        await tester.binding.setSurfaceSize(const Size(200, 300));
        await tester.pumpWidget(createApp());
        await tester.pumpAndSettle();
        expect(find.byType(ResponsiveLayoutView), findsOneWidget);

        // Test very large screen
        await tester.binding.setSurfaceSize(const Size(2000, 1500));
        await tester.pumpWidget(createApp());
        await tester.pumpAndSettle();
        expect(find.byType(ResponsiveLayoutView), findsOneWidget);

        // Reset to default size
        await tester.binding.setSurfaceSize(null);
      });
    });

    group('Performance Integration', () {
      testWidgets('should handle rapid navigation changes', (tester) async {
        final responsiveService = ServiceLocator.get<IResponsiveService>();
        final navigationService = ServiceLocator.get<INavigationService>();
        final contentService = ServiceLocator.get<IContentService>();

        final responsiveViewModel = ResponsiveViewModel(responsiveService);
        final navigationViewModel = NavigationViewModel(navigationService);
        final contentViewModel = ContentViewModel(contentService);

        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: responsiveViewModel),
                ChangeNotifierProvider.value(value: navigationViewModel),
                ChangeNotifierProvider.value(value: contentViewModel),
              ],
              child: const ResponsiveLayoutView(child: MainContentView()),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Rapidly change navigation
        final navigationItems = navigationService.getNavigationItems();
        final stopwatch = Stopwatch()..start();

        for (int i = 0; i < 10; i++) {
          for (final item in navigationItems) {
            navigationViewModel.selectItem(item);
            contentViewModel.updateRoute(item.route);
            await tester.pump();
          }
        }

        stopwatch.stop();

        // Assert - Should complete within reasonable time (less than 1 second)
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        expect(find.byType(ResponsiveLayoutView), findsOneWidget);
      });

      testWidgets('should handle rapid screen size changes', (tester) async {
        final responsiveService = ServiceLocator.get<IResponsiveService>();
        final navigationService = ServiceLocator.get<INavigationService>();
        final contentService = ServiceLocator.get<IContentService>();

        final responsiveViewModel = ResponsiveViewModel(responsiveService);
        final navigationViewModel = NavigationViewModel(navigationService);
        final contentViewModel = ContentViewModel(contentService);

        Widget createApp() {
          return MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: responsiveViewModel),
                ChangeNotifierProvider.value(value: navigationViewModel),
                ChangeNotifierProvider.value(value: contentViewModel),
              ],
              child: const ResponsiveLayoutView(child: MainContentView()),
            ),
          );
        }

        final sizes = [
          const Size(400, 600), // Mobile
          const Size(800, 600), // Tablet
          const Size(1200, 800), // Desktop
        ];

        final stopwatch = Stopwatch()..start();

        // Act - Rapidly change screen sizes
        for (int i = 0; i < 5; i++) {
          for (final size in sizes) {
            await tester.binding.setSurfaceSize(size);
            await tester.pumpWidget(createApp());
            await tester.pump();
          }
        }

        stopwatch.stop();

        // Assert - Should complete within reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
        expect(find.byType(ResponsiveLayoutView), findsOneWidget);

        // Reset to default size
        await tester.binding.setSurfaceSize(null);
      });
    });

    group('State Management Integration', () {
      testWidgets('should maintain state consistency across ViewModels', (
        tester,
      ) async {
        final responsiveService = ServiceLocator.get<IResponsiveService>();
        final navigationService = ServiceLocator.get<INavigationService>();
        final contentService = ServiceLocator.get<IContentService>();

        final responsiveViewModel = ResponsiveViewModel(responsiveService);
        final navigationViewModel = NavigationViewModel(navigationService);
        final contentViewModel = ContentViewModel(contentService);

        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: responsiveViewModel),
                ChangeNotifierProvider.value(value: navigationViewModel),
                ChangeNotifierProvider.value(value: contentViewModel),
              ],
              child: const ResponsiveLayoutView(child: MainContentView()),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Select navigation item
        final profileItem = navigationService.getNavigationItems().firstWhere(
          (item) => item.id == 'profile',
        );

        navigationViewModel.selectItem(profileItem);
        contentViewModel.updateRoute(profileItem.route);
        await tester.pumpAndSettle();

        // Assert - State should be consistent
        expect(navigationViewModel.selectedItem, equals(profileItem));
        expect(contentViewModel.currentRoute, equals('/profile'));
        // Test that content service can provide content for the route
        final profileContent = contentService.getContentForRoute('/profile');
        expect(profileContent, isNotNull);
      });

      testWidgets('should handle ViewModel disposal properly', (tester) async {
        final responsiveService = ServiceLocator.get<IResponsiveService>();
        final navigationService = ServiceLocator.get<INavigationService>();
        final contentService = ServiceLocator.get<IContentService>();

        final responsiveViewModel = ResponsiveViewModel(responsiveService);
        final navigationViewModel = NavigationViewModel(navigationService);
        final contentViewModel = ContentViewModel(contentService);

        await tester.pumpWidget(
          MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: responsiveViewModel),
                ChangeNotifierProvider.value(value: navigationViewModel),
                ChangeNotifierProvider.value(value: contentViewModel),
              ],
              child: const ResponsiveLayoutView(child: MainContentView()),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Remove the widget tree
        await tester.pumpWidget(const MaterialApp(home: SizedBox()));

        // Assert - Should not throw any errors
        expect(tester.takeException(), isNull);
      });
    });
  });
}
