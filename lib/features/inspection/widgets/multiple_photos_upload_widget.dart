import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../providers/inspection_provider.dart';
import '../../../core/utils/app_logger.dart';

class MultiplePhotosUploadWidget extends StatefulWidget {
  const MultiplePhotosUploadWidget({super.key});

  @override
  State<MultiplePhotosUploadWidget> createState() => _MultiplePhotosUploadWidgetState();
}

class _MultiplePhotosUploadWidgetState extends State<MultiplePhotosUploadWidget> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedFiles = [];
  String? _validationError;

  Future<void> _pickImages(ImageSource source) async {
    setState(() {
      _validationError = null;
    });

    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        setState(() {
          _validationError = "Camera permission is required.";
        });
        return;
      }
    }

    try {
      if (source == ImageSource.gallery) {
        AppLogger.info('Images selection started from Gallery', tag: 'Upload');
        final List<XFile> images = await _picker.pickMultiImage(
          imageQuality: 70,
        );

        if (images.isNotEmpty) {
          if (_selectedFiles.length + images.length > 5) {
            setState(() {
              _validationError = "Maximum 5 images allowed. You selected too many.";
            });
            AppLogger.error('Validation failed: More than 5 images selected.', tag: 'Upload');
            return;
          }

          setState(() {
            _selectedFiles.addAll(images.map((img) => File(img.path)));
          });
          AppLogger.info('Images selected. Count: ${_selectedFiles.length}', tag: 'Upload');
        }
      } else {
        AppLogger.info('Image capture started from Camera', tag: 'Upload');
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 70,
        );

        if (image != null) {
          if (_selectedFiles.length + 1 > 5) {
            setState(() {
              _validationError = "Maximum 5 images allowed.";
            });
            AppLogger.error('Validation failed: More than 5 images limit reached.', tag: 'Upload');
            return;
          }

          setState(() {
            _selectedFiles.add(File(image.path));
          });
          AppLogger.info('Image captured and added. Count: ${_selectedFiles.length}', tag: 'Upload');
        }
      }
    } catch (e) {
      setState(() {
        _validationError = "Failed to select images: $e";
      });
      AppLogger.error('Error selecting images: $e', tag: 'Upload');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
      _validationError = null;
    });
    AppLogger.info('Image removed from selection list. Remaining: ${_selectedFiles.length}', tag: 'Upload');
  }

  Future<void> _uploadImages() async {
    if (_selectedFiles.isEmpty) {
      setState(() {
        _validationError = "Please select at least one image to upload.";
      });
      return;
    }

    setState(() {
      _validationError = null;
    });

    final provider = context.read<InspectionProvider>();
    AppLogger.info('Upload started for ${_selectedFiles.length} images', tag: 'Upload');
    final success = await provider.uploadMultipleImages(_selectedFiles);

    if (success) {
      AppLogger.info('Upload completed successfully. URLs stored.', tag: 'Upload');
    } else {
      AppLogger.error('Upload failed: ${provider.multipleUploadError}', tag: 'Upload');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InspectionProvider>();
    final isUploading = provider.multipleUploadStatus == 'uploading';
    final isSuccess = provider.multipleUploadStatus == 'success';
    final isError = provider.multipleUploadStatus == 'error';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Upload Documentation",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Text(
                "${_selectedFiles.length}/5 selected",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (!isUploading && !isSuccess)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffEEEEEE),
                      foregroundColor: Colors.black87,
                      elevation: 0,
                    ),
                    onPressed: _selectedFiles.length >= 5 ? null : () => _pickImages(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffEEEEEE),
                      foregroundColor: Colors.black87,
                      elevation: 0,
                    ),
                    onPressed: _selectedFiles.length >= 5 ? null : () => _pickImages(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Gallery"),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),

          if (_validationError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _validationError!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),

          if (_selectedFiles.isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedFiles.length,
                itemBuilder: (context, index) {
                  final file = _selectedFiles[index];
                  final hasRemote = isSuccess && provider.uploadedImageUrls.length > index;
                  final imageUrl = hasRemote ? provider.uploadedImageUrls[index] : null;

                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSuccess ? Colors.green : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: imageUrl != null
                              ? Image.network(
                                  imageUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  file,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        if (!isUploading && !isSuccess)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        if (isSuccess)
                          const Positioned(
                            bottom: 4,
                            right: 4,
                            child: Icon(Icons.check_circle, color: Colors.green, size: 18),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

          if (isUploading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
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
                  SizedBox(width: 12),
                  Text(
                    "Uploading images...",
                    style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
                  ),
                ],
              ),
            ),

          if (isSuccess)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    "Upload completed",
                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green),
                  ),
                ],
              ),
            ),

          if (isError)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          provider.multipleUploadError ?? "Upload failed",
                          style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: isUploading ? null : _uploadImages,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: const Text("Retry Upload", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          if (!isUploading && !isSuccess && !isError)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _selectedFiles.isEmpty ? null : _uploadImages,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffF4C430),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Upload Selected Images",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
