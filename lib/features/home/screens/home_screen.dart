import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/home_provider.dart';
import '../../../providers/vehicle_provider.dart';
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
                    height: MediaQuery.of(context).size.height - 150,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          size: 60,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          homeProvider.error ?? 'Failed to load dashboard',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "We encountered an error loading your data. Please pull down to refresh or tap retry.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF7E8392),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _refreshData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFCB2F),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          ),
                          child: const Text(
                            'Retry',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final subscription = (dashboard != null && dashboard.subscriptions.isNotEmpty)
                  ? dashboard.subscriptions.first
                  : null;

              final vehicle = vehicleProvider.vehicles.isNotEmpty
                  ? vehicleProvider.vehicles.first
                  : null;

              final todayService = (dashboard != null && dashboard.todayServices.isNotEmpty)
                  ? dashboard.todayServices.first
                  : null;

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  // SECTION 1: HEADER
                  const HomeHeader(),
                  const SizedBox(height: 24),

                  // SECTION 2: ACTIVE SUBSCRIPTION CARD
                  ActivePlanCard(
                    subscription: subscription,
                    hasVehicle: vehicle != null,
                  ),

                  // SECTION 3: VEHICLE STATUS CARD
                  VehicleStatusCard(
                    vehicle: vehicle,
                    todayService: todayService,
                    subscription: subscription,
                  ),
                  const SizedBox(height: 16),

                  // SECTION 4: ADD-ON SERVICES GRID
                  const AddonServicesSection(),
                  const SizedBox(height: 24),

                  // SECTION 5: TODAY'S CLEANING EVIDENCE
                  if (vehicle != null && vehicle.status.toUpperCase() == 'APPROVED') ...[
                    CleaningEvidenceCard(todayService: todayService),
                    const SizedBox(height: 16),
                  ],

                  // SECTION 6: PREMIUM SERVICES BANNER
                  const PremiumServicesBanner(),
                  const SizedBox(height: 16),

                  // SECTION 7: POPULAR SERVICE PACKAGES
                  const ServicePackagesSection(),
                  const SizedBox(height: 24),

                  // SECTION 8: SERVICE COVERAGE ACCORDION
                  ServiceCoverageSection(subscription: subscription),
                  const SizedBox(height: 16),

                  // SECTION 9: WHY AUTOZY SECTION
                  const WhyAutozySection(),
                  const SizedBox(height: 32),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
