import 'package:flutter/material.dart';
import '../models/payment_method_model.dart';
import '../../../core/utils/responsive.dart';

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
            size: context.w(20),
          ),
          title: Row(
            children: [
              Image.asset(
                method.icon,
                width: context.w(30),
                height: context.w(30),
                fit: BoxFit.contain,
              ),
              SizedBox(width: context.w(10)),
              Expanded(
                child: Text(
                  method.name,
                  style: TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
