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
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'providers/auth_provider.dart';
import 'providers/vehicle_provider.dart';
import 'providers/plan_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/inspection_provider.dart';
import 'providers/otp_provider.dart';

Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(" Background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  runApp(const AutozyApp());
}

class AutozyApp extends StatefulWidget {
  const AutozyApp({super.key});

  @override
  State<AutozyApp> createState() => _AutozyAppState();
}

class _AutozyAppState extends State<AutozyApp> {
  @override
  void initState() {
    super.initState();
    setupFCM();
  }

  void setupFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print(" Permission: ${settings.authorizationStatus}");

    String? token = await messaging.getToken();
    print(" FCM TOKEN  $token");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(" Foreground message: ${message.notification?.title}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(" Notification clicked!");
    });
  }

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
        title: 'Autozy',
        debugShowCheckedModeBanner: false,
        routerConfig: AppGoRouter.router,

        ///  THEME
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
