import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';

class OtpLogo extends StatelessWidget {
  const OtpLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.w(64),
      width: context.w(64),
      child: Image.asset(
        "assets/images/new-logo.png",
        fit: BoxFit.contain,
      ),
    );
  }
}
