import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomBar extends StatelessWidget {
  final String date;
  final String time;

  const BottomBar({super.key, required this.date, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, -3),
          ),
        ],
      ),

      child: Row(
        children: [
          Expanded(
            child: Text(
              "$date, $time",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffF4C430),
              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
            onPressed: () {
              context.pushNamed(
                'checkout',
                extra: {"day": 'Monday', "date": date, "time": time},
              );
            },
            child: const Text(
              "Next",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
