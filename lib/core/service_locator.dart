import 'package:get_it/get_it.dart';
import '../interfaces/i_responsive_service.dart';
import '../interfaces/i_navigation_service.dart';
import '../interfaces/i_content_service.dart';
import '../services/responsive_service.dart';
import '../services/navigation_service.dart';
import '../services/content_service.dart';

/// Service locator for dependency injection
/// Manages registration and retrieval of service instances
class ServiceLocator {
  /// GetIt instance for dependency injection
  static final GetIt _getIt = GetIt.instance;

  /// Getter for the GetIt instance
  static GetIt get instance => _getIt;

  /// Registers all services with the service locator
  /// This method should be called during app initialization
  static void registerServices() {
    // Register services as lazy singletons
    if (!_getIt.isRegistered<IResponsiveService>()) {
      _getIt.registerLazySingleton<IResponsiveService>(
        () => const ResponsiveService(),
      );
    }

    if (!_getIt.isRegistered<INavigationService>()) {
      _getIt.registerLazySingleton<INavigationService>(
        () => const NavigationService(),
      );
    }

    if (!_getIt.isRegistered<IContentService>()) {
      _getIt.registerLazySingleton<IContentService>(
        () => const ContentService(),
      );
    }
  }

  /// Convenience method for setup - alias for registerServices
  static void setup() => registerServices();

  /// Retrieves a service instance by type
  static T get<T extends Object>() => _getIt.get<T>();

  /// Checks if a service is registered
  static bool isRegistered<T extends Object>() => _getIt.isRegistered<T>();

  /// Resets all registered services (useful for testing)
  static void reset() => _getIt.reset();
}
