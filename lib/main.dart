import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/service_locator.dart';
import 'core/app_config.dart';
import 'viewmodels/responsive_viewmodel.dart';
import 'viewmodels/navigation_viewmodel.dart';
import 'viewmodels/content_viewmodel.dart';
import 'interfaces/i_responsive_service.dart';
import 'interfaces/i_navigation_service.dart';
import 'interfaces/i_content_service.dart';
import 'views/responsive_layout_view.dart';
import 'views/main_content_view.dart';

/// Main entry point of the Flutter Responsive Template application
/// Sets up dependency injection and initializes the app with Provider state management
void main() {
  // Initialize dependency injection
  ServiceLocator.registerServices();

  runApp(const ResponsiveTemplateApp());
}

/// Root application widget
/// Configures the MaterialApp with responsive template settings and Provider setup
class ResponsiveTemplateApp extends StatelessWidget {
  const ResponsiveTemplateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Responsive ViewModel for screen size management
        ChangeNotifierProvider<ResponsiveViewModel>(
          create:
              (_) =>
                  ResponsiveViewModel(ServiceLocator.get<IResponsiveService>()),
        ),

        // Navigation ViewModel for navigation state management
        ChangeNotifierProvider<NavigationViewModel>(
          create:
              (_) =>
                  NavigationViewModel(ServiceLocator.get<INavigationService>()),
        ),

        // Content ViewModel for content state management
        ChangeNotifierProvider<ContentViewModel>(
          create:
              (_) => ContentViewModel(ServiceLocator.get<IContentService>()),
        ),
      ],
      child: const _AppWithNavigationListener(),
    );
  }
}

/// Widget that listens to navigation changes and updates content accordingly
class _AppWithNavigationListener extends StatefulWidget {
  const _AppWithNavigationListener();

  @override
  State<_AppWithNavigationListener> createState() =>
      _AppWithNavigationListenerState();
}

class _AppWithNavigationListenerState
    extends State<_AppWithNavigationListener> {
  @override
  void initState() {
    super.initState();

    // Initialize with home route after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final contentViewModel = Provider.of<ContentViewModel>(
        context,
        listen: false,
      );
      final navigationViewModel = Provider.of<NavigationViewModel>(
        context,
        listen: false,
      );

      // Set initial content route
      contentViewModel.updateRoute('/home');

      // Select the first navigation item by default
      final items = navigationViewModel.navigationItems;
      if (items.isNotEmpty) {
        navigationViewModel.selectItem(items.first);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationViewModel>(
      builder: (context, navigation, child) {
        // Listen to navigation changes and update content
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final contentViewModel = Provider.of<ContentViewModel>(
            context,
            listen: false,
          );
          final selectedItem = navigation.selectedItem;

          if (selectedItem != null &&
              contentViewModel.currentRoute != selectedItem.route) {
            contentViewModel.updateRoute(selectedItem.route);
          }
        });

        return MaterialApp(
          title: AppConfig.appName,
          debugShowCheckedModeBanner: false,
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          themeMode: ThemeMode.system,
          home: const ResponsiveLayoutView(
            title: AppConfig.appName,
            child: MainContentView(),
          ),
        );
      },
    );
  }

  /// Builds the light theme configuration
  ThemeData _buildLightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 1),
      navigationRailTheme: const NavigationRailThemeData(
        selectedIconTheme: IconThemeData(size: 24),
        unselectedIconTheme: IconThemeData(size: 20),
        selectedLabelTextStyle: TextStyle(fontWeight: FontWeight.w600),
        minWidth: 72,
        minExtendedWidth: 200,
      ),
      drawerTheme: const DrawerThemeData(elevation: 2),
    );
  }

  /// Builds the dark theme configuration
  ThemeData _buildDarkTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 1),
      navigationRailTheme: const NavigationRailThemeData(
        selectedIconTheme: IconThemeData(size: 24),
        unselectedIconTheme: IconThemeData(size: 20),
        selectedLabelTextStyle: TextStyle(fontWeight: FontWeight.w600),
        minWidth: 72,
        minExtendedWidth: 200,
      ),
      drawerTheme: const DrawerThemeData(elevation: 2),
    );
  }
}
