import 'package:flutter/material.dart';
import '../models/payment_method_model.dart';
import 'payment_option_tile.dart';
import '../../../core/utils/responsive.dart';

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
      margin: EdgeInsets.symmetric(horizontal: context.w(16)),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: [
              /// TITLE
              Padding(
                padding: EdgeInsets.all(context.w(16)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "UPI",
                    style: TextStyle(fontSize: context.sp(15), fontWeight: FontWeight.w600, color: Colors.black),
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
                  width: context.w(30),
                  height: context.w(30),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: context.w(30),
                      height: context.w(30),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(Icons.error, size: context.w(16)),
                    );
                  },
                ),
                title: Text(
                  "Add UPI ID",
                  style: TextStyle(fontSize: context.sp(14), fontWeight: FontWeight.w500),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: context.w(14)),
                onTap: () {
                  setState(() {
                    showUpiField = !showUpiField;
                  });
                },
              ),

              /// UPI INPUT FIELD
              if (showUpiField)
                Padding(
                  padding: EdgeInsets.fromLTRB(context.w(16), 0, context.w(16), context.h(12)),
                  child: Column(
                    children: [
                      TextField(
                        controller: upiController,
                        style: TextStyle(fontSize: context.sp(14)),
                        decoration: InputDecoration(
                          hintText: "example@upi",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: context.w(12),
                            vertical: context.h(12),
                          ),
                        ),
                      ),
                      SizedBox(height: context.h(10)),

                      /// OPTIONAL SAVE BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: context.h(40),
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: handle UPI submission
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Save UPI",
                            style: TextStyle(fontSize: context.sp(13), fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
