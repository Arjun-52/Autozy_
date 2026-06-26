import 'package:flutter/material.dart';
import '../../../core/utils/responsive.dart';

class SuccessIcon extends StatelessWidget {
  const SuccessIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.w(100),
      height: context.w(100),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffC7E9D7),
      ),
      child: Center(
        child: CircleAvatar(
          radius: context.w(35),
          backgroundColor: const Color(0xff24B36B),
          child: Icon(Icons.check, color: Colors.white, size: context.w(35)),
        ),
      ),
    );
  }
}
