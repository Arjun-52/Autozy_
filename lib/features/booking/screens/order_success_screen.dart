import 'package:autozy/features/booking/widgets/order_details_card.dart';
import 'package:autozy/features/booking/widgets/success_button.dart';
import 'package:autozy/features/booking/widgets/success_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/responsive.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FB),

      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: context.h(30)),

            const SuccessIcon(),

            SizedBox(height: context.h(20)),

            Text(
              "Slot Booked!",
              style: TextStyle(fontSize: context.sp(22), fontWeight: FontWeight.w600, color: Colors.black),
            ),

            SizedBox(height: context.h(10)),

            Text(
              "Your plan and slot has been booked\nsuccessfully",
              textAlign: TextAlign.center,

              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: context.sp(13),
                height: 1.4,
                fontWeight: FontWeight.w400,
              ),
            ),

            SizedBox(height: context.h(24)),

            const OrderDetailsCard(),

            const Spacer(),
            SuccessButton(
              text: "Continue to Inspection",
              filled: true,
              onPressed: () {
                context.push('/inspection');
              },
            ),

            SizedBox(height: context.h(12)),

            SuccessButton(
              text: "Go to Home",
              filled: false,
              onPressed: () {
                context.go('/home');
              },
            ),

            SizedBox(height: context.h(20)),
          ],
        ),
      ),
    );
  }
}
