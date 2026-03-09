import '../../../core/router/app_router.dart';
import '../../booking/screens/book_slot_screen.dart';
import '../widgets/plan_card.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xffF6F6F6),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Plans",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                    icon: Icons.sell_outlined,
                    features: [
                      "Daily exterior wash",
                      "Dashboard wipe",
                      "Feature number three",
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
                    icon: Icons.auto_awesome,
                    isPopular: true,
                    features: [
                      "Everything in Basic",
                      "Interior vacuum (weekly)",
                      "Tyre dressing (weekly)",
                      "Priority Support",
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
                    icon: Icons.workspace_premium,
                    features: [
                      "Everything in Standard",
                      "Full interior clean (bi-weekly)",
                      "AC vent cleaning",
                      "Ceramic spray coating (monthly)",
                      "Dedicated detailer",
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
                Navigator.pushNamed(context, AppRouter.bookSlot);
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
}
