import 'dart:io';
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

      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: photo.imageFile != null
            ? Stack(
                children: [
                  Image.file(
                    photo.imageFile!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),

                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.refresh,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt_outlined, color: Colors.grey),

                  const SizedBox(height: 6),

                  Text(photo.label, style: const TextStyle(fontSize: 12)),
                ],
              ),
      ),
    );
  }
}
