import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../providers/plan_provider.dart';
import '../../../providers/area_provider.dart';
import '../../booking/widgets/plan_pricing.dart';
import '../widgets/plan_card.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final plan = context.read<PlanProvider>();
      plan.fetchPlans();
      // Load real pricing so the cards can show "from ₹X" instead of hardcoded
      // placeholder prices.
      if (plan.pricings.isEmpty) plan.fetchPricing();
    });
  }

  Widget _getPlanIcon(String name, bool isSelected) {
    String assetPath = 'assets/images/basic.svg';
    switch (name.toUpperCase()) {
      case 'BASIC':
        assetPath = 'assets/images/basic.svg';
        break;
      case 'STANDARD':
        assetPath = 'assets/images/Star.svg';
        break;
      case 'PREMIUM':
        assetPath = 'assets/images/ranking.svg';
        break;
      case 'REGULAR_CLEANING':
        assetPath = 'assets/images/Lightning.svg';
        break;
      case 'REGULAR_WATER_WASH':
        assetPath = 'assets/images/view_plans.svg';
        break;
      case 'INTERNAL_CLEANING':
        assetPath = 'assets/images/basic.svg';
        break;
    }
    return Center(
      child: SvgPicture.asset(
        assetPath,
        height: 20,
        width: 20,
      ),
    );
  }

  String _getCleanErrorMessage(String? error) {
    if (error == null) return '';
    final lower = error.toLowerCase();
    if (lower.contains('socketexception') || lower.contains('network') || lower.contains('failed host')) {
      return 'Unable to load plans';
    }
    if (lower.contains('401') || lower.contains('unauthorized') || lower.contains('session expired')) {
      return 'Session expired';
    }
    return 'Something went wrong';
  }

  Widget _buildEmptyState(PlanProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.assignment_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              "No Plans Available",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Subscription plans are currently unavailable.",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => provider.fetchPlans(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF4C430),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Retry", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(PlanProvider provider, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => provider.fetchPlans(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF4C430),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Retry", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final planProvider = context.watch<PlanProvider>();
    final plans = planProvider.plans;
    final isLoading = planProvider.isLoading;
    final error = planProvider.error;
    final selectedPlan = planProvider.selectedPlan;
    final cityId = context.watch<AreaProvider>().selectedArea?.cityId;

    // Auto-select first plan if selection is empty and list is not empty
    if (selectedPlan == null && plans.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && planProvider.selectedPlan == null) {
          planProvider.selectPlan(plans.first);
        }
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.goNamed('home');
          },
        ),
        title: const Text(
          "Plans",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => planProvider.refreshPlans(),
              child: () {
                if (isLoading && plans.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xffF4C430),
                    ),
                  );
                }

                if (error != null) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: _buildErrorState(planProvider, _getCleanErrorMessage(error)),
                    ),
                  );
                }

                if (plans.isEmpty) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: _buildEmptyState(planProvider),
                    ),
                  );
                }

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    final isSelected = selectedPlan?.id == plan.id;
                    final minPrice = planProvider.minPriceForPlan(plan.id, cityId: cityId);
                    final price = minPrice != null ? 'from ₹${formatPrice(minPrice)}' : '—';
                    final isPopular = plan.name.toUpperCase() == 'STANDARD';

                    // Build features map
                    final planFeatures = <Map<String, dynamic>>[
                      {
                        "title": "Washes Per Month: ${plan.features?.washesPerMonth ?? 0}",
                        "isSelected": (plan.features?.washesPerMonth ?? 0) > 0,
                      },
                      {
                        "title": "Internal Cleaning Count: ${plan.features?.internal ?? 0}",
                        "isSelected": (plan.features?.internal ?? 0) > 0,
                      },
                      {
                        "title": "Water Wash Count: ${plan.features?.waterWash ?? 0}",
                        "isSelected": (plan.features?.waterWash ?? 0) > 0,
                      },
                    ];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PlanCard(
                        title: plan.name,
                        price: price,
                        description: plan.description,
                        features: planFeatures,
                        isSelected: isSelected,
                        isPopular: isPopular,
                        icon: _getPlanIcon(plan.name, isSelected),
                        onTap: () {
                          planProvider.selectPlan(plan);
                        },
                      ),
                    );
                  },
                );
              }(),
            ),
          ),

          /// CONTINUE BUTTON
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF4C430),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: selectedPlan != null
                  ? () {
                      context.pushNamed('bookSlot');
                    }
                  : null,
              child: const Text(
                "Continue to Slot Selection",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
