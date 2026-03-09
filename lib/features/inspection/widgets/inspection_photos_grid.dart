import 'package:flutter/material.dart';
import '../models/inspection_photo_model.dart';
import 'inspection_photo_item.dart';

class InspectionPhotosGrid extends StatelessWidget {
  const InspectionPhotosGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final photos = [
      InspectionPhotoModel(label: "Front"),
      InspectionPhotoModel(label: "Rear"),
      InspectionPhotoModel(label: "Side L"),
      InspectionPhotoModel(label: "Side R"),
      InspectionPhotoModel(label: "Interior"),
      InspectionPhotoModel(label: "Dashboard"),
    ];

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            "Inspection Photos",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),

          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),

            itemCount: photos.length,

            itemBuilder: (context, index) {
              return InspectionPhotoItem(photo: photos[index]);
            },
          ),
        ],
      ),
    );
  }
}
