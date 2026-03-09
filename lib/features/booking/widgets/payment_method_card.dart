import 'package:flutter/material.dart';
import '../models/payment_method_model.dart';
import 'payment_option_tile.dart';

class PaymentMethodCard extends StatelessWidget {
  final List<PaymentMethodModel> methods;
  final int selectedIndex;
  final Function(int) onSelect;

  const PaymentMethodCard({
    super.key,
    required this.methods,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
        ],
      ),

      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "UPI",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          ...List.generate(methods.length, (index) {
            final method = methods[index];

            return PaymentOptionTile(
              method: method,
              isSelected: selectedIndex == index,
              onTap: () => onSelect(index),
            );
          }),

          ListTile(
            leading: Image.asset(
              "assets/images/upi.jpg",
              width: 30,
              height: 30,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.error, color: Colors.white, size: 16),
                );
              },
            ),
            title: const Text("Add UPI ID"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ],
      ),
    );
  }
}
