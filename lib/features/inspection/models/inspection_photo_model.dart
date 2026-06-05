import 'dart:io';

class InspectionPhotoModel {
  final String label;
  File? imageFile;
  String? url;
  String? key;
  String uploadStatus; // 'initial', 'uploading', 'success', 'error'
  String? error;

  InspectionPhotoModel({
    required this.label,
    this.imageFile,
    this.url,
    this.key,
    this.uploadStatus = 'initial',
    this.error,
  });
}
