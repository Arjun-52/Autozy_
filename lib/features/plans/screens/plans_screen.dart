import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/plan_card.dart';

class PlansScreen extends StatefulWidget {
  const PlansScreen({super.key});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  int selectedPlan = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.goNamed('home');
          },
        ),
        title: const Text(
          "Plans",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// BASIC PLAN
                  PlanCard(
                    title: "Basic",
                    price: "₹499",
                    icon: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: selectedPlan == 0
                            ? const Color(0xFFFFC107) // selected
                            : const Color(0xFFFFECBC), // not selected
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/basic-icon.png',
                          height: 20,
                          width: 20,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    features: [
                      {"title": "Daily exterior wash", "isSelected": true},
                      {"title": "Dashboard wipe", "isSelected": true},
                      {"title": "Feature number three", "isSelected": true},
                    ],
                    isSelected: selectedPlan == 0,
                    onTap: () {
                      setState(() {
                        selectedPlan = 0;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  /// STANDARD PLAN
                  PlanCard(
                    title: "Standard",
                    price: "₹799",
                    icon: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: selectedPlan == 1
                            ? const Color(0xFFFFC107) // selected (dark yellow)
                            : const Color(
                                0xFFFFECBC,
                              ), // not selected (light yellow)
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/star-icon.png',
                          height: 20,
                          width: 20,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    isPopular: true,
                    features: [
                      {"title": "Everything in Basic", "isSelected": true},
                      {"title": "Interior vacuum (weekly)", "isSelected": true},
                      {"title": "Tyre dressing (weekly)", "isSelected": true},
                      {"title": "Priority Support", "isSelected": true},
                    ],
                    isSelected: selectedPlan == 1,
                    onTap: () {
                      setState(() {
                        selectedPlan = 1;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  /// PREMIUM PLAN
                  PlanCard(
                    title: "Premium",
                    price: "₹1,299",
                    icon: Container(
                      height: 36,
                      width: 36,
                      decoration: BoxDecoration(
                        color: selectedPlan == 2
                            ? const Color(0xFFFFC107) // selected (dark yellow)
                            : const Color(
                                0xFFFFECBC,
                              ), // not selected (light yellow)
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/ranking-icon.png',
                          height: 20,
                          width: 20,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    features: [
                      {"title": "Everything in Standard", "isSelected": true},
                      {
                        "title": "Full interior clean (bi-weekly)",
                        "isSelected": true,
                      },
                      {"title": "AC vent cleaning", "isSelected": true},
                      {
                        "title": "Ceramic spray coating (monthly)",
                        "isSelected": true,
                      },
                      {"title": "Dedicated detailer", "isSelected": true},
                    ],
                    isSelected: selectedPlan == 2,
                    onTap: () {
                      setState(() {
                        selectedPlan = 2;
                      });
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          /// CONTINUE BUTTON
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF4C430),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                context.pushNamed('bookSlot');
              },
              child: const Text(
                "Continue to Slot Selection",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPlanIcon(String path, bool isSelected) {
    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFFFFC107) // selected
            : const Color(0xFFFFECBC), // not selected
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Image.asset(path, height: 20, width: 20, fit: BoxFit.contain),
      ),
    );
  }
}
