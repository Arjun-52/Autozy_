import 'package:flutter/material.dart';
import 'package:autozy/features/booking/models/payment_method_model.dart';
import 'package:autozy/features/booking/widgets/payment_method_card.dart';
import 'package:autozy/features/booking/widgets/pay_button.dart';
import '../../../../core/services/navigation_service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedIndex = 0;

  final List<PaymentMethodModel> methods = [
    PaymentMethodModel(name: "Paytm", icon: "assets/images/paytm.jpg"),
    PaymentMethodModel(name: "PhonePe", icon: "assets/images/phonepay.jpg"),
    PaymentMethodModel(name: "GPay", icon: "assets/images/gpay.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),

      appBar: AppBar(
        title: const Text(
          "Payment",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          const SizedBox(height: 20),

          PaymentMethodCard(
            methods: methods,
            selectedIndex: selectedIndex,
            onSelect: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          SizedBox(height: 180),

          PayButton(
            price: "799",
            onPressed: () {
              NavigationService.navigateToPath(context, '/order-success');
            },
          ),
        ],
      ),
    );
  }
}
