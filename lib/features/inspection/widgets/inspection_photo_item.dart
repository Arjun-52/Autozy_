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
        border: Border.all(
          color: photo.uploadStatus == 'error'
              ? Colors.redAccent.withOpacity(0.5)
              : photo.uploadStatus == 'success'
                  ? Colors.green.withOpacity(0.5)
                  : Colors.transparent,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (photo.uploadStatus == 'uploading') {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xffF4C430),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Uploading",
              style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    if (photo.uploadStatus == 'error') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 24),
            const SizedBox(height: 4),
            Text(
              photo.label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
            const Text(
              "Retry",
              style: TextStyle(fontSize: 10, color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    if (photo.imageFile != null || photo.url != null) {
      return Stack(
        children: [
          photo.url != null && photo.url!.isNotEmpty
              ? Image.network(
                  photo.url!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    if (photo.imageFile != null) {
                      return Image.file(
                        photo.imageFile!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      );
                    }
                    return const Center(child: Icon(Icons.broken_image, color: Colors.grey));
                  },
                )
              : Image.file(
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
                color: photo.uploadStatus == 'success' ? Colors.green : Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                photo.uploadStatus == 'success' ? Icons.check : Icons.refresh,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.camera_alt_outlined, color: Colors.grey, size: 24),
        const SizedBox(height: 6),
        Text(
          photo.label,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ],
    );
  }
}
