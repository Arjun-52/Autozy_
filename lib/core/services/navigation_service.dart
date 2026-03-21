import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/go_router.dart';

/// Centralized navigation service to replace direct Navigator calls
/// Provides type-safe navigation with GoRouter
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Navigate to a named route
  static void navigateToNamed(
    BuildContext context,
    String name, {
    Object? arguments,
  }) {
    try {
      context.pushNamed(name, extra: arguments);
    } catch (e) {
      debugPrint('Navigation error: $e');
      // Fallback to traditional navigation if needed
      _fallbackNavigation(context, name, arguments, false);
    }
  }

  /// Navigate to a path
  static void navigateToPath(
    BuildContext context,
    String path, {
    Object? arguments,
  }) {
    try {
      context.push(path, extra: arguments);
    } catch (e) {
      debugPrint('Navigation error: $e');
      _fallbackNavigation(context, path, arguments, false);
    }
  }

  /// Replace current route
  static void navigateReplacementNamed(
    BuildContext context,
    String name, {
    Object? arguments,
  }) {
    try {
      context.pushReplacementNamed(name, extra: arguments);
    } catch (e) {
      debugPrint('Navigation error: $e');
      _fallbackNavigation(context, name, arguments, true);
    }
  }

  /// Replace current route with path
  static void navigateReplacementPath(
    BuildContext context,
    String path, {
    Object? arguments,
  }) {
    try {
      context.pushReplacement(path, extra: arguments);
    } catch (e) {
      debugPrint('Navigation error: $e');
      _fallbackNavigation(context, path, arguments, true);
    }
  }

  /// Clear navigation stack and navigate
  static void navigateAndClearStack(BuildContext context, String name) {
    try {
      context.goNamed(name);
    } catch (e) {
      debugPrint('Navigation error: $e');
      _fallbackNavigation(context, name, null, true);
    }
  }

  /// Clear navigation stack and navigate to path
  static void navigateAndClearStackPath(BuildContext context, String path) {
    try {
      context.go(path);
    } catch (e) {
      debugPrint('Navigation error: $e');
      _fallbackNavigation(context, path, null, true);
    }
  }

  /// Pop current route
  static void pop(BuildContext context, {Object? result}) {
    try {
      context.pop(result);
    } catch (e) {
      debugPrint('Navigation error: $e');
      Navigator.of(context).pop(result);
    }
  }

  /// Check if route exists in GoRouter
  static bool routeExists(String routeName) {
    try {
      final router = AppGoRouter.router;
      final location = router.routeInformationProvider.value.uri.toString();
      return location.contains(routeName) ||
          location.contains(routeName.toLowerCase());
    } catch (e) {
      debugPrint('Route check error: $e');
      return false;
    }
  }

  /// Fallback to traditional navigation (backward compatibility)
  static void _fallbackNavigation(
    BuildContext context,
    String route, [
    Object? extra,
    bool replace = false,
  ]) {
    if (replace) {
      Navigator.pushReplacementNamed(context, route, arguments: extra);
    } else {
      Navigator.pushNamed(context, route, arguments: extra);
    }
  }

  /// Get current route name
  static String? getCurrentRouteName(BuildContext context) {
    try {
      final router = AppGoRouter.router;
      final location = router.routeInformationProvider.value.uri.toString();
      return location.split('/').last;
    } catch (e) {
      debugPrint('Get current route error: $e');
      return null;
    }
  }
}
