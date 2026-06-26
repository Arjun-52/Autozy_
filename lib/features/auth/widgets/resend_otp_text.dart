import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';

import '../../../providers/otp_provider.dart';
import '../../../core/utils/responsive.dart';

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
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: context.sp(12),
              fontWeight: FontWeight.w400,
              color: const Color(0xFF8E8E93),
            ),
          ),
          otpProvider.canResend
              ? TextSpan(
                  text: "Resend OTP",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFFCB2F), // Brand Yellow
                  ),
                  recognizer: _tapGestureRecognizer,
                )
              : TextSpan(
                  text: "Resend in ${otpProvider.secondsRemaining}s",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: context.sp(12),
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF8E8E93),
                  ),
                ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
