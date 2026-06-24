import '../../core/services/navigation_service.dart';
import 'package:autozy/features/navigation/main_screen.dart';
import 'package:autozy/features/notification/notification_screen.dart';
import 'package:autozy/features/vehicles/screens/edit_vehicle_screen.dart';
import 'package:autozy/features/profile/screens/saved_address_screen.dart';
import 'package:autozy/features/auth/screens/area_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import 'package:autozy/features/splash/splash_screen.dart';
import '../../features/vehicles/screens/add_vehicle_screen.dart';
import '../../features/booking/screens/book_slot_screen.dart';
import '../../features/booking/screens/checkout_screen.dart';
import '../../features/booking/screens/payment_screen.dart';
import '../../features/booking/screens/order_success_screen.dart';
import '../../features/inspection/screens/inspection_done_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/invoices_screen.dart';
import '../../features/profile/screens/subscriptions_screen.dart';
import '../../features/profile/screens/subscription_details_screen.dart';
import '../../features/profile/screens/service_history_screen.dart';
import '../../features/profile/screens/service_calendar_screen.dart';
import '../../features/profile/screens/addon_bookings_screen.dart';
import '../../features/booking/screens/book_addon_screen.dart';
import '../../features/profile/screens/tickets_screen.dart';
import '../../features/profile/screens/ticket_details_screen.dart';

class AppGoRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // Splash screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

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
      GoRoute(
        path: '/select-area',
        name: 'selectArea',
        builder: (context, state) {
          final returnOnSelect = state.uri.queryParameters['return'] == 'true';
          return AreaSelectionScreen(returnOnSelect: returnOnSelect);
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
            key: ValueKey('home-$initialIndex'),
            initialIndex: initialIndex,
            showPlanActiveCard: showPlanActiveCard,
          );
        },
        routes: [
          GoRoute(
            path: 'vehicles',
            name: 'vehicles',
            builder: (context, state) =>
                const MainScreen(key: ValueKey('home-1'), initialIndex: 1),
          ),
          GoRoute(
            path: 'plans',
            name: 'plans',
            builder: (context, state) =>
                const MainScreen(key: ValueKey('home-2'), initialIndex: 2),
          ),
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) =>
                const MainScreen(key: ValueKey('home-3'), initialIndex: 3),
          ),
        ],
      ),

      // Notification route
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationScreen(),
      ),

      // Profile routes
      GoRoute(
        path: '/saved-address',
        name: 'savedAddress',
        builder: (context, state) => const SavedAddressScreen(),
      ),
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

      // Vehicle routes
      GoRoute(
        path: '/add-vehicle',
        name: 'addVehicle',
        builder: (context, state) => const AddVehicleScreen(),
      ),
      GoRoute(
        path: '/edit-vehicle/:id',
        name: 'editVehicle',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return EditVehicleScreen(vehicleId: id!);
        },
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
          // Slot details are passed via `extra` (strings contain spaces/commas).
          final extra = state.extra as Map<String, dynamic>? ?? const {};
          return CheckoutScreen(
            day: (extra['day'] as String?) ?? '',
            date: (extra['date'] as String?) ?? '',
            time: (extra['time'] as String?) ?? '',
          );
        },
      ),
      GoRoute(
        path: '/payment',
        name: 'payment',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? const {};
          return PaymentScreen(
            subscriptionId: (extra['subscriptionId'] as String?) ?? '',
            amount: (extra['amount'] as num?) ?? 0,
          );
        },
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
          return const MainScreen(
            key: ValueKey('home-inspection'),
            initialIndex: 0,
            screen: 'inspection',
          );
        },
      ),

      // Profile routes
      GoRoute(
        path: '/inspection-done',
        name: 'inspectionDone',
        builder: (context, state) => const InspectionDoneScreen(),
      ),
      GoRoute(
        path: '/subscriptions',
        name: 'subscriptions',
        builder: (context, state) => const SubscriptionsScreen(),
      ),
      GoRoute(
        path: '/subscription-details/:id',
        name: 'subscriptionDetails',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return SubscriptionDetailsScreen(subscriptionId: id);
        },
      ),
      GoRoute(
        path: '/service-history/:vehicleId',
        name: 'serviceHistory',
        builder: (context, state) {
          final vehicleId = state.pathParameters['vehicleId']!;
          return ServiceHistoryScreen(vehicleId: vehicleId);
        },
      ),
      GoRoute(
        path: '/service-calendar/:vehicleId',
        name: 'serviceCalendar',
        builder: (context, state) {
          final vehicleId = state.pathParameters['vehicleId']!;
          return ServiceCalendarScreen(vehicleId: vehicleId);
        },
      ),
      GoRoute(
        path: '/addon-bookings',
        name: 'addonBookings',
        builder: (context, state) => const AddonBookingsScreen(),
      ),
      GoRoute(
        path: '/book-addon',
        name: 'bookAddon',
        builder: (context, state) => const BookAddonScreen(),
      ),
      GoRoute(
        path: '/tickets',
        name: 'tickets',
        builder: (context, state) => const TicketsScreen(),
      ),
      GoRoute(
        path: '/ticket-details/:id',
        name: 'ticketDetails',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TicketDetailsScreen(ticketId: id);
        },
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
  static const String editVehicle = '/edit-vehicle';
  static const String bookSlot = '/book-slot';
  static const String checkout = '/checkout';
  static const String payment = '/payment';
  static const String orderSuccess = '/order-success';
  static const String inspection = '/inspection';
  static const String inspectionDone = '/inspection-done';
  static const String editProfile = '/edit-profile';
  static const String invoices = '/invoices';
  static const String notifications = '/notifications';
  static const String selectArea = '/select-area';
  static const String savedAddress = '/saved-address';
  static const String subscriptions = '/subscriptions';
  static const String serviceHistory = '/service-history';
  static const String serviceCalendar = '/service-calendar';
  static const String addonBookings = '/addon-bookings';
  static const String bookAddon = '/book-addon';
}

