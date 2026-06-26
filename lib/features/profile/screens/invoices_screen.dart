import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui' show BlendMode, ColorFilter;
import 'package:go_router/go_router.dart';
import '../../../core/utils/responsive.dart';

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  Widget buildSummaryCard(BuildContext context, String value, String label, Widget icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.015),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(height: context.h(24), width: context.h(24), child: icon),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(fontSize: context.sp(16), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: Colors.grey, fontSize: context.sp(11.5), fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }

  Widget buildInvoiceCard(BuildContext context, {
    required String plan,
    required String vehicle,
    required String date,
    required String price,
    required bool paid,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  'assets/images/document.svg',
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan,
                      style: TextStyle(
                        fontSize: context.sp(13.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      vehicle, 
                      style: TextStyle(color: Colors.grey, fontSize: context.sp(11), fontWeight: FontWeight.w400),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: paid
                      ? Colors.green.withOpacity(0.08)
                      : Colors.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: paid ? Colors.green : Colors.red,
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      paid ? Icons.check_circle : Icons.warning_amber_rounded,
                      size: 13,
                      color: paid ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      paid ? "Paid" : "Failed",
                      style: TextStyle(
                        color: paid ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: context.sp(9.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Divider(height: 1),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date, 
                style: TextStyle(color: Colors.grey, fontSize: context.sp(11.5), fontWeight: FontWeight.w400),
              ),
              Row(
                children: [
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: context.sp(13.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right, size: 18),
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
      backgroundColor: const Color(0xFFF9F9FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Invoices & Bills",
          style: TextStyle(
            color: Colors.black,
            fontSize: context.sp(18),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Padding(
        padding: EdgeInsets.all(context.w(16)),
        child: Column(
          children: [
            /// TOP SUMMARY
            Row(
              children: [
                buildSummaryCard(
                  context,
                  "₹3,959",
                  "Total Paid",
                  SvgPicture.asset(
                    'assets/images/moneys.svg',
                    height: 20,
                    width: 20,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 12),
                buildSummaryCard(
                  context,
                  "5",
                  "Invoices",
                  SvgPicture.asset(
                    'assets/images/view_plans.svg',
                    height: 20,
                    width: 20,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                children: [
                  buildInvoiceCard(
                    context,
                    plan: "Premium Plan",
                    vehicle: "TS 01 AB 1234 • BMW 3 Series",
                    date: "08 Mar 2026",
                    price: "₹1,499",
                    paid: true,
                  ),

                  buildInvoiceCard(
                    context,
                    plan: "Standard Plan",
                    vehicle: "KA 01 CD 4567 • Honda City",
                    date: "24 Feb 2026",
                    price: "₹799",
                    paid: true,
                  ),

                  buildInvoiceCard(
                    context,
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
        currentIndex: 3,
        onTap: (index) {
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
        selectedItemColor: Colors.orange,
        unselectedItemColor: const Color(0xFF8E8E93),
        showUnselectedLabels: true,
        showSelectedLabels: true,
        iconSize: 18,
        selectedFontSize: 11,
        unselectedFontSize: 11,
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
                  height: 18,
                  width: 18,
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
