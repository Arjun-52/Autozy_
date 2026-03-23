import 'package:autozy/features/navigation/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import '../../features/vehicles/screens/add_vehicle_screen.dart';
import '../../features/booking/screens/book_slot_screen.dart';
import '../../features/booking/screens/checkout_screen.dart';
import '../../features/booking/screens/payment_screen.dart';
import '../../features/booking/screens/order_success_screen.dart';
import '../../features/inspection/screens/inspection_screen.dart';
import '../../features/inspection/screens/inspection_done_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/invoices_screen.dart';

/// Centralized GoRouter configuration
/// Preserves all existing route behavior while providing modern navigation
class AppGoRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    routes: [
      // Authentication routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '1234567890';
          return OtpScreen(phone: phone);
        },
      ),

      // Main navigation
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) {
          final initialIndex =
              int.tryParse(state.uri.queryParameters['initialIndex'] ?? '0') ??
              0;
          final showPlanActiveCard = state.extra as bool? ?? false;
          return MainScreen(
            initialIndex: initialIndex,
            showPlanActiveCard: showPlanActiveCard,
          );
        },
        routes: [
          GoRoute(
            path: '/vehicles',
            name: 'vehicles',
            builder: (context, state) => const MainScreen(initialIndex: 1),
          ),
          GoRoute(
            path: '/plans',
            name: 'plans',
            builder: (context, state) => const MainScreen(initialIndex: 2),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const MainScreen(initialIndex: 3),
          ),
        ],
      ),

      // Vehicle routes
      GoRoute(
        path: '/add-vehicle',
        name: 'addVehicle',
        builder: (context, state) => const AddVehicleScreen(),
      ),

      // Booking flow
      GoRoute(
        path: '/book-slot',
        name: 'bookSlot',
        builder: (context, state) => const BookSlotScreen(),
      ),
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) {
          final day = state.uri.queryParameters['day'] ?? '';
          final date = state.uri.queryParameters['date'] ?? '';
          final time = state.uri.queryParameters['time'] ?? '';
          return CheckoutScreen(day: day, date: date, time: time);
        },
      ),
      GoRoute(
        path: '/payment',
        name: 'payment',
        builder: (context, state) => const PaymentScreen(),
      ),
      GoRoute(
        path: '/order-success',
        name: 'orderSuccess',
        builder: (context, state) => const OrderSuccessScreen(),
      ),

      // Inspection flow
      GoRoute(
        path: '/inspection',
        name: 'inspection',
        builder: (context, state) {
          return const MainScreen(initialIndex: 0, screen: 'inspection');
        },
      ),

      // Profile routes
      GoRoute(
        path: '/edit-profile',
        name: 'editProfile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/invoices',
        name: 'invoices',
        builder: (context, state) => const InvoicesScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri.toString()}')),
    ),
  );

  // Helper methods for safe navigation
  static void pushNamed(
    BuildContext context,
    String routeName, {
    Object? extra,
  }) {
    if (context.mounted) {
      context.pushNamed(routeName, extra: extra);
    }
  }

  static void pushReplacementNamed(
    BuildContext context,
    String routeName, {
    Object? extra,
  }) {
    if (context.mounted) {
      context.pushReplacementNamed(routeName, extra: extra);
    }
  }

  static void pushNamedAndRemoveUntil(BuildContext context, String routeName) {
    if (context.mounted) {
      context.goNamed(routeName);
    }
  }

  static void push(BuildContext context, String path, {Object? extra}) {
    if (context.mounted) {
      context.push(path, extra: extra);
    }
  }

  static void pushReplacement(
    BuildContext context,
    String path, {
    Object? extra,
  }) {
    if (context.mounted) {
      context.pushReplacement(path, extra: extra);
    }
  }
}

/// Route constants for type safety
class AppRoutes {
  static const String login = '/login';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String vehicles = '/home/vehicles';
  static const String plans = '/home/plans';
  static const String profile = '/home/profile';
  static const String addVehicle = '/add-vehicle';
  static const String bookSlot = '/book-slot';
  static const String checkout = '/checkout';
  static const String payment = '/payment';
  static const String orderSuccess = '/order-success';
  static const String inspection = '/inspection';
  static const String inspectionDone = '/inspection-done';
  static const String editProfile = '/edit-profile';
  static const String invoices = '/invoices';
}
