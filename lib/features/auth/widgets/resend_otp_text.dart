import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';

import '../../../providers/otp_provider.dart';
import '../../../core/constants/text_styles.dart';

class ResendOtpText extends StatefulWidget {
  const ResendOtpText({super.key});

  @override
  State<ResendOtpText> createState() => _ResendOtpTextState();
}

class _ResendOtpTextState extends State<ResendOtpText> {
  late TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        context.read<OtpProvider>().startTimer();
      };
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

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
                  text: "Resend OTP",
                  style: AppTextStyles.caption.copyWith(
                    color: const Color(0xFFDD900C),
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: _tapGestureRecognizer,
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
