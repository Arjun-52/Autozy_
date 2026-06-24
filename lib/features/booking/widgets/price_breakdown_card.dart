import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/plan_provider.dart';
import '../../../providers/vehicle_provider.dart';
import '../../../providers/area_provider.dart';
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.19),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Price Breakdown",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 16),
          _PriceRow(title: planName, price: baseLabel),
          const SizedBox(height: 10),
          const _PriceRow(title: "Add-ons", price: "₹0"),
          const SizedBox(height: 10),
          _PriceRow(title: "GST (18%)", price: gstLabel),
          const Divider(height: 30),
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
      children: [
        Text(
          title,
          style: TextStyle(
            color: isBold ? Colors.black : Colors.grey,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: isBold ? 18 : 16,
          ),
        ),
      ],
    );
  }
}
