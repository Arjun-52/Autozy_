import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../providers/plan_provider.dart';
import '../../../providers/vehicle_provider.dart';
import '../../../providers/area_provider.dart';
import '../../../core/utils/responsive.dart';
import 'plan_pricing.dart';

class PlanDetailsCard extends StatelessWidget {
  const PlanDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final planProvider = context.watch<PlanProvider>();
    final vehicle = context.watch<VehicleProvider>().selectedVehicle;
    final area = context.watch<AreaProvider>().selectedArea;
    final plan = planProvider.selectedPlan;

    final planName = plan != null ? prettyPlanName(plan.name) : 'No plan selected';
    final price = resolvePlanPrice(
      planProvider: planProvider,
      plan: plan,
      vehicle: vehicle,
      area: area,
    );
    final priceText = price != null ? '₹${formatPrice(price)}' : '—';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(11)),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Plan Details",
            style: TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w600),
          ),
          SizedBox(height: context.h(10)),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(context.w(8)),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFCB2F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  'assets/images/Star.svg',
                  height: context.w(18),
                  width: context.w(18),
                ),
              ),
              SizedBox(width: context.w(10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planName,
                      style: TextStyle(
                        color: const Color(0xFF7E8392),
                        fontSize: context.sp(12.5),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.h(2)),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
