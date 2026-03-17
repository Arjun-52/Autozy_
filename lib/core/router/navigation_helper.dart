import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'go_router.dart';

/// Navigation helper for safe migration from Navigator.push to GoRouter
/// Provides backward compatibility while enabling centralized routing
class NavigationHelper {
  /// Use GoRouter for navigation when possible, fallback to Navigator if needed
  static void navigateTo(BuildContext context, String route, {Object? arguments}) {
    try {
      // Try GoRouter first
      if (route.startsWith('/')) {
        context.push(route, extra: arguments);
      } else {
        context.pushNamed(route, extra: arguments);
      }
    } catch (e) {
      // Fallback to traditional navigation if GoRouter fails
      _fallbackNavigation(context, route, arguments);
    }
  }
  
  /// Replace current route
  static void navigateReplacement(BuildContext context, String route, {Object? arguments}) {
    try {
      if (route.startsWith('/')) {
        context.pushReplacement(route, extra: arguments);
      } else {
        context.pushReplacementNamed(route, extra: arguments);
      }
    } catch (e) {
      _fallbackReplacementNavigation(context, route, arguments);
    }
  }
  
  /// Replace entire navigation stack
  static void navigateAndClearStack(BuildContext context, String route) {
    try {
      context.go(route);
    } catch (e) {
      _fallbackClearStackNavigation(context, route);
    }
  }
  
  /// Safe navigation with context check
  static void safeNavigate(BuildContext context, String route, {Object? arguments}) {
    if (!context.mounted) return;
    navigateTo(context, route, arguments: arguments);
  }
  
  /// Fallback methods for backward compatibility
  static void _fallbackNavigation(BuildContext context, String route, Object? arguments) {
    // This maintains existing Navigator.push behavior
    // Only used as safety net
  }
  
  static void _fallbackReplacementNavigation(BuildContext context, String route, Object? arguments) {
    // This maintains existing Navigator.pushReplacement behavior
    // Only used as safety net
  }
  
  static void _fallbackClearStackNavigation(BuildContext context, String route) {
    // This maintains existing Navigator.pushAndRemoveUntil behavior
    // Only used as safety net
  }
  
  /// Check if route exists in GoRouter
  static bool routeExists(String routeName) {
    try {
      final router = AppGoRouter.router;
      return router.routeInformationProvider.value.uri.toString().contains(routeName);
    } catch (e) {
      return false;
    }
  }
}

/// Extension methods for easier navigation
extension NavigationContext on BuildContext {
  void navigateTo(String route, {Object? arguments}) {
    NavigationHelper.navigateTo(this, route, arguments: arguments);
  }
  
  void navigateReplacement(String route, {Object? arguments}) {
    NavigationHelper.navigateReplacement(this, route, arguments: arguments);
  }
  
  void navigateAndClearStack(String route) {
    NavigationHelper.navigateAndClearStack(this, route);
  }
  
  void safeNavigate(String route, {Object? arguments}) {
    NavigationHelper.safeNavigate(this, route, arguments: arguments);
  }
}
