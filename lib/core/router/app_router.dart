import 'package:flutter/material.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/otp_screen.dart';
import '../../features/home/screens/home_screen.dart';
// import '../../features/vehicles/vehicles_screen.dart';
// import '../../features/vehicles/add_vehicle_screen.dart';
import '../../features/plans/screens/plans_screen.dart';
import '../../features/booking/screens/book_slot_screen.dart';
import '../../features/booking/screens/checkout_screen.dart';
import '../../features/booking/screens/payment_screen.dart';
import '../../features/booking/screens/order_success_screen.dart';
import '../../features/inspection/screens/inspection_screen.dart';
import '../../features/inspection/screens/inspection_done_screen.dart';
// import '../../features/profile/profile_screen.dart';
// import '../../features/profile/edit_profile_screen.dart';
// import '../../features/profile/invoices_screen.dart';

class AppRouter {
  static const String login = '/login';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String vehicles = '/vehicles';
  static const String addVehicle = '/add-vehicle';
  static const String plans = '/plans';
  static const String bookSlot = '/book-slot';
  static const String checkout = '/checkout';
  static const String payment = '/payment';
  static const String orderSuccess = '/order-success';
  static const String inspection = '/inspection';
  static const String inspectionDone = '/inspection-done';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String invoices = '/invoices';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case otp:
        return MaterialPageRoute(
          builder: (_) => const OtpScreen(phone: '1234567890'),
        );
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      // case vehicles:
      //   return MaterialPageRoute(builder: (_) => const VehiclesScreen());
      // case addVehicle:
      //   return MaterialPageRoute(builder: (_) => const AddVehicleScreen());
      case plans:
        return MaterialPageRoute(builder: (_) => const PlansScreen());
      case bookSlot:
        return MaterialPageRoute(builder: (_) => const BookSlotScreen());
      case checkout:
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => CheckoutScreen(
            day: args["day"],
            date: args["date"],
            time: args["time"],
          ),
        );
      case payment:
        return MaterialPageRoute(builder: (_) => const PaymentScreen());
      case orderSuccess:
        return MaterialPageRoute(builder: (_) => const OrderSuccessScreen());
      case inspection:
        return MaterialPageRoute(builder: (_) => const InspectionScreen());
      case inspectionDone:
        return MaterialPageRoute(builder: (_) => const InspectionDoneScreen());
      // case profile:
      //   return MaterialPageRoute(builder: (_) => const ProfileScreen());
      // case editProfile:
      //   return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      // case invoices:
      //   return MaterialPageRoute(builder: (_) => const InvoicesScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
