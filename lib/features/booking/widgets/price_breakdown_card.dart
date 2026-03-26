import 'package:flutter/material.dart';

class PriceBreakdownCard extends StatelessWidget {
  const PriceBreakdownCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.19),
            blurRadius: 10,
          ),
        ],
      ),

      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Price Breakdown",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ),

          const SizedBox(height: 16),

          const _PriceRow(title: "Standard Plan", price: "₹799"),

          const SizedBox(height: 10),

          const _PriceRow(title: "Add-ons", price: "₹0"),

          const Divider(height: 30),

          const _PriceRow(title: "Grand Total", price: "₹799", isBold: true),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String title;
  final String price;
  final bool isBold;

  const _PriceRow({
    required this.title,
    required this.price,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isBold ? Colors.black : Colors.grey,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            fontSize: isBold ? 14 : 14,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.w500 : FontWeight.w500,
            fontSize: isBold ? 18 : 16,
          ),
        ),
      ],
    );
  }
}
