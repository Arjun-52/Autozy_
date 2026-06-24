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
import '../../../data/models/dto/subscription_list_response.dart' as sub_dto;
import '../../../../core/services/navigation_service.dart';

class CheckoutScreen extends StatefulWidget {
  final String day;
  final String date;
  final String time;

  const CheckoutScreen({
    super.key,
    required this.day,
    required this.date,
    required this.time,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  /// Vehicle ids that already have a subscription (any status) — they can't be
  /// subscribed again due to the backend's one-subscription-per-vehicle rule.
  Set<String> _takenVehicleIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initBooking());
  }

  /// Loads the vehicle list + existing subscriptions and picks a sensible
  /// default vehicle (the first one that can still be subscribed).
  Future<void> _initBooking() async {
    final vehicleProvider = context.read<VehicleProvider>();
    final subscriptionProvider = context.read<SubscriptionProvider>();
    final planProvider = context.read<PlanProvider>();

    // Load pricing so the Plan Details / Price Breakdown cards can show real
    // amounts for the selected plan + vehicle size.
    if (planProvider.pricings.isEmpty) {
      try {
        await planProvider.fetchPricing();
      } catch (_) {/* non-fatal */}
    }

    try {
      await vehicleProvider.fetchVehicles(page: 1, limit: 50, reset: true);
    } catch (_) {/* shown via provider state if needed */}

    try {
      await subscriptionProvider.fetchSubscriptions(page: 1, limit: 50);
      _takenVehicleIds = subscriptionProvider.subscriptions
          .map((s) => s.vehicle?.id)
          .whereType<String>()
          .toSet();
    } catch (_) {/* non-fatal */}

    // Default selection: keep the current pick if still valid, else first
    // subscribable vehicle, else first.
    final vehicles = vehicleProvider.vehicles;
    final current = vehicleProvider.selectedVehicle;
    final stillValid = current != null && vehicles.any((v) => v.id == current.id);
    if (!stillValid && vehicles.isNotEmpty) {
      final def = vehicles.firstWhere(
        (v) => !_takenVehicleIds.contains(v.id),
        orElse: () => vehicles.first,
      );
      vehicleProvider.selectVehicle(def);
    }

    if (mounted) setState(() {});
  }

  void _showSnackBar(String message) {
    NavigationService.scaffoldMessengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showVehiclePicker() async {
    final vehicleProvider = context.read<VehicleProvider>();
    final vehicles = vehicleProvider.vehicles;

    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 4, 20, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Select Vehicle',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                if (vehicles.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('No vehicles yet. Add one to continue.'),
                  ),
                ...vehicles.map((v) {
                  final taken = _takenVehicleIds.contains(v.id);
                  final isSelected = vehicleProvider.selectedVehicle?.id == v.id;
                  return ListTile(
                    enabled: !taken,
                    leading: const Icon(Icons.directions_car_outlined),
                    title: Text('${v.brand} ${v.model}'),
                    subtitle: Text(
                      '${v.vehicleNumber} • ${v.sizeCategory}'
                      '${taken ? ' • Already subscribed' : ''}',
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Color(0xffF4C430))
                        : null,
                    onTap: taken
                        ? null
                        : () {
                            vehicleProvider.selectVehicle(v);
                            Navigator.of(sheetContext).pop();
                          },
                  );
                }),
                const Divider(height: 8),
                ListTile(
                  leading: const Icon(Icons.add, color: Color(0xffF4C430)),
                  title: const Text('Add Vehicle'),
                  onTap: () => Navigator.of(sheetContext).pop('add'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result == 'add' && mounted) {
      await context.push('/add-vehicle');
      // Refresh list + default selection after returning.
      await _initBooking();
    }
  }

  Future<void> _handleCheckout() async {
    final vehicleProvider = context.read<VehicleProvider>();
    final areaProvider = context.read<AreaProvider>();
    final planProvider = context.read<PlanProvider>();
    final subscriptionProvider = context.read<SubscriptionProvider>();

    final vehicle = vehicleProvider.selectedVehicle;
    final vehicleId = vehicle?.id;
    final areaId = areaProvider.selectedArea?.id;
    final slotType = subscriptionProvider.selectedSlotType ?? 'MORNING';

    if (vehicle == null || vehicleId == null) {
      _showSnackBar('Please select a vehicle first');
      return;
    }

    if (areaId == null) {
      _showSnackBar('Please select a service area first');
      return;
    }

    final selectedPlan = planProvider.selectedPlan;
    if (selectedPlan == null) {
      _showSnackBar('Please select a subscription plan first');
      return;
    }

    // Fetch pricings dynamically
    if (planProvider.pricings.isEmpty) {
      try {
        await planProvider.fetchPricing();
      } catch (e) {
        _showSnackBar('Failed to load plan pricing list: $e');
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
      _showSnackBar(
          'No pricing found for ${selectedPlan.name} with ${vehicle.brand} ${vehicle.model} (${vehicle.sizeCategory})');
      return;
    }

    final router = GoRouter.of(context);
    // GST-inclusive total for display only; the backend recomputes the
    // authoritative amount from the subscription in create-subscription-order.
    final amount = planProvider.getTotalWithGstForPricingId(planPricingId) ?? 0;

    final subscription = await subscriptionProvider.createSubscription(
      vehicleId: vehicleId,
      areaId: areaId,
      planPricingId: planPricingId,
      slotType: slotType,
    );

    if (subscription != null) {
      router.pushNamed('payment', extra: {
        'subscriptionId': subscription.id,
        'amount': amount,
      });
      return;
    }

    // Creation failed. The vehicle may already have a subscription — either an
    // active one (app returns 409) or a cancelled row that still occupies the
    // backend's one-subscription-per-vehicle unique constraint (DB 500
    // "duplicate key"). In both cases, try to resume a still-pending (unpaid)
    // subscription; otherwise show a friendly message instead of the raw error.
    final error = subscriptionProvider.error ?? '';
    final lower = error.toLowerCase();
    final alreadySubscribed = lower.contains('already has an active subscription') ||
        lower.contains('duplicate key') ||
        lower.contains('unique constraint');
    if (alreadySubscribed) {
      final pending = await _findResumableSubscription(subscriptionProvider, vehicleId);
      if (pending != null) {
        final pendingAmount =
            planProvider.getTotalWithGstForPricingId(pending.planPricing?.id ?? planPricingId) ?? amount;
        _showSnackBar('Resuming payment for your pending subscription.');
        router.pushNamed('payment', extra: {
          'subscriptionId': pending.id,
          'amount': pendingAmount,
        });
        return;
      }
      _showSnackBar(
          'This vehicle already has a subscription and can\'t be subscribed again. Please use another vehicle.');
      return;
    }

    _showSnackBar(error.isEmpty ? 'Something went wrong' : error);
  }

  /// Finds an existing subscription for [vehicleId] that is still pending payment
  /// (status contains "PENDING"), so the user can resume checkout for it rather
  /// than being blocked by the one-active-subscription rule.
  Future<sub_dto.SubscriptionModel?> _findResumableSubscription(
    SubscriptionProvider provider,
    String vehicleId,
  ) async {
    try {
      await provider.fetchSubscriptions(page: 1, limit: 50);
    } catch (_) {
      // Non-fatal: fall through and return null if the list can't be loaded.
    }
    for (final s in provider.subscriptions) {
      if (s.vehicle?.id == vehicleId && s.status.toUpperCase().contains('PENDING')) {
        return s;
      }
    }
    return null;
  }

  Widget _buildVehicleCard() {
    final vehicle = context.watch<VehicleProvider>().selectedVehicle;
    final hasVehicle = vehicle != null;
    final label = hasVehicle
        ? '${vehicle.brand} ${vehicle.model} • ${vehicle.vehicleNumber}'
        : 'No vehicle selected';

    return _InfoCard(
      icon: Icons.directions_car_outlined,
      label: 'Vehicle',
      value: label,
      actionText: hasVehicle ? 'Change' : 'Select',
      onAction: _showVehiclePicker,
    );
  }

  Widget _buildServiceAreaCard() {
    final selectedArea = context.watch<AreaProvider>().selectedArea;
    final hasArea = selectedArea != null;
    final cityName = selectedArea?.city?.name;
    final label = hasArea
        ? [selectedArea.name, cityName].where((e) => e != null && e.isNotEmpty).join(', ')
        : 'No service area selected';

    return _InfoCard(
      icon: Icons.location_on_outlined,
      label: 'Service Area',
      value: label,
      actionText: hasArea ? 'Change' : 'Select',
      onAction: () => context.push('/select-area?return=true'),
    );
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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildVehicleCard(),
                  const SizedBox(height: 20),
                  _buildServiceAreaCard(),
                  const SizedBox(height: 20),
                  BookingSlotCard(day: widget.day, date: widget.date, time: widget.time),
                  const SizedBox(height: 20),
                  const PlanDetailsCard(),
                  const SizedBox(height: 20),
                  const PriceBreakdownCard(),
                ],
              ),
            ),
          ),
          CheckoutButton(onPressed: _handleCheckout),
        ],
      ),
    );
  }
}

/// A white rounded card showing an icon + label/value with a trailing action,
/// used for the editable vehicle and service-area rows on checkout.
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String actionText;
  final VoidCallback onAction;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xffF4C430)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
          ),
          TextButton(onPressed: onAction, child: Text(actionText)),
        ],
      ),
    );
  }
}
