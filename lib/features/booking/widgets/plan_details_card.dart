import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../providers/plan_provider.dart';
import '../../../providers/vehicle_provider.dart';
import '../../../providers/area_provider.dart';
import '../../../core/constants/colors.dart';

class PlanDetailsCard extends StatelessWidget {
  const PlanDetailsCard({super.key});

  String _getPlanIconAsset(String name) {
    switch (name.toUpperCase()) {
      case 'BASIC':
        return 'assets/images/basic.svg';
      case 'STANDARD':
        return 'assets/images/Star.svg';
      case 'PREMIUM':
        return 'assets/images/ranking.svg';
      case 'REGULAR_CLEANING':
        return 'assets/images/Lightning.svg';
      case 'REGULAR_WATER_WASH':
        return 'assets/images/view_plans.svg';
      case 'INTERNAL_CLEANING':
        return 'assets/images/basic.svg';
      default:
        return 'assets/images/Star.svg';
    }
  }

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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF161616).withOpacity(0.12),
            offset: const Offset(0, 4),
            blurRadius: 13,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Plan Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xffF4C430),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: SvgPicture.asset(
                  _getPlanIconAsset(planName),
                  height: 24,
                  width: 24,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // Capitalize first letter or display name nicely
                    _formatPlanName(planName),
                    style: const TextStyle(
                      color: Color(0xFF7E8392),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "₹$resolvedPrice",
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
    );
  }
}
