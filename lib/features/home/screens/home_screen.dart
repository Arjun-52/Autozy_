import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/svg.dart';
import '../../../providers/home_provider.dart';
import '../widgets/explore_card.dart.dart';
import '../widgets/greeting_section.dart';
import '../widgets/home_header.dart';
import '../widgets/premium_services_card.dart';
import '../widgets/special_offers.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/standard_plan_active_card.dart';

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
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final dashboard = homeProvider.dashboardData;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<HomeProvider>().fetchDashboard();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: homeProvider.isLoading && dashboard == null
                ? const Center(child: CircularProgressIndicator())
                : homeProvider.error != null && dashboard == null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(homeProvider.error ?? 'An error occurred'),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => context.read<HomeProvider>().fetchDashboard(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        children: [
                          const HomeHeader(),
                          const SizedBox(height: 24),
                          const GreetingSection(),
                          const SizedBox(height: 24),
                          
                          // Active Subscriptions
                          if (dashboard != null && dashboard.subscriptions.isNotEmpty)
                            ...dashboard.subscriptions.map((sub) => GestureDetector(
                                  onTap: () {
                                    context.push('/subscription-details/${sub.id}');
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF6A800),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.check, color: Colors.white, size: 20),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${sub.plan.replaceAll('_', ' ')} (${sub.status})",
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                "Vehicle: ${sub.vehicle.brand} ${sub.vehicle.model} (${sub.vehicle.number})",
                                                style: const TextStyle(fontSize: 14, color: Colors.black87),
                                              ),
                                              Text(
                                                "Expires on: ${sub.endDate}",
                                                style: const TextStyle(fontSize: 12, color: Colors.black54),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                          else if (widget.showPlanActiveCard)
                            const StandardPlanActiveCard(),

                          // Today's Services Section
                          if (dashboard != null && dashboard.todayServices.isNotEmpty) ...[
                            const Text(
                              "Today's Services",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            ...dashboard.todayServices.map((service) => Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: const Color(0xFFE9E9E9)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Vehicle: ${service.vehicleNumber}",
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 4),
                                            Text("Status: ${service.status}"),
                                            if (service.completedAt != null)
                                              Text("Completed At: ${service.completedAt}"),
                                            if (service.photos != null)
                                              const Text("📸 Photos available"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            const SizedBox(height: 24),
                          ],

                          const VehicleCard(),
                          const SizedBox(height: 32),
                          const Text(
                            "Explore",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ExploreCard(
                                  icon: SvgPicture.asset(
                                    'assets/images/view_plans.svg',
                                    height: 24,
                                    width: 24,
                                  ),
                                  title: "View Plans",
                                  onTap: () {
                                    context.pushNamed('plans');
                                  },
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: ExploreCard(
                                  icon: const Icon(Icons.add_circle_outline),
                                  title: "Add Vehicle",
                                  onTap: () {
                                    context.pushNamed('vehicles');
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          ExploreCard(
                            icon: SvgPicture.asset(
                              'assets/images/calender.svg',
                              height: 24,
                              width: 24,
                            ),
                            title: "Book Slot",
                            onTap: () {
                              context.pushNamed('bookSlot');
                            },
                            fullWidth: true,
                          ),
                          const SizedBox(height: 24),
                          GestureDetector(
                            onTap: () {
                              context.pushNamed('bookAddon');
                            },
                            child: const PremiumServicesCard(),
                          ),
                          const SizedBox(height: 32),
                          const SpecialOffersSection(),
                          const SizedBox(height: 40),
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}
