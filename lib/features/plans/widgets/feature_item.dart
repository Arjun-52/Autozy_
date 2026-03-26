import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';

class FeatureItem extends StatelessWidget {
  final String text;
  final bool isSelected;

  const FeatureItem({super.key, required this.text, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            Icons.check,
            size: 16,
            color: isSelected
                ? const Color(0xFFFFCB2F) // 🟡 selected
                : const Color(0xFF7E8392), // ⚫ not selected
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyText2.copyWith(
                color: isSelected ? Colors.black : const Color(0xFF7E8392),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
