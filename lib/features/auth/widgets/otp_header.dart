import 'package:flutter/material.dart';
import '../../../core/constants/text_styles.dart';

class OtpHeader extends StatelessWidget {
  const OtpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),

        const SizedBox(width: 4),

        Text(
          "OTP Verification",
          style: AppTextStyles.title.copyWith(fontSize: 20),
        ),
      ],
    );
  }
}
