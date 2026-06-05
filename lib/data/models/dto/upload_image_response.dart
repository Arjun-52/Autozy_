class UploadImageResponse {
  final bool success;
  final UploadedImageModel? data;
  final String? timestamp;

  UploadImageResponse({
    required this.success,
    this.data,
    this.timestamp,
  });

  factory UploadImageResponse.fromJson(Map<String, dynamic> json) {
    return UploadImageResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null
          ? UploadedImageModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      timestamp: json['timestamp'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
      'timestamp': timestamp,
    };
  }
}

class UploadedImageModel {
  final String url;
  final String key;

  UploadedImageModel({
    required this.url,
    required this.key,
  });

  factory UploadedImageModel.fromJson(Map<String, dynamic> json) {
    return UploadedImageModel(
      url: json['url'] as String? ?? '',
      key: json['key'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'key': key,
    };
  }
}
