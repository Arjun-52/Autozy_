import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/colors.dart';
import 'core/router/go_router.dart';

import 'data/services/api_service.dart';
import 'data/services/auth_service.dart';

import 'data/repositories/auth_repository.dart';
import 'data/repositories/vehicle_repository.dart';
import 'data/repositories/plan_repository.dart';
import 'data/repositories/booking_repository.dart';
import 'data/repositories/inspection_repository.dart';

import 'providers/auth_provider.dart';
import 'providers/vehicle_provider.dart';
import 'providers/plan_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/inspection_provider.dart';
import 'providers/otp_provider.dart';

void main() {
  runApp(const AutozyApp());
}

class AutozyApp extends StatelessWidget {
  const AutozyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// SERVICES
        Provider<ApiService>(create: (_) => ApiService()),

        Provider<AuthService>(
          create: (context) => AuthService(context.read<ApiService>()),
        ),

        /// REPOSITORIES
        Provider<AuthRepository>(
          create: (context) => AuthRepository(context.read<AuthService>()),
        ),

        Provider<VehicleRepository>(
          create: (context) => VehicleRepository(context.read<ApiService>()),
        ),

        Provider<PlanRepository>(
          create: (context) => PlanRepository(context.read<ApiService>()),
        ),

        Provider<BookingRepository>(
          create: (context) => BookingRepository(context.read<ApiService>()),
        ),

        Provider<InspectionRepository>(
          create: (context) => InspectionRepository(context.read<ApiService>()),
        ),

        /// PROVIDERS
        ChangeNotifierProvider<OtpProvider>(create: (_) => OtpProvider()),

        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(context.read<AuthRepository>()),
        ),

        ChangeNotifierProvider<VehicleProvider>(
          create: (context) =>
              VehicleProvider(context.read<VehicleRepository>()),
        ),

        ChangeNotifierProvider<PlanProvider>(
          create: (context) => PlanProvider(context.read<PlanRepository>()),
        ),

        ChangeNotifierProvider<BookingProvider>(
          create: (context) =>
              BookingProvider(context.read<BookingRepository>()),
        ),

        ChangeNotifierProvider<InspectionProvider>(
          create: (context) =>
              InspectionProvider(context.read<InspectionRepository>()),
        ),
      ],

      child: MaterialApp.router(
        // ✅ FIXED
        title: 'Autozy',
        debugShowCheckedModeBanner: false,

        routerConfig: AppGoRouter.router, // ✅ Correct usage
        /// APP THEME
        theme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,

          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.background,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
            titleTextStyle: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: AppColors.brandOrange,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
