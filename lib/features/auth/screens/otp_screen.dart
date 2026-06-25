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
import '../../../../core/utils/responsive.dart';
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
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(authProvider.error!)));
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: context.screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(28)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: context.h(4)),

                    /// Header
                    Transform.translate(
                      offset: Offset(-context.w(10), 0),
                      child: const OtpHeader(),
                    ),
                    SizedBox(height: context.h(24)),

                    /// Logo
                    const OtpLogo(),
                    SizedBox(height: context.h(28)),

                    /// Verification message
                    Text(
                      "We have sent a verification code to",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: context.sp(13),
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8E8E93),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: context.h(4)),
                    Text(
                      "+91 ${widget.phone}",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: context.sp(14),
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(height: context.h(28)),

                    /// Enter Code title
                    Text(
                      "Enter the Code",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: context.sp(30),
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: context.h(6)),

                    /// Subtitle
                    Text(
                      "Please enter the 6-digit code sent to your number",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: context.sp(12),
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8E8E93),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: context.h(24)),

                    /// OTP boxes
                    const OtpInputFields(),

                    SizedBox(height: context.h(32)),

                    /// Verify Button
                    VerifyButton(
                      onPressed: authProvider.isLoading
                          ? null
                          : () async {
                              print('OTP SUBMIT PRESSED');
                              print(StackTrace.current);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              final otpProvider = context.read<OtpProvider>();

                              final success = await context
                                  .read<AuthProvider>()
                                  .verifyOtpAndLogin(widget.phone, otpProvider.otp);

                              if (success && context.mounted) {
                                context.go('/select-area');
                              }
                            },
                    ),

                    SizedBox(height: context.h(24)),

                    /// Resend OTP
                    const ResendOtpText(),

                    const Spacer(),
                    SizedBox(height: context.h(20)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
