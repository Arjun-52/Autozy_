import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'core/services/navigation_service.dart';
import 'core/services/token_storage.dart';

import 'core/constants/colors.dart';
import 'core/router/go_router.dart';

import 'data/services/api_service.dart';
import 'data/services/auth_service.dart';

import 'data/repositories/auth_repository.dart';
import 'data/repositories/vehicle_repository.dart';
import 'data/repositories/plan_repository.dart';
import 'data/repositories/booking_repository.dart';
import 'data/repositories/inspection_repository.dart';
import 'data/repositories/area_repository.dart';
import 'data/repositories/subscription_repository.dart';
import 'data/repositories/notification_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'providers/auth_provider.dart';
import 'providers/vehicle_provider.dart';
import 'providers/plan_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/inspection_provider.dart';
import 'providers/otp_provider.dart';
import 'providers/area_provider.dart';
import 'providers/subscription_provider.dart';
import 'data/repositories/daily_service_repository.dart';
import 'providers/daily_service_provider.dart';
import 'providers/daily_calendar_provider.dart';
import 'data/repositories/addon_repository.dart';
import 'providers/addon_booking_provider.dart';
import 'providers/addon_service_provider.dart';
import 'data/repositories/ticket_repository.dart';
import 'providers/ticket_provider.dart';
import 'providers/ticket_details_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/home_provider.dart';

Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(" Background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  // Restore any persisted session before the UI starts so the splash screen
  // can route a logged-in user straight to home.
  final apiService = ApiService();
  final tokenStorage = TokenStorage();
  final savedToken = await tokenStorage.getAccessToken();
  if (savedToken != null && savedToken.isNotEmpty) {
    apiService.setAuthToken(savedToken);
  }

  runApp(AutozyApp(apiService: apiService, tokenStorage: tokenStorage));
}

class AutozyApp extends StatefulWidget {
  final ApiService apiService;
  final TokenStorage tokenStorage;

  const AutozyApp({
    super.key,
    required this.apiService,
    required this.tokenStorage,
  });

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
        Provider<ApiService>.value(value: widget.apiService),

        Provider<TokenStorage>.value(value: widget.tokenStorage),

        Provider<AuthService>(
          create: (context) => AuthService(
            context.read<ApiService>(),
            context.read<TokenStorage>(),
          ),
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
        
        Provider<AreaRepository>(
          create: (context) => AreaRepository(context.read<ApiService>()),
        ),

        Provider<SubscriptionRepository>(
          create: (context) => SubscriptionRepository(context.read<ApiService>()),
        ),

        Provider<DailyServiceRepository>(
          create: (context) => DailyServiceRepository(context.read<ApiService>()),
        ),

        Provider<AddonRepository>(
          create: (context) => AddonRepository(context.read<ApiService>()),
        ),

        Provider<TicketRepository>(
          create: (context) => TicketRepository(context.read<ApiService>()),
        ),

        Provider<NotificationRepository>(
          create: (context) => NotificationRepository(context.read<ApiService>()),
        ),

        /// PROVIDERS
        ChangeNotifierProvider<OtpProvider>(create: (_) => OtpProvider()),

        ChangeNotifierProvider<AuthProvider>(
          create: (context) {
            final apiService = context.read<ApiService>();
            final authProvider = AuthProvider(context.read<AuthRepository>());
            apiService.onSessionExpired = () {
              authProvider.handleSessionExpired();
            };
            // If we have an auth token restored from storage, try restoring the session
            if (apiService.hasToken) {
              Future.microtask(() => authProvider.restoreSession());
            }
            return authProvider;
          },
        ),
        ChangeNotifierProvider<HomeProvider>(
          create: (context) => HomeProvider(context.read<AuthRepository>()),
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
        
        ChangeNotifierProvider<AreaProvider>(
          create: (context) =>
              AreaProvider(context.read<AreaRepository>()),
        ),

        ChangeNotifierProvider<SubscriptionProvider>(
          create: (context) =>
              SubscriptionProvider(context.read<SubscriptionRepository>()),
        ),

        ChangeNotifierProvider<DailyServiceProvider>(
          create: (context) =>
              DailyServiceProvider(context.read<DailyServiceRepository>()),
        ),

        ChangeNotifierProvider<DailyCalendarProvider>(
          create: (context) =>
              DailyCalendarProvider(context.read<DailyServiceRepository>()),
        ),

        ChangeNotifierProvider<AddonBookingProvider>(
          create: (context) =>
              AddonBookingProvider(context.read<AddonRepository>()),
        ),
        ChangeNotifierProvider<AddonServiceProvider>(
          create: (context) => AddonServiceProvider(context.read<AddonRepository>()),
        ),

        ChangeNotifierProvider<TicketProvider>(
          create: (context) =>
              TicketProvider(context.read<TicketRepository>()),
        ),

        ChangeNotifierProvider<TicketDetailsProvider>(
          create: (context) =>
              TicketDetailsProvider(context.read<TicketRepository>()),
        ),

        ChangeNotifierProvider<NotificationProvider>(
          create: (context) =>
              NotificationProvider(context.read<NotificationRepository>()),
        ),
      ],

      child: GetMaterialApp.router(
        scaffoldMessengerKey: NavigationService.scaffoldMessengerKey,
        title: 'Autozy',
        debugShowCheckedModeBanner: false,
        routerDelegate: AppGoRouter.router.routerDelegate,
        routeInformationParser: AppGoRouter.router.routeInformationParser,
        routeInformationProvider: AppGoRouter.router.routeInformationProvider,

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
