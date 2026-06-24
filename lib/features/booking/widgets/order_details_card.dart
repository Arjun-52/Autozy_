import 'package:autozy/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../providers/plan_provider.dart';
import '../../../providers/vehicle_provider.dart';
import '../../../providers/area_provider.dart';
import '../../../providers/subscription_provider.dart';
import 'plan_pricing.dart';

class OrderDetailsCard extends StatelessWidget {
  const OrderDetailsCard({super.key});

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  String _slotTime(String? type) {
    switch (type?.toUpperCase()) {
      case 'MORNING':
        return '08:00 - 13:00';
      case 'AFTERNOON':
        return '14:00 - 18:00';
      case 'EVENING':
        return '18:00 - 21:00';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final planProvider = context.watch<PlanProvider>();
    final vehicle = context.watch<VehicleProvider>().selectedVehicle;
    final area = context.watch<AreaProvider>().selectedArea;
    final subscription = context.watch<SubscriptionProvider>();
    final plan = planProvider.selectedPlan;

    final planName = plan != null ? prettyPlanName(plan.name) : 'Plan';
    final breakdown = resolvePlanPriceBreakdown(
      planProvider: planProvider,
      plan: plan,
      vehicle: vehicle,
      area: area,
    );
    // Plan price shown as the monthly (GST-exclusive) rate; the amount actually
    // charged is the GST-inclusive total.
    final priceText = breakdown != null ? '₹${formatPrice(breakdown.base)}' : '—';
    final amountPaidText = breakdown != null ? '₹${formatPrice(breakdown.total)}' : '—';

    // Booking slot from the subscription selection.
    final d = subscription.selectedDate;
    final slotTime = _slotTime(subscription.selectedSlotType);
    final slotParts = <String>[
      if (d != null) _weekdays[d.weekday - 1],
      if (d != null) '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]}',
      if (slotTime.isNotEmpty) slotTime,
    ];
    final slotLabel = slotParts.isEmpty ? 'Slot confirmed' : slotParts.join(', ');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Column(
              children: [
                Text(
                  "Order Number",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff7E8392),
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  "ORD–2026001",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF013E6D),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// BOOKING SLOT
          Container(
            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title Row
                const Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.grey),
                    SizedBox(width: 8),

                    Text(
                      "Booking Slot",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                /// Slot Time
                Text(
                  slotLabel,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// PLAN DETAILS CARD
          Container(
            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Plan Details",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: const Color(0xffF4C430),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SvgPicture.asset(
                        'assets/images/Star.svg',
                        height: 24,
                        width: 24,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          planName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xff7E8392),
                          ),
                        ),

                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: priceText,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              const TextSpan(
                                text: " /month",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF7E8392),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          /// AMOUNT PAID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Amount Paid",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              const Spacer(),
              Text(
                amountPaidText,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
