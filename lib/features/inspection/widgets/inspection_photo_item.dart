import 'package:flutter/material.dart';
import '../models/inspection_photo_model.dart';

class InspectionPhotoItem extends StatelessWidget {
  final InspectionPhotoModel photo;

  const InspectionPhotoItem({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffEEEEEE),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt_outlined),

          const SizedBox(height: 6),

          Text(photo.label),
        ],
      ),
    );
  }
}
