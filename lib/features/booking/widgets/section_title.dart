import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';

class SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const SectionTitle({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
     return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(6)),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: context.w(20)),
          SizedBox(width: context.w(8)),
          Text(
            title,
            style: TextStyle(
              fontSize: context.sp(14),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }
}
