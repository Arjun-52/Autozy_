import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class OtpLogo extends StatelessWidget {
  const OtpLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: 140,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Image.asset("assets/images/logo.jpg", fit: BoxFit.contain),
      ),
    );
  }
}
