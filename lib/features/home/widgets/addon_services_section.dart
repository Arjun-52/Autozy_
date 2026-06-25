import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/utils/responsive.dart';

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
                width: context.w(56),
                height: context.w(56),
                child: SvgPicture.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: context.h(8)),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: context.sp(12),
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
        Text(
          "Add-On Services",
          style: TextStyle(
            fontSize: context.sp(18),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: context.h(16)),
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

