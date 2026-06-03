class SendOtpRequest {
  final String phone;

  SendOtpRequest({required this.phone});

  static String? validatePhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return "Phone number is required";
    }
    final trimmed = phone.trim();
    // Validates standard 10 digit numbers starting with 6-9
    final regex = RegExp(r'^[6-9]\d{9}$');
    if (!regex.hasMatch(trimmed)) {
      return "Enter a valid 10 digit mobile number";
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone.trim(),
    };
  }
}
