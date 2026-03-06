import 'package:autozy/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../providers/otp_provider.dart';

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

    /// start countdown when screen opens
    Future.microtask(() {
      context.read<OtpProvider>().startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final otpProvider = context.watch<OtpProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Column(
            children: [
              /// HEADER
              const SizedBox(height: 6),

              Row(
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
              ),

              const SizedBox(height: 20),

              /// LOGO
              Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(10),

                  child: Image.asset(
                    "assets/images/logo.jpg",
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// TEXT
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

              /// OTP BOXES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => Container(
                    width: 55,
                    height: 60,
                    alignment: Alignment.center,

                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),

                    child: const TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,

                      decoration: InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                      ),

                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// VERIFY BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  child: const Text(
                    "Verify & Continue",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// RESEND SECTION
              Text.rich(
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

                            style: AppTextStyles.caption.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
