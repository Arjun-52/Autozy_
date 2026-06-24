import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WhyAutozySection extends StatelessWidget {
  const WhyAutozySection({super.key});

  Widget _buildBenefitItem({
    required String imagePath,
    required String title,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: SvgPicture.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Why Autozy?",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE9E9E9)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBenefitItem(
                imagePath: 'assets/images/professionals.svg',
                title: "Trusted\nProfessionals",
              ),
              _buildBenefitItem(
                imagePath: 'assets/images/daily assurance.svg',
                title: "Daily\nAssurance",
              ),
              _buildBenefitItem(
                imagePath: 'assets/images/thumbs up.svg',
                title: "Satisfaction\nGuaranteed",
              ),
              _buildBenefitItem(
                imagePath: 'assets/images/on the service.svg',
                title: "On-Time\nService",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
