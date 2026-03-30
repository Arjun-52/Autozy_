import 'package:flutter/material.dart';

Widget buildField(
  String hint,
  TextEditingController controller, {
  TextInputType? type,
  int? maxLength,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: controller,
      keyboardType: type,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hint,
        counterText: "",
        filled: true,
        fillColor: Colors.grey.shade100,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFFC107), width: 1.5),
        ),
      ),
    ),
  );
}
