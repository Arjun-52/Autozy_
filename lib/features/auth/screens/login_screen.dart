import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/text_styles.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  bool isValidPhone(String phone) {
    RegExp regex = RegExp(r'^[6-9]\d{9}$');
    return regex.hasMatch(phone);
  }

  void continueLogin() {
    String phone = phoneController.text.trim();

    if (!isValidPhone(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid 10 digit mobile number")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OtpScreen(phone: phone)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Column(
            children: [
              /// TOP SECTION
              Column(
                children: [
                  const SizedBox(height: 40),

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

                  Text("autozy", style: AppTextStyles.heading1),

                  const SizedBox(height: 1),

                  Text("Customer", style: AppTextStyles.caption),
                ],
              ),

              const SizedBox(height: 75),

              /// LOGIN TITLE
              Text(
                "Log in or Sign Up",
                style: AppTextStyles.heading1.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              /// PHONE FIELD
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Text(
                      "🇮🇳 +91",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: const InputDecoration(
                          hintText: "Enter Mobile Number",
                          counterText: "",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// CONTINUE BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: continueLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Continue",
                    style: AppTextStyles.button.copyWith(color: Colors.black),
                  ),
                ),
              ),

              const Spacer(),

              /// TERMS
              const Text(
                "By continuing, you agree to our Terms and Conditions\n& Privacy Policy",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF5B5B5E)),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
