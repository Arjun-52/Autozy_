import 'package:autozy/features/inspection/models/inspection_photo_model.dart';
import 'package:autozy/features/inspection/widgets/inspection_photo_item.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class InspectionPhotosGrid extends StatefulWidget {
  const InspectionPhotosGrid({super.key});

  @override
  State<InspectionPhotosGrid> createState() => _InspectionPhotosGridState();
}

class _InspectionPhotosGridState extends State<InspectionPhotosGrid> {
  final ImagePicker _picker = ImagePicker();

  final List<InspectionPhotoModel> photos = [
    InspectionPhotoModel(label: "Front"),
    InspectionPhotoModel(label: "Rear"),
    InspectionPhotoModel(label: "Side L"),
    InspectionPhotoModel(label: "Side R"),
    InspectionPhotoModel(label: "Interior"),
    InspectionPhotoModel(label: "Dashboard"),
  ];

  Future<void> _capturePhoto(int index) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (image != null) {
      setState(() {
        photos[index].imageFile = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
              return GestureDetector(
                onTap: () => _capturePhoto(index),
                child: InspectionPhotoItem(photo: photos[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}
