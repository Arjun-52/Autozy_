import 'package:flutter/material.dart';
import '../models/payment_method_model.dart';

class PaymentOptionTile extends StatelessWidget {
  final PaymentMethodModel method;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentOptionTile({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,

          leading: Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: isSelected ? Colors.orange : Colors.grey,
          ),

          title: Row(
            children: [
              Image.asset(method.icon, width: 32),

              const SizedBox(width: 10),

              Text(method.name, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),

        const Divider(),
      ],
    );
  }
}
