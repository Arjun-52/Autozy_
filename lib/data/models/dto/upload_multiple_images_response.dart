import 'upload_image_response.dart';

class UploadMultipleImagesResponse {
  final bool success;
  final List<UploadedImageModel> data;
  final String? timestamp;

  UploadMultipleImagesResponse({
    required this.success,
    required this.data,
    this.timestamp,
  });

  factory UploadMultipleImagesResponse.fromJson(Map<String, dynamic> json) {
    return UploadMultipleImagesResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => UploadedImageModel.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
      timestamp: json['timestamp'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((item) => item.toJson()).toList(),
      'timestamp': timestamp,
    };
  }
}
