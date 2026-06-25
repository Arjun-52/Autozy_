import 'package:autozy/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../providers/plan_provider.dart';
import '../../../providers/vehicle_provider.dart';
import '../../../providers/area_provider.dart';
import '../../../providers/subscription_provider.dart';
import '../../../core/utils/responsive.dart';
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
      margin: EdgeInsets.symmetric(horizontal: context.w(16)),
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  "Order Number",
                  style: TextStyle(
                    fontSize: context.sp(11),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff7E8392),
                  ),
                ),
                SizedBox(height: context.h(4)),
                Text(
                  "ORD–2026001",
                  style: TextStyle(
                    fontSize: context.sp(15),
                    color: const Color(0xFF013E6D),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.h(16)),

          /// BOOKING SLOT
          Container(
            padding: EdgeInsets.all(context.w(12)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE9E9E9)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.015),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.grey, size: context.w(18)),
                    SizedBox(width: context.w(8)),
                    Text(
                      "Booking Slot",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: context.sp(12),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.h(6)),
                Text(
                  slotLabel,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: context.sp(13.5)),
                ),
              ],
            ),
          ),
          SizedBox(height: context.h(12)),

          /// PLAN DETAILS CARD
          Container(
            padding: EdgeInsets.all(context.w(12)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE9E9E9)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.015),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Plan Details",
                  style: TextStyle(fontSize: context.sp(13.5), fontWeight: FontWeight.w600),
                ),
                SizedBox(height: context.h(10)),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(context.w(8)),
                      decoration: BoxDecoration(
                        color: const Color(0xffF4C430),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SvgPicture.asset(
                        'assets/images/Star.svg',
                        height: context.w(18),
                        width: context.w(18),
                      ),
                    ),
                    SizedBox(width: context.w(10)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          planName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: context.sp(12.5),
                            color: const Color(0xff7E8392),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: priceText,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: context.sp(14),
                                  color: AppColors.onSurface,
                                ),
                              ),
                              TextSpan(
                                text: " /month",
                                style: TextStyle(
                                  fontSize: context.sp(11),
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF7E8392),
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
          SizedBox(height: context.h(16)),

          /// AMOUNT PAID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Amount Paid",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: context.sp(13.5)),
              ),
              const Spacer(),
              Text(
                amountPaidText,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: context.sp(16), color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
