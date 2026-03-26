import 'package:flutter/material.dart';
import '../models/payment_method_model.dart';
import 'payment_option_tile.dart';

class PaymentMethodCard extends StatefulWidget {
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
  State<PaymentMethodCard> createState() => _PaymentMethodCardState();
}

class _PaymentMethodCardState extends State<PaymentMethodCard> {
  bool showUpiField = false;
  final TextEditingController upiController = TextEditingController();

  @override
  void dispose() {
    upiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          /// TITLE
          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "UPI",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          /// EXISTING PAYMENT METHODS
          ...List.generate(widget.methods.length, (index) {
            final method = widget.methods[index];

            return PaymentOptionTile(
              method: method,
              isSelected: widget.selectedIndex == index,
              onTap: () => widget.onSelect(index),
            );
          }),

          /// ADD UPI TILE
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
                  child: const Icon(Icons.error, size: 16),
                );
              },
            ),
            title: const Text("Add UPI ID"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              setState(() {
                showUpiField = !showUpiField;
              });
            },
          ),

          /// UPI INPUT FIELD
          if (showUpiField)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                children: [
                  TextField(
                    controller: upiController,
                    decoration: InputDecoration(
                      hintText: "example@upi",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// OPTIONAL SAVE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: handle UPI submission
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Save UPI"),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
