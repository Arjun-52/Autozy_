import 'package:flutter/material.dart';

class SuccessIcon extends StatelessWidget {
  const SuccessIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffC7E9D7),
      ),
      child: const Center(
        child: CircleAvatar(
          radius: 40,
          backgroundColor: Color(0xff24B36B),
          child: Icon(Icons.check, color: Colors.white, size: 40),
        ),
      ),
    );
  }
}
