import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class OtpInputFields extends StatelessWidget {
  const OtpInputFields({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

      children: List.generate(
        4,
        (index) => Container(
          width: 55,
          height: 60,
          alignment: Alignment.center,

          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),

          child: const TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,

            decoration: InputDecoration(
              counterText: "",
              border: InputBorder.none,
            ),

            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
