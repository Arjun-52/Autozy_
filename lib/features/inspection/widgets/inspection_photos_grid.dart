import 'package:autozy/features/inspection/models/inspection_photo_model.dart';
import 'package:autozy/features/inspection/widgets/inspection_photo_item.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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
    debugPrint("--- Camera process started for: ${photos[index].label} ---");

    try {
      // Check permission status
      var status = await Permission.camera.status;
      debugPrint("Permission status (Initial check): $status");

      if (status.isDenied) {
        debugPrint("Camera permission is denied. Requesting permission...");
        status = await Permission.camera.request();
        debugPrint("Permission status (After request): $status");
      }

      if (status.isPermanentlyDenied) {
        debugPrint("Camera permission permanently denied. Guiding user to app settings.");
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Camera Permission Required"),
              content: const Text(
                "Camera permission is permanently denied. Please enable camera access in app settings to capture inspection photos.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await openAppSettings();
                  },
                  child: const Text("Open Settings"),
                ),
              ],
            ),
          );
        }
        return;
      }

      if (status.isDenied) {
        debugPrint("Camera permission denied by user.");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Camera permission is required to capture photos."),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      if (status.isGranted || status.isLimited) {
        debugPrint("Camera permission is granted. Attempting to open device camera...");
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 70,
        );

        if (image != null) {
          debugPrint("Image captured successfully. Path: ${image.path}");
          setState(() {
            photos[index].imageFile = File(image.path);
          });
        } else {
          debugPrint("Capture cancelled: User closed camera without taking a photo.");
        }
      }
    } catch (e) {
      debugPrint("Capture failed: Error opening camera: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error opening camera: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
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
