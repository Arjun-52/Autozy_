import 'package:autozy/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/responsive.dart';

class Country {
  final String name;
  final String code;
  final String flag;

  const Country({required this.name, required this.code, required this.flag});
}

const List<Country> countries = [
  Country(name: "India", code: "+91", flag: "🇮🇳"),
  Country(name: "United States", code: "+1", flag: "🇺🇸"),
  Country(name: "United Kingdom", code: "+44", flag: "🇬🇧"),
  Country(name: "UAE", code: "+971", flag: "🇦🇪"),
  Country(name: "Singapore", code: "+65", flag: "🇸🇬"),
  Country(name: "Canada", code: "+1", flag: "🇨🇦"),
];

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  Country selectedCountry = countries[0];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().resetAuthState();
    });
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
                  children: [
                    const Spacer(),

                    /// LOGO 
                    SizedBox(
                      height: context.w(80),
                      width: context.w(80),
                      child: Image.asset(
                        "assets/images/new-logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),

                    SizedBox(height: context.h(8)),

                    Text(
                      "autozy",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: context.sp(32),
                        fontWeight: FontWeight.w300,
                        letterSpacing: 2.0,
                        color: Colors.black,
                      ),
                    ),
                   

                    SizedBox(height: context.h(45)),

                    Text(
                      "Log in or Sign Up",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: context.sp(18),
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: context.h(20)),

                    /// PHONE FIELD 
                    Container(
                      height: context.h(48),
                      padding: EdgeInsets.symmetric(horizontal: context.w(16)),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFE5E5EA), 
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton<Country>(
                              value: selectedCountry,
                              icon: const Padding(
                                padding: EdgeInsets.only(left: 4.0),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: Color(0xFF8E8E93),
                                ),
                              ),
                              onChanged: (Country? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    selectedCountry = newValue;
                                  });
                                }
                              },
                              style: TextStyle(
                                fontSize: context.sp(14),
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                              selectedItemBuilder: (BuildContext context) {
                                return countries.map<Widget>((Country country) {
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${country.flag} ${country.code}",
                                      style: TextStyle(
                                        fontSize: context.sp(14),
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  );
                                }).toList();
                              },
                              items: countries.map<DropdownMenuItem<Country>>((Country country) {
                                return DropdownMenuItem<Country>(
                                  value: country,
                                  child: Text(
                                    "${country.flag}  ${country.code}",
                                    style: TextStyle(
                                      fontSize: context.sp(14),
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(width: context.w(4)),
                          VerticalDivider(
                            color: const Color(0xFFE5E5EA),
                            thickness: 0.8,
                            indent: context.h(12),
                            endIndent: context.h(12),
                          ),
                          SizedBox(width: context.w(4)),
                          Expanded(
                            child: TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              style: TextStyle(
                                fontSize: context.sp(14),
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: "Enter Mobile Number",
                                hintStyle: TextStyle(
                                  fontSize: context.sp(14),
                                  fontWeight: FontWeight.w300,
                                  color: const Color(0xFF8E8E93),
                                ),
                                counterText: "",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: context.h(20)),

                    SizedBox(
                      width: double.infinity,
                      height: context.h(46),
                      child: ElevatedButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () async {
                                print('LOGIN BUTTON PRESSED');
                                print(StackTrace.current);
                                final success = await context
                                    .read<AuthProvider>()
                                    .continueWithPhone(phoneController.text);

                                if (success && context.mounted) {
                                  final successMsg = context.read<AuthProvider>().successMessage ?? "OTP Sent Successfully";
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(successMsg),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  context.pushNamed(
                                    'otp',
                                    queryParameters: {
                                      'phone': phoneController.text.trim(),
                                    },
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yellow,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: authProvider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "Continue",
                                style: TextStyle(
                                  fontSize: context.sp(14),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    ),

                    const Spacer(),

                    Text(
                      "By continuing, you agree to our Terms and Conditions & Privacy Policy",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF8E8E93),
                        fontSize: context.sp(11),
                        fontWeight: FontWeight.w300,
                        height: 1.4,
                      ),
                    ),

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
