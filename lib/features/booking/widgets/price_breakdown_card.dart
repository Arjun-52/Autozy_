import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/plan_provider.dart';
import '../../../providers/vehicle_provider.dart';
import '../../../providers/area_provider.dart';
import '../../../core/utils/responsive.dart';
import 'plan_pricing.dart';

class PriceBreakdownCard extends StatelessWidget {
  const PriceBreakdownCard({super.key});

  @override
  Widget build(BuildContext context) {
    final planProvider = context.watch<PlanProvider>();
    final vehicle = context.watch<VehicleProvider>().selectedVehicle;
    final area = context.watch<AreaProvider>().selectedArea;
    final plan = planProvider.selectedPlan;

    final breakdown = resolvePlanPriceBreakdown(
      planProvider: planProvider,
      plan: plan,
      vehicle: vehicle,
      area: area,
    );
    final planName = plan != null ? prettyPlanName(plan.name) : 'Plan';
    final baseLabel = breakdown != null ? '₹${formatPrice(breakdown.base)}' : '—';
    final gstLabel = breakdown != null ? '₹${formatPrice(breakdown.gst)}' : '—';
    final totalLabel = breakdown != null ? '₹${formatPrice(breakdown.total)}' : '—';

    return Container(
      padding: EdgeInsets.all(context.w(11)),
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
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Price Breakdown",
              style: TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: context.h(10)),
          _PriceRow(title: planName, price: baseLabel),
          SizedBox(height: context.h(8)),
          const _PriceRow(title: "Add-ons", price: "₹0"),
          SizedBox(height: context.h(8)),
          _PriceRow(title: "GST (18%)", price: gstLabel),
          Divider(height: context.h(20)),
          _PriceRow(title: "Grand Total", price: totalLabel, isBold: true),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String title;
  final String price;
  final bool isBold;

  const _PriceRow({
    required this.title,
    required this.price,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: isBold ? Colors.black : Colors.grey,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              fontSize: isBold ? context.sp(13.5) : context.sp(12.5),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: context.w(12)),
        Text(
          price,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            fontSize: isBold ? context.sp(14) : context.sp(12.5),
          ),
        ),
      ],
    );
  }
}
