import 'package:autozy/features/booking/widgets/booking_slot_card.dart';
import 'package:autozy/features/booking/widgets/checkout_button.dart';
import 'package:autozy/features/booking/widgets/plan_details_card.dart';
import 'package:autozy/features/booking/widgets/price_breakdown_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/vehicle_provider.dart';
import '../../../providers/area_provider.dart';
import '../../../providers/plan_provider.dart';
import '../../../providers/subscription_provider.dart';
import '../../../../core/services/navigation_service.dart';

class CheckoutScreen extends StatelessWidget {
  final String day;
  final String date;
  final String time;

  const CheckoutScreen({
    super.key,
    required this.day,
    required this.date,
    required this.time,
  });

  Future<void> _handleCheckout(BuildContext context) async {
    final vehicleProvider = context.read<VehicleProvider>();
    final areaProvider = context.read<AreaProvider>();
    final planProvider = context.read<PlanProvider>();
    final subscriptionProvider = context.read<SubscriptionProvider>();

    final messenger = NavigationService.scaffoldMessengerKey.currentState;

    // Fetch vehicles dynamically if empty
    if (vehicleProvider.vehicles.isEmpty) {
      try {
        await vehicleProvider.fetchVehicles(page: 1, limit: 20, reset: true);
      } catch (e) {
        messenger?.showSnackBar(
          SnackBar(content: Text('Failed to load vehicles: $e')),
        );
        return;
      }
    }

    final vehicle = vehicleProvider.vehicles.isNotEmpty ? vehicleProvider.vehicles.first : null;
    final vehicleId = vehicle?.id;
    final areaId = areaProvider.selectedArea?.id;
    final slotType = subscriptionProvider.selectedSlotType ?? 'MORNING';

    if (vehicle == null || vehicleId == null) {
      messenger?.showSnackBar(
        const SnackBar(content: Text('Please select or add a vehicle first')),
      );
      return;
    }


    if (areaId == null) {
      messenger?.showSnackBar(
        const SnackBar(content: Text('Please select a service area first')),
      );
      return;
    }

    final selectedPlan = planProvider.selectedPlan;
    if (selectedPlan == null) {
      messenger?.showSnackBar(
        const SnackBar(content: Text('Please select a subscription plan first')),
      );
      return;
    }

    // Fetch pricings dynamically
    if (planProvider.pricings.isEmpty) {
      try {
        await planProvider.fetchPricing();
      } catch (e) {
        messenger?.showSnackBar(
          SnackBar(content: Text('Failed to load plan pricing list: $e')),
        );
        return;
      }
    }

    final planPricingId = planProvider.getPricingIdForPlanAndVehicle(
      planId: selectedPlan.id,
      vehicleSize: vehicle.sizeCategory,
      areaId: areaId,
      cityId: areaProvider.selectedArea?.cityId,
    );

    if (planPricingId == null) {
      messenger?.showSnackBar(
        SnackBar(content: Text('No pricing found for ${selectedPlan.name} with ${vehicle.brand} ${vehicle.model} (${vehicle.sizeCategory})')),
      );
      return;
    }

    final router = GoRouter.of(context);

    final subscription = await subscriptionProvider.createSubscription(
      vehicleId: vehicleId,
      areaId: areaId,
      planPricingId: planPricingId,
      slotType: slotType,
    );

    if (subscription != null) {
      if (subscription.status == 'PENDING_INSPECTION') {
        messenger?.showSnackBar(
          const SnackBar(content: Text('Subscription created successfully. Inspection pending.')),
        );
      } else {
        messenger?.showSnackBar(
          const SnackBar(content: Text('Subscription created successfully.')),
        );
      }
      router.pushNamed('payment');
    } else {
      final errorMsg = subscriptionProvider.error ?? 'Something went wrong';
      messenger?.showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),

      appBar: AppBar(
        title: const Text("Checkout", style: TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: Column(
        children: [
          /// MAIN CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),

              child: Column(
                children: [
                  BookingSlotCard(day: day, date: date, time: time),

                  const SizedBox(height: 20),

                  const PlanDetailsCard(),

                  const SizedBox(height: 20),

                  const PriceBreakdownCard(),
                ],
              ),
            ),
          ),

          CheckoutButton(onPressed: () => _handleCheckout(context)),
        ],
      ),
    );
  }
}
