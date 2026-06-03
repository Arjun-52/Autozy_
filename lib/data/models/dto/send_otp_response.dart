class SendOtpResponse {
  final bool success;
  final SendOtpData? data;
  final String? timestamp;

  SendOtpResponse({
    required this.success,
    this.data,
    this.timestamp,
  });

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) {
    return SendOtpResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? SendOtpData.fromJson(json['data']) : null,
      timestamp: json['timestamp'],
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

class SendOtpData {
  final String message;

  SendOtpData({required this.message});

  factory SendOtpData.fromJson(Map<String, dynamic> json) {
    return SendOtpData(
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
