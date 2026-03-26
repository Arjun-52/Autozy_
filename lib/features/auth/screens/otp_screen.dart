import 'package:autozy/features/auth/widgets/otp_header.dart';
import 'package:autozy/features/auth/widgets/otp_input_fields.dart';
import 'package:autozy/features/auth/widgets/otp_logo.dart';
import 'package:autozy/features/auth/widgets/resend_otp_text.dart';
import 'package:autozy/features/auth/widgets/verify_button.dart';
import 'package:autozy/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(authProvider.error!)));
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 6),

              const OtpHeader(),
              const SizedBox(height: 20),

              const OtpLogo(),
              const SizedBox(height: 20),

              Text(
                "We have sent a verification code to",
                style: AppTextStyles.headline3,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 6),

              Text(
                "+91 ${widget.phone}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 26),

              const Text(
                "Enter The Code",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              const OtpInputFields(),

              const SizedBox(height: 30),

              VerifyButton(
                onPressed: authProvider.isLoading
                    ? null
                    : () async {
                        final otpProvider = context.read<OtpProvider>();

                        final success = await context
                            .read<AuthProvider>()
                            .verifyOtpAndLogin(widget.phone, otpProvider.otp);

                        if (success && context.mounted) {
                          context.go('/home');
                        }
                      },
              ),

              const SizedBox(height: 30),

              const ResendOtpText(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
