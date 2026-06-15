import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/plan_provider.dart';
import '../../../providers/vehicle_provider.dart';
import '../../../providers/area_provider.dart';

class PriceBreakdownCard extends StatelessWidget {
  const PriceBreakdownCard({super.key});

  String _formatPlanName(String rawName) {
    final words = rawName.split('_');
    final capitalized = words.map((w) {
      if (w.isEmpty) return '';
      return '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}';
    });
    return capitalized.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final planProvider = context.watch<PlanProvider>();
    final vehicleProvider = context.watch<VehicleProvider>();
    final areaProvider = context.watch<AreaProvider>();

    final selectedPlan = planProvider.selectedPlan;
    final planName = selectedPlan?.name ?? 'Standard';

    final vehicle = vehicleProvider.vehicles.isNotEmpty ? vehicleProvider.vehicles.first : null;
    
    int resolvedPrice = 799;
    if (selectedPlan != null && vehicle != null) {
      final price = planProvider.getPriceForPlanAndVehicle(
        planId: selectedPlan.id,
        vehicleSize: vehicle.sizeCategory,
        areaId: areaProvider.selectedArea?.id,
        cityId: areaProvider.selectedArea?.cityId,
      );
      if (price != null) {
        resolvedPrice = price;
      } else {
        // Fallback standard price mapping
        switch (planName.toUpperCase()) {
          case 'BASIC':
            resolvedPrice = 499;
            break;
          case 'STANDARD':
            resolvedPrice = 799;
            break;
          case 'REGULAR_CLEANING':
            resolvedPrice = 699;
            break;
          case 'REGULAR_WATER_WASH':
            resolvedPrice = 899;
            break;
          case 'INTERNAL_CLEANING':
            resolvedPrice = 399;
            break;
          case 'PREMIUM':
            resolvedPrice = 1299;
            break;
          default:
            resolvedPrice = 499;
        }
      }
    }

    final displayName = "${_formatPlanName(planName)} Plan";

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
          _PriceRow(title: displayName, price: "₹$resolvedPrice"),
          const SizedBox(height: 10),
          const _PriceRow(title: "Add-ons", price: "₹0"),
          const Divider(height: 30),
          _PriceRow(title: "Grand Total", price: "₹$resolvedPrice", isBold: true),
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
            fontWeight: isBold ? FontWeight.w500 : FontWeight.w500,
            fontSize: isBold ? 18 : 16,
          ),
        ),
      ],
    );
  }
}
