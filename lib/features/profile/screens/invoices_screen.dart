import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui' show BlendMode, ColorFilter;
import 'package:go_router/go_router.dart';

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  Widget buildSummaryCard(String value, String label, Widget icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(height: 28, width: 28, child: icon),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget buildInvoiceCard({
    required String plan,
    required String vehicle,
    required String date,
    required String price,
    required bool paid,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SvgPicture.asset(
                  'assets/images/document.svg',
                  height: 24,
                  width: 24,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(vehicle, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: paid
                      ? Colors.green.withValues(alpha: 0.15)
                      : Colors.red.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: paid ? Colors.green : Colors.red,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      paid ? Icons.check_circle : Icons.warning_amber_rounded,
                      size: 16,
                      color: paid ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      paid ? "Paid" : "Failed",
                      style: TextStyle(
                        color: paid ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Divider(),

          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: const TextStyle(color: Colors.grey)),
              Row(
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Invoices & Bills",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// TOP SUMMARY
            Row(
              children: [
                buildSummaryCard(
                  "₹3,959",
                  "Total Paid",
                  SvgPicture.asset(
                    'assets/images/moneys.svg',
                    height: 24,
                    width: 24,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 12),
                buildSummaryCard(
                  "5",
                  "Invoices",
                  SvgPicture.asset(
                    'assets/images/view_plans.svg',
                    height: 24,
                    width: 24,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  buildInvoiceCard(
                    plan: "Premium Plan",
                    vehicle: "TS 01 AB 1234 • BMW 3 Series",
                    date: "08 Mar 2026",
                    price: "₹1,499",
                    paid: true,
                  ),

                  buildInvoiceCard(
                    plan: "Standard Plan",
                    vehicle: "KA 01 CD 4567 • Honda City",
                    date: "24 Feb 2026",
                    price: "₹799",
                    paid: true,
                  ),

                  buildInvoiceCard(
                    plan: "Basic Plan",
                    vehicle: "TS 06 AB 0002 • Maruti Fronx",
                    date: "02 Jan 2026",
                    price: "₹399",
                    paid: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // Match go_router nested routes under /home.
          if (index == 0) {
            context.go('/home?initialIndex=0');
          } else if (index == 1) {
            context.go('/home/vehicles');
          } else if (index == 2) {
            context.go('/home/plans');
          } else if (index == 3) {
            context.go('/home/profile');
          }
        },
        selectedItemColor: const Color(0xffC68A00),
        unselectedItemColor: const Color(0xFF8E8E93),
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Builder(
              builder: (context) {
                final tint = IconTheme.of(context).color ?? const Color(0xFF8E8E93);
                return SvgPicture.asset(
                  'assets/images/car2.svg',
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(tint, BlendMode.srcIn),
                );
              },
            ),
            label: "Vehicles",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: "Plans",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
