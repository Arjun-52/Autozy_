import 'package:flutter/material.dart';

class BuildInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const BuildInputField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        decoration: InputDecoration(labelText: label, border: InputBorder.none),
      ),
    );
  }
}
