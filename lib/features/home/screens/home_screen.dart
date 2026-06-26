import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/home_provider.dart';
import '../../../providers/vehicle_provider.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/dto/home_dashboard_response.dart';
import '../widgets/home_header.dart';
import '../widgets/active_plan_card.dart';
import '../widgets/vehicle_status_card.dart';
import '../widgets/addon_services_section.dart';
import '../widgets/cleaning_evidence_card.dart';
import '../widgets/premium_services_banner.dart';
import '../widgets/service_packages_section.dart';
import '../widgets/service_coverage_section.dart';
import '../widgets/why_autozy_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.showPlanActiveCard = false});
  final bool showPlanActiveCard;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().fetchDashboard();
      context.read<VehicleProvider>().fetchVehicles(page: 1, limit: 20, reset: true);
    });
  }

  Future<void> _refreshData() async {
    await context.read<HomeProvider>().fetchDashboard();
    if (mounted) {
      await context.read<VehicleProvider>().fetchVehicles(page: 1, limit: 20, reset: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final vehicleProvider = context.watch<VehicleProvider>();
    final dashboard = homeProvider.dashboardData;

    final isLoading = homeProvider.isLoading && dashboard == null;
    final hasError = homeProvider.error != null && dashboard == null;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB), // Clean premium background tint
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: const Color(0xFFFFCB2F),
          child: Builder(
            builder: (context) {
              if (isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFFCB2F),
                  ),
                );
              }

              if (hasError) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: context.screenHeight - context.h(150),
                    padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          size: 60,
                          color: Colors.redAccent,
                        ),
                        SizedBox(height: context.h(16)),
                        Text(
                          homeProvider.error ?? 'Failed to load dashboard',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: context.sp(16),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: context.h(12)),
                        Text(
                          "We encountered an error loading your data. Please pull down to refresh or tap retry.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: context.sp(13),
                            color: const Color(0xFF7E8392),
                          ),
                        ),
                        SizedBox(height: context.h(24)),
                        ElevatedButton(
                          onPressed: _refreshData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFCB2F),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: context.w(32), vertical: context.h(12)),
                          ),
                          child: Text(
                            'Retry',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: context.sp(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final activeVehicle = vehicleProvider.selectedVehicle ?? (vehicleProvider.vehicles.isNotEmpty
                  ? vehicleProvider.vehicles.first
                  : null);

              HomeSubscription? subscription;
              if (dashboard != null && activeVehicle != null) {
                for (var sub in dashboard.subscriptions) {
                  if (sub.vehicle.number == activeVehicle.vehicleNumber || sub.vehicle.id == activeVehicle.id) {
                    subscription = sub;
                    break;
                  }
                }
              }

              TodayService? todayService;
              if (dashboard != null && activeVehicle != null) {
                for (var service in dashboard.todayServices) {
                  if (service.vehicleNumber == activeVehicle.vehicleNumber) {
                    todayService = service;
                    break;
                  }
                }
              }

              return ListView(
                padding: EdgeInsets.symmetric(horizontal: context.w(20), vertical: context.h(16)),
                children: [
                  // SECTION 1: HEADER
                  const HomeHeader(),
                  SizedBox(height: context.h(24)),

                  // SECTION 2: ACTIVE SUBSCRIPTION CARD
                  ActivePlanCard(
                    subscription: subscription,
                    hasVehicle: activeVehicle != null,
                  ),

                  // SECTION 3: VEHICLE STATUS CARD
                  VehicleStatusCard(
                    vehicle: activeVehicle,
                    todayService: todayService,
                    subscription: subscription,
                  ),
                  SizedBox(height: context.h(24)),

                  // SECTION 4: ADD-ON SERVICES GRID
                  const AddonServicesSection(),
                  SizedBox(height: context.h(28)),

                  // SECTION 5: TODAY'S CLEANING EVIDENCE
                  if (activeVehicle != null && activeVehicle.status.toUpperCase() == 'APPROVED') ...[
                    CleaningEvidenceCard(todayService: todayService),
                    SizedBox(height: context.h(28)),
                  ],

                  // SECTION 6: PREMIUM SERVICES BANNER
                  const PremiumServicesBanner(),
                  SizedBox(height: context.h(28)),

                  // SECTION 7: POPULAR SERVICE PACKAGES
                  const ServicePackagesSection(),
                  SizedBox(height: context.h(28)),

                  // SECTION 8: SERVICE COVERAGE ACCORDION
                  ServiceCoverageSection(subscription: subscription),
                  SizedBox(height: context.h(28)),

                  // SECTION 9: WHY AUTOZY SECTION
                  const WhyAutozySection(),
                  SizedBox(height: context.h(32)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

