import 'package:flutter/material.dart';
import 'package:autozy/features/booking/models/payment_method_model.dart';
import 'package:autozy/features/booking/widget/payment_method_card.dart';
import 'package:autozy/features/booking/widget/pay_button.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedIndex = 0;

  final List<PaymentMethodModel> methods = [
    PaymentMethodModel(name: "Paytm", icon: "assets/paytm.jpg"),
    PaymentMethodModel(name: "PhonePe", icon: "assets/phonepe.jpg"),
    PaymentMethodModel(name: "GPay", icon: "assets/gpay.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),

      appBar: AppBar(
        title: const Text("Payment"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Select Payment Method",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: PaymentMethodCard(
              methods: methods,
              selectedIndex: selectedIndex,
              onSelect: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          ),

          PayButton(price: "799", onPressed: () {}),
        ],
      ),
    );
  }
}
