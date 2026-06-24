import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddonServicesSection extends StatelessWidget {
  const AddonServicesSection({super.key});

  Widget _buildItem(
    BuildContext context, {
    required String imagePath,
    required String label,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.push('/book-addon');
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: SvgPicture.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Add-On Services",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildItem(
              context,
              imagePath: 'assets/images/Polishing.svg',
              label: "Body\nWash",
            ),
            _buildItem(
              context,
              imagePath: 'assets/images/Full-Detailing.svg',
              label: "Interior\nClean",
            ),
            _buildItem(
              context,
              imagePath: 'assets/images/Body-Wash.svg',
              label: "Full\nDetailing",
            ),
            _buildItem(
              context,
              imagePath: 'assets/images/Interior-Cleaning.svg',
              label: "Polishing",
            ),
          ],
        ),
      ],
    );
  }
}
