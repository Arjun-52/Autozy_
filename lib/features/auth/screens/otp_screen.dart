import 'package:autozy/features/auth/widgets/otp_header.dart';
import 'package:autozy/features/auth/widgets/otp_input_fields.dart';
import 'package:autozy/features/auth/widgets/otp_logo.dart';
import 'package:autozy/features/auth/widgets/resend_otp_text.dart';
import 'package:autozy/features/auth/widgets/verify_button.dart';
import 'package:autozy/features/navigation/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../providers/otp_provider.dart';

class OtpScreen extends StatefulWidget {
  final String phone;

  const OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<OtpProvider>().startTimer();
    });
  }

  @override
  void dispose() {
    context.read<OtpProvider>().disposeTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 6),

              /// Header
              const OtpHeader(),

              const SizedBox(height: 20),

              /// Logo
              const OtpLogo(),

              const SizedBox(height: 20),

              /// Info text
              Text(
                "We have sent a verification code to",
                style: AppTextStyles.headline3,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 6),

              /// Phone number
              Text(
                "+91 ${widget.phone}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 26),

              /// code text
              const Text(
                "Enter The Code",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              /// OTP Fields
              const OtpInputFields(),

              const SizedBox(height: 30),

              /// Verify Button
              VerifyButton(
                onPressed: () {
                  final otpProvider = context.read<OtpProvider>();

                  if (otpProvider.otp.length == 4) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter the complete OTP"),
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 30),

              /// Resend OTP
              const ResendOtpText(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
