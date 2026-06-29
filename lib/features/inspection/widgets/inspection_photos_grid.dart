import 'package:autozy/features/inspection/models/inspection_photo_model.dart';
import 'package:autozy/features/inspection/widgets/inspection_photo_item.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../providers/inspection_provider.dart';
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
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo (Camera)'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    debugPrint("--- Image selection started for: ${photos[index].label} from $source ---");

    if (source == ImageSource.camera) {
      var status = await Permission.camera.status;
      if (status.isDenied) {
        status = await Permission.camera.request();
      }

      if (status.isPermanentlyDenied) {
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
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (image != null) {
        setState(() {
          photos[index].imageFile = File(image.path);
          photos[index].uploadStatus = 'uploading';
          photos[index].error = null;
        });

        debugPrint("Image selected. Path: ${image.path}. Upload started...");
        final provider = context.read<InspectionProvider>();
        final success = await provider.uploadImage(File(image.path));

        if (success) {
          debugPrint("Image uploaded successfully. URL: ${provider.uploadedImageUrl}");
          setState(() {
            photos[index].uploadStatus = 'success';
            photos[index].url = provider.uploadedImageUrl;
            photos[index].key = provider.uploadedImageKey;
          });
        } else {
          debugPrint("Image upload failed: ${provider.uploadError}");
          setState(() {
            photos[index].uploadStatus = 'error';
            photos[index].error = provider.uploadError;
          });
        }
      }
    } catch (e) {
      debugPrint("Action failed: Error selecting/uploading image: $e");
      setState(() {
        photos[index].uploadStatus = 'error';
        photos[index].error = e.toString();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
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
              return InspectionPhotoItem(photo: photos[index]);
            },
          ),
        ],
      ),
    );
  }
}
