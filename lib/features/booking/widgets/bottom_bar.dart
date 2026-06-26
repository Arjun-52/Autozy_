import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/responsive.dart';

class BottomBar extends StatelessWidget {
  final String day;
  final String date;
  final String time;

  const BottomBar({super.key, required this.day, required this.date, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(10)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$date, $time",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: context.sp(13)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFCB2F),
              padding: EdgeInsets.symmetric(horizontal: context.w(32), vertical: context.h(10)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            onPressed: () {
              context.pushNamed(
                'checkout',
                extra: {"day": day, "date": date, "time": time},
              );
            },
            child: Text(
              "Next",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: context.sp(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
