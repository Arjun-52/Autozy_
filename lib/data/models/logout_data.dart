class LogoutData {
  final String? message;

  LogoutData({this.message});

  factory LogoutData.fromJson(Map<String, dynamic> json) {
    return LogoutData(
      message: json['message'] as String?,
    );
  }
}
