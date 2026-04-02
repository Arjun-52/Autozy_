import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/constants/colors.dart';

class PlanDetailsCard extends StatelessWidget {
  const PlanDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.17),
            blurRadius: 10,
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
                      fontSize: 18,
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
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.onSurface,
                          ),
                        ),
                        TextSpan(
                          text: " /month",
                          style: TextStyle(
                            fontSize: 16,
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
