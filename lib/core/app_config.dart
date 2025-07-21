/// Application configuration constants
/// Contains app-wide configuration values and settings
class AppConfig {
  /// Application name
  static const String appName = 'Flutter Responsive Template';

  /// Application version
  static const String appVersion = '1.0.0';

  /// Default theme mode
  static const String defaultThemeMode = 'system';

  /// Debug mode flag
  static const bool isDebugMode = true;

  /// Navigation configuration
  static const String defaultRoute = '/home';
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';
  static const String settingsRoute = '/settings';
  static const String aboutRoute = '/about';

  /// Private constructor to prevent instantiation
  AppConfig._();
}
