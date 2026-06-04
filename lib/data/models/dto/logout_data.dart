class LogoutData {
  final String message;

  LogoutData({required this.message});

  factory LogoutData.fromJson(Map<String, dynamic> json) => LogoutData(
        message: json['message'] ?? '',
      );
}
