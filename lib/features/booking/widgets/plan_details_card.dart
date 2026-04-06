import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/constants/colors.dart';

class PlanDetailsCard extends StatelessWidget {
  const PlanDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
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

          const SizedBox(height: 16), // gap

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xffF4C430),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: SvgPicture.asset(
                  'assets/images/Star.svg',
                  height: 24,
                  width: 24,
                ),
              ),

              const SizedBox(width: 14),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Standard",
                    style: TextStyle(
                      color: Color(0xFF7E8392),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "₹799",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.onSurface,
                          ),
                        ),
                        TextSpan(
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
