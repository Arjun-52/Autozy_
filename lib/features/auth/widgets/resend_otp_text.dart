import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';

import '../../../providers/otp_provider.dart';
import '../../../core/constants/text_styles.dart';

class ResendOtpText extends StatelessWidget {
  const ResendOtpText({super.key});

  @override
  Widget build(BuildContext context) {
    final otpProvider = context.watch<OtpProvider>();

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "Didn't receive OTP? ",
            style: AppTextStyles.caption.copyWith(
              color: const Color(0xFF5B5B5E),
            ),
          ),

          otpProvider.canResend
              ? TextSpan(
                  text: "Resend",
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFFDD900C),
                    fontWeight: FontWeight.w600,
                  ),

                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      otpProvider.startTimer();
                    },
                )
              : TextSpan(
                  text: "Resend in ${otpProvider.secondsRemaining}s",
                  style: AppTextStyles.caption.copyWith(color: Colors.grey),
                ),
        ],
      ),
    );
  }
}
