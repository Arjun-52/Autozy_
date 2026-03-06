import 'package:autozy/features/home/widgets/explore_card.dart.dart';
import 'package:autozy/features/home/widgets/greeting_section.dart';
import 'package:autozy/features/home/widgets/home_bottom_nav.dart';
import 'package:autozy/features/home/widgets/home_header.dart';
import 'package:autozy/features/home/widgets/premium_services_card.dart';
import 'package:autozy/features/home/widgets/vehicle_card.dart';
import 'package:autozy/features/plans/plans_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: ListView(
            children: [
              const HomeHeader(),

              const SizedBox(height: 30),

              const GreetingSection(),

              const SizedBox(height: 20),

              const VehicleCard(),

              const SizedBox(height: 26),

              const Text(
                "Explore",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ExploreCard(
                      icon: Icons.description_outlined,
                      title: "View Plans",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlansScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: ExploreCard(
                      icon: Icons.add_circle_outline,
                      title: "Add Vehicle",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const ExploreCard(
                icon: Icons.calendar_today_outlined,
                title: "Book Slot",
                fullWidth: true,
              ),

              const SizedBox(height: 20),

              const PremiumServicesCard(),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const HomeBottomNav(),
    );
  }
}
